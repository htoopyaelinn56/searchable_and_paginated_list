import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searachable_list/controller/parent_list_controller.dart';
import 'package:searachable_list/repo/repo.dart';

class FetchService {
  final Ref ref;
  FetchService(this.ref);

  Future<void> initialFetch() async {
    for (int i = 0; i < 3; i++) {
      await fetchData();
    }
  }

  Future<void> fetchData() async {
    final data = await ref.read(fetchProvider(ref.read(pageProvider)).future);
    if (ref.read(pageProvider) < 20) {
      ref.read(parentListProvider.notifier).addData(data);
      ref.read(pageProvider.notifier).state++;
    }
  }
}

final fetchServiceProvider = Provider<FetchService>((ref) {
  return FetchService(ref);
});
