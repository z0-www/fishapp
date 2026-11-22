import 'dart:io';

import 'package:fish_converter/fish_converter.dart';

void main() {
  final dir = Directory('test-files');
  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => !file.path.endsWith('README.md'))
      .where((file) => !file.path.endsWith('鱼者转换器-测试文件包.zip'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  for (final file in files) {
    if (!file.path.endsWith('.json') &&
        !file.path.endsWith('.md') &&
        !file.path.endsWith('.txt') &&
        !file.path.endsWith('.zip')) {
      continue;
    }
    try {
      final result = parseConversationFile(
        file.uri.pathSegments.last,
        file.readAsBytesSync(),
      );
      final counts = result.sessions
          .map((s) => '${s.title}:${s.messages.length}')
          .join(' | ');
      stdout.writeln('OK   ${file.path} => ${result.format} | $counts');
    } on ConversionException catch (error) {
      stdout.writeln('FAIL ${file.path} => ${error.message}');
    }
  }
}
