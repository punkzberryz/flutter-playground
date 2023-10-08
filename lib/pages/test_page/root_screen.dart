import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RootScreen extends HookConsumerWidget {
  const RootScreen({super.key, required this.label, required this.detailsPath});
  final String label;
  final String detailsPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab root - $label'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () => context.go(
                detailsPath,
              ),
              child: const Text('View details'),
            ),
            TextButton(onPressed: () async {}, child: Text('get event')),
          ],
        ),
      ),
    );
  }
}
