import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'web_file_vault.dart';

Future<int> length(String ref) async => WebFileVault.instance.bytesOf(ref).length;

Future<Uint8List> readBytes(String ref) async =>
    WebFileVault.instance.bytesOf(ref);

Future<Uint8List> readHead(String ref, int count) async {
  final bytes = WebFileVault.instance.bytesOf(ref);
  return Uint8List.sublistView(bytes, 0, min(count, bytes.length));
}

Future<String> readText(String ref) async =>
    utf8.decode(WebFileVault.instance.bytesOf(ref), allowMalformed: false);
