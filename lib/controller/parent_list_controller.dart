import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParentList extends StateNotifier<List<String>> {
  ParentList() : super([]);

  void addData(List<String> data) {
    state.addAll(data);
    state = [...state];
  }

  void clearList() {
    state.clear();
    state = [...state];
  }
}

final parentListProvider =
    StateNotifierProvider<ParentList, List<String>>((ref) {
  return ParentList();
});

final pageProvider = StateProvider<int>((_) => 1);

final searchList = Provider.family<List<String>, String>((ref, query) {
  final list = ref.watch(parentListProvider);
  return list.where((element) => element.contains(query)).toList();
});
