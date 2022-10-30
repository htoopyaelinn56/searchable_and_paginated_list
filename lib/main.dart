import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searachable_list/controller/parent_list_controller.dart';
import 'package:searachable_list/repo/repo.dart';
import 'package:searachable_list/service/fetch_service.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    ref.read(fetchServiceProvider).initialFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
        } else {
          ref.read(fetchServiceProvider).fetchData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(searchList(_controller.text));
    final parentList = ref.watch(parentListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Card Generator'),
        actions: [
          InkWell(
            onTap: () {
              ref.read(fetchServiceProvider).clearData();
              _controller.clear();
            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: parentList.isEmpty &&
              ref.watch(fetchProvider(ref.watch(pageProvider))).isLoading &&
              _controller.text.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TextField(
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                Flexible(
                  child: list.isEmpty
                      ? const Text('No Results')
                      : ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == list.length) {
                              if (ref.watch(pageProvider) < 20) {
                                return ref
                                        .watch(fetchProvider(
                                            ref.watch(pageProvider)))
                                        .isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : const SizedBox.shrink();
                              }
                            }
                            return Text(
                              list[index],
                            );
                          },
                          itemCount: ref.watch(pageProvider) < 20
                              ? list.length + 1
                              : list.length,
                        ),
                ),
              ],
            ),
    );
  }
}
