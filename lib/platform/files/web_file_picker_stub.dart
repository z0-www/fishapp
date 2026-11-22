import 'web_file_picker.dart';

bool get available => false;

Future<List<WebPickedFile>> pickWebFiles({
  bool multiple = true,
  bool yuzheOnly = false,
}) async => throw UnsupportedError('当前平台不支持浏览器文件选择。');
