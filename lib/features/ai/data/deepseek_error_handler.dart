import 'package:dio/dio.dart';

const missingDeepSeekKeyMessage = '尚未配置 DeepSeek API Key，请先前往 AI 服务设置。';

class DeepSeekFailure implements Exception {
  const DeepSeekFailure(this.message, {this.status});
  final int? status;
  bool get rejectedBeforeGeneration =>
      const {400, 401, 402, 403, 404, 413, 422, 429}.contains(status);
  final String message;
  @override
  String toString() => message;
}

abstract final class DeepSeekErrorHandler {
  /// Phase-specific timeout messages. A phone that can open the official site
  /// but fails only on generation needs to know whether the connection, the
  /// upload or the reply wait failed.
  static const connectTimeoutMessage = '连接超时：30 秒内未能建立到 api.deepseek.com 的连接。';
  static const sendTimeoutMessage = '发送超时：请求未能在 30 秒内完成上传。';
  static const receiveTimeoutMessage = '等待超时：180 秒内未收到响应数据。';
  static const streamServiceErrorMessage = '模型服务在回复过程中返回错误，本轮未保存。';
  static const redirectMessage = '接口返回重定向，已停止请求。';

  static DeepSeekFailure fromStatus(int? status) =>
      DeepSeekFailure(switch (status) {
        400 => '请求格式错误，请检查客户端版本。',
        401 => 'API Key 无效，请检查或更换密钥。',
        402 => '账户余额不足，请前往官方平台查看。',
        403 => '访问被拒绝，请检查账户状态或稍后重试。',
        404 => '接口地址不可用，请检查客户端版本。',
        408 => '请求超时，请检查网络后重试。',
        413 => '请求内容过长，请精简上下文。',
        422 => '请求参数不受支持，请检查客户端版本。',
        429 => '请求频率受限，请稍后重试。',
        500 => '服务端错误，请稍后重试。',
        502 => '服务网关异常，请稍后重试。',
        int code when code >= 300 && code < 400 => redirectMessage,
        503 => '服务繁忙，请稍后重试。',
        504 => '请求超时，请检查网络后重试。',
        _ => '连接失败，请检查网络后重试。',
      }, status: status);

  static const _allowed = {
    '请求格式错误，请检查客户端版本。',
    'API Key 无效，请检查或更换密钥。',
    '账户余额不足，请前往官方平台查看。',
    '访问被拒绝，请检查账户状态或稍后重试。',
    '接口地址不可用，请检查客户端版本。',
    '请求超时，请检查网络后重试。',
    connectTimeoutMessage,
    sendTimeoutMessage,
    receiveTimeoutMessage,
    streamServiceErrorMessage,
    redirectMessage,
    '服务网关异常，请稍后重试。',
    '请求内容过长，请精简上下文。',
    '请求参数不受支持，请检查客户端版本。',
    '请求频率受限，请稍后重试。',
    '服务端错误，请稍后重试。',
    '服务繁忙，请稍后重试。',
    '连接失败，请检查网络后重试。',
    '服务响应为空，请稍后重试。',
    '安全存储暂时不可用，请解锁设备后重试；原密钥不会主动清除。',
    '当前版本暂未启用 DeepSeek 在线服务。',
    '响应格式异常，未确认连接成功。',
    '已停止请求；服务端可能已消耗 Token。',
    '已停止生成，未修改世界。',
    '流式响应格式异常，请重试。',
    '流式响应过大，已停止。',
    '流式连接中断，请重试。',
    '流式连接中断，未收到完成标记，请重试。',
    '模型输出达到上限，本轮未提交；请缩短上下文或重试。',
    '上游模型返回内容过滤状态，本轮未提交；可调整表达范围后重新确认。',
    '服务资源不足，本轮未提交，请稍后重试。',
    '生成被中断，本轮未提交。',
    '模型返回了工具调用而非正文，本轮未提交。',
    '模型返回空内容（JSON 输出可能被过滤或截断），本轮未提交。',
    '模型输出不是有效 JSON；本轮未提交，请重试。',
    '回复协议无效；未提交正文或状态。',
    '回复过长，未提交状态。',
    '请输入格式完整的 API Key。',
    '尚未保存密钥，请先配置。',
    missingDeepSeekKeyMessage,
    '本轮不提供故事生成服务。',
    '需要先确认预算。',
  };

  static String diagnosticMessage(String message) =>
      _allowed.contains(message) ? message : '请求或本地校验未完成，请查看对应页面。';

  static DeepSeekFailure sanitize(Object error) {
    if (error is DeepSeekFailure) {
      return _allowed.contains(error.message) ? error : fromStatus(null);
    }
    if (error is DioException) {
      if (error.type == DioExceptionType.cancel) {
        return const DeepSeekFailure('已停止请求；服务端可能已消耗 Token。');
      }
      if (error.type == DioExceptionType.connectionTimeout) {
        return const DeepSeekFailure(connectTimeoutMessage);
      }
      if (error.type == DioExceptionType.sendTimeout) {
        return const DeepSeekFailure(sendTimeoutMessage);
      }
      if (error.type == DioExceptionType.receiveTimeout) {
        return const DeepSeekFailure(receiveTimeoutMessage);
      }
      if (error.response?.statusCode case final status? when status >= 300) {
        return fromStatus(status);
      }
      if (error.error is FormatException) {
        return const DeepSeekFailure('响应格式异常，未确认连接成功。');
      }
      return fromStatus(null);
    }
    return fromStatus(null);
  }
}
