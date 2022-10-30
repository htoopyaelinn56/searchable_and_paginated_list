import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchProvider =
    FutureProvider.family<List<String>, int>((ref, page) async {
  await Future.delayed(const Duration(seconds: 1));
  return [for (int i = 0; i < 30; i++) generateRandomString(28)];
});
String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
