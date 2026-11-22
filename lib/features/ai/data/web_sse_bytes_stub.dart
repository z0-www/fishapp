import 'dart:async';

import 'package:dio/dio.dart';

bool get available => false;

Stream<List<int>> stream({
  required String key,
  required String model,
  required List<Map<String, String>> messages,
  required int maxOutput,
  required bool thinking,
  required CancelToken cancelToken,
  void Function(int)? onResponseStatus,
}) => const Stream<List<int>>.empty();
