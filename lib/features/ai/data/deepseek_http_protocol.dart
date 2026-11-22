import 'deepseek_balance.dart';

import 'dart:convert';

import 'package:dio/dio.dart';

import 'deepseek_error_handler.dart';
import 'deepseek_models.dart';
import 'web_sse_stream.dart';

/// Protocol only: no Flutter, credential persistence, logging or retries.
/// App code must use the policy-guarded DeepSeekApiClient, never this directly.
abstract interface class DeepSeekTransport {
  Future<ConnectionReceipt> testConnection(String key);
  Stream<Map<String, dynamic>> streamMessages(
    String key,
    List<Map<String, String>> messages, {
    required CancelToken cancelToken,
    int maxOutput = 1200,
  });
  void close();
}

class ConnectionReceipt {
  const ConnectionReceipt(
    this.model,
    this.elapsed,
    this.usage, {
    this.httpStatus,
  });
  final int? httpStatus;
  final String model;
  final Duration elapsed;
  final Map<String, int> usage;
}

class DeepSeekHttpProtocol implements DeepSeekTransport {
  DeepSeekHttpProtocol({
    this.model = DeepSeekModels.defaultModel,
    this.thinking = false,
    HttpClientAdapter? adapter,
    this.onHttpStatus,
    this.onProbeText,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: 'https://api.deepseek.com',
           connectTimeout: connectTimeout,
           sendTimeout: sendTimeout,
           receiveTimeout: receiveTimeout,
           followRedirects: false,
         ),
       ) {
    if (adapter != null) _dio.httpClientAdapter = adapter;
  }

  /// Mobile networks can need longer than 15 s for DNS + TCP + TLS. A failed
  /// connect is reported separately from a slow generation.
  static const connectTimeout = Duration(seconds: 30);
  static const sendTimeout = Duration(seconds: 30);

  /// Streaming responses are watched between chunks, not as a total budget.
  /// Long roleplay turns legitimately take more than a minute on a phone.
  static const receiveTimeout = Duration(seconds: 180);
  final String model;
  final Dio _dio;
  final bool thinking;
  final void Function(int)? onHttpStatus;
  final void Function(String)? onProbeText;

  Future<DeepSeekBalance> balance(String key) async {
    _key(key);
    try {
      final response = await _dio.get<Object?>(
        '/user/balance',
        options: Options(
          headers: {'Authorization': 'Bearer $key'},
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      if (response.statusCode != 200) throw const FormatException();
      return DeepSeekBalance.fromResponse(response.data, DateTime.now());
    } catch (error) {
      throw DeepSeekErrorHandler.sanitize(error);
    }
  }

  Future<List<String>> listModels(String key) async {
    _key(key);
    try {
      final response = await _dio.get<Object?>(
        '/models',
        options: Options(headers: {'Authorization': 'Bearer $key'}),
      );
      if (response.statusCode case final status?) onHttpStatus?.call(status);
      final data = response.data;
      if (data is! Map || data['data'] is! List) {
        throw const DeepSeekFailure('响应格式异常，未确认连接成功。');
      }
      return (data['data'] as List)
          .whereType<Map>()
          .map((m) => m['id'])
          .whereType<String>()
          .where(
            (id) => RegExp(r'^deepseek-[a-zA-Z0-9._-]{1,80}$').hasMatch(id),
          )
          .toSet()
          .toList();
    } catch (e) {
      _observeErrorStatus(e);
      throw DeepSeekErrorHandler.sanitize(e);
    }
  }

  void _key(String key) {
    if (key.length < 8 || key.length > 512 || RegExp(r'\s').hasMatch(key)) {
      throw const DeepSeekFailure('请输入格式完整的 API Key。');
    }
  }

  @override
  Future<ConnectionReceipt> testConnection(String key) async {
    _key(key);
    final watch = Stopwatch()..start();
    int? receivedStatus;
    try {
      final response = await _dio.post<Object?>(
        '/chat/completions',
        data: {
          'model': model,
          'messages': [
            {'role': 'user', 'content': 'Reply OK.'},
          ],
          'max_tokens': 8,
          'stream': false,
          'thinking': {'type': 'disabled'},
        },
        options: Options(headers: {'Authorization': 'Bearer $key'}),
      );
      receivedStatus = response.statusCode;
      if (receivedStatus case final status?) onHttpStatus?.call(status);
      final data = response.data;
      if (data is! Map ||
          data['error'] != null ||
          data['model'] is! String ||
          !RegExp(r'^deepseek-[a-zA-Z0-9._-]{1,80}$')
              .hasMatch(data['model'] as String) ||
          data['choices'] is! List ||
          (data['choices'] as List).length != 1) {
        throw const DeepSeekFailure('响应格式异常，未确认连接成功。');
      }
      final choice = (data['choices'] as List).single;
      // A tiny max_tokens probe may legitimately end with "length"; either
      // non-empty reply proves authentication and transport work.
      final finish = choice is Map ? choice['finish_reason'] : null;
      if (choice is! Map ||
          choice['message'] is! Map ||
          choice['message']['content'] is! String ||
          (choice['message']['content'] as String).trim().isEmpty ||
          (finish != 'stop' && finish != 'length')) {
        throw const DeepSeekFailure('响应格式异常，未确认连接成功。');
      }
      final usage = readUsage(data['usage']);
      onProbeText?.call((choice['message']['content'] as String).trim());
      return ConnectionReceipt(
        data['model'] as String,
        watch.elapsed,
        usage,
        httpStatus: response.statusCode,
      );
    } catch (e) {
      _observeErrorStatus(e);
      final failure = DeepSeekErrorHandler.sanitize(e);
      throw DeepSeekFailure(
        failure.message,
        status:
            receivedStatus ??
            (e is DioException ? e.response?.statusCode : null) ??
            failure.status,
      );
    }
  }

  /// Only server-reported nonnegative integers are accepted; no guessed bills.
  static Map<String, int> readUsage(Object? value) {
    if (value == null) return {};
    if (value is! Map) {
      throw const DeepSeekFailure('响应格式异常，未确认连接成功。');
    }
    int? number(Object? raw) {
      if (raw == null) return null;
      if (raw is int && raw >= 0) return raw;
      // Some JSON codecs surface whole numbers as num rather than int.
      if (raw is num &&
          raw.isFinite &&
          raw >= 0 &&
          raw == raw.roundToDouble()) {
        return raw.toInt();
      }
      throw const DeepSeekFailure('响应格式异常，未确认连接成功。');
    }

    final result = <String, int>{};
    for (final field in [
      'prompt_tokens',
      'completion_tokens',
      'prompt_cache_hit_tokens',
      'prompt_cache_miss_tokens',
      'total_tokens',
    ]) {
      final n = number(value[field]);
      if (n != null) result[field] = n;
    }
    // Older/alternative shape documented by DeepSeek.
    final details = value['prompt_tokens_details'];
    if (!result.containsKey('prompt_cache_hit_tokens') && details is Map) {
      final cached = number(details['cached_tokens']);
      if (cached != null) result['prompt_cache_hit_tokens'] = cached;
    }
    if ((result['prompt_cache_hit_tokens'] ?? 0) >
        (result['prompt_tokens'] ?? 0)) {
      throw const DeepSeekFailure('响应格式异常，未确认连接成功。');
    }
    return result;
  }

  /// Maps DeepSeek's streaming finish_reason to a safe, explicit Chinese
  /// error. `null` means the stream ended without a completion marker.
  static String? finishIssue(String? finishReason) => switch (finishReason) {
    'stop' => null,
    'length' => '模型输出达到上限，剧情未写完，本轮未保存。可调整目标字数后手动重试。',
    'content_filter' => '上游模型返回内容过滤状态，本轮未提交；可调整表达范围后重新确认。',
    'insufficient_system_resource' => '服务资源不足，本轮未提交，请稍后重试。',
    'aborted' => '生成被中断，本轮未提交。',
    'tool_calls' => '模型返回了工具调用而非正文，本轮未提交。',
    null => '流式连接中断，未收到完成标记，请重试。',
    _ => '模型未正常完成，本轮未提交，请重试。',
  };

  @override
  Stream<Map<String, dynamic>> streamMessages(
    String key,
    List<Map<String, String>> messages, {
    required CancelToken cancelToken,
    int maxOutput = 1200,
    void Function(int)? onResponseStatus,
  }) async* {
    _key(key);
    try {
      if (webSseAvailable) {
        // Browser: fetch + ReadableStream keeps real incremental streaming.
        yield* decodeSse(
          webSseBytes(
            key: key,
            model: model,
            messages: messages,
            maxOutput: maxOutput,
            thinking: thinking,
            cancelToken: cancelToken,
            onResponseStatus: onResponseStatus,
          ),
        );
        return;
      }
      final response = await _dio.post<ResponseBody>(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages,
          'max_tokens': maxOutput,
          'stream': true,
          'response_format': {'type': 'json_object'},
          'thinking': {'type': thinking ? 'enabled' : 'disabled'},
          'stream_options': {'include_usage': true},
        },
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Authorization': 'Bearer $key',
            'Accept': 'text/event-stream',
          },
        ),
      );
      if (response.statusCode case final status?) {
        onHttpStatus?.call(status);
        onResponseStatus?.call(status);
      }
      if (response.data == null ||
          !(response.headers.value('content-type') ?? '')
              .toLowerCase()
              .startsWith('text/event-stream')) {
        throw const DeepSeekFailure('流式响应格式异常，请重试。');
      }
      yield* decodeSse(response.data!.stream);
    } catch (e) {
      _observeErrorStatus(e);
      throw DeepSeekErrorHandler.sanitize(e);
    }
  }

  void _observeErrorStatus(Object error) {
    if (error is DioException && error.response?.statusCode != null) {
      onHttpStatus?.call(error.response!.statusCode!);
    }
  }

  /// UTF-8, CRLF, comments, multiple data lines and arbitrary byte boundaries.
  /// A DONE event is required: EOF never masquerades as a completed generation.
  static Stream<Map<String, dynamic>> decodeSse(
    Stream<List<int>> bytes,
  ) async* {
    var lines = <String>[];
    var size = 0;
    Map<String, dynamic> parse(String payload) {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) throw const FormatException();
      if (decoded['error'] != null) {
        // HTTP headers may already be 200. An error frame does not prove
        // pre-generation rejection and must not clear unknown usage.
        throw const DeepSeekFailure(
          DeepSeekErrorHandler.streamServiceErrorMessage,
        );
      }
      return decoded;
    }

    try {
      // Dio exposes ResponseBody.stream as Stream<Uint8List>; cast so the
      // Utf8Decoder transformer receives the declared List<int> element type.
      final text = bytes.cast<List<int>>().transform(utf8.decoder);
      await for (final line in text.transform(const LineSplitter())) {
        if (line.isEmpty) {
          if (lines.isEmpty) continue;
          final payload = lines.join('\n');
          lines = [];
          size = 0;
          if (payload.trim() == '[DONE]') return;
          yield parse(payload);
        } else if (line.startsWith('data:')) {
          final value = line.substring(5).replaceFirst(RegExp(r'^ '), '');
          size += value.length + 1;
          if (size > 1024 * 1024) {
            throw const DeepSeekFailure('流式响应过大，已停止。');
          }
          lines.add(value);
        }
      }
      // Some servers terminate the DONE line without a trailing blank line.
      if (lines.join('\n').trim() == '[DONE]') return;
      throw const DeepSeekFailure('流式连接中断，请重试。');
    } on FormatException {
      throw const DeepSeekFailure('流式响应格式异常，请重试。');
    }
  }

  @override
  void close() => _dio.close(force: true);
}
