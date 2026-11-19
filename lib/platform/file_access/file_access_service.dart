import 'package:flutter/services.dart';

import '../../features/import_center/domain/import_models.dart';

class FileAccessService {
  const FileAccessService();
  Future<bool> pickFiles() async {
    try {
      return await const MethodChannel('fish/share_intake')
              .invokeMethod<bool>('pickFiles') ??
          false;
    } on MissingPluginException {
      throw const ImportFailure('此开发环境不支持系统文件选择，请使用手机测试。');
    } on PlatformException {
      throw const ImportFailure('文件无法读取或超过暂存限制，请选择较小文件重试。');
    }
  }
}
