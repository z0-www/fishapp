import 'dart:io';
import 'dart:typed_data';

Future<int> length(String ref) => File(ref).length();

Future<Uint8List> readBytes(String ref) => File(ref).readAsBytes();

Future<Uint8List> readHead(String ref, int count) async {
  final handle = await File(ref).open();
  try {
    return await handle.read(count);
  } finally {
    await handle.close();
  }
}

Future<String> readText(String ref) => File(ref).readAsString();
