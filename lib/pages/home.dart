import 'package:flutter/material.dart';
import 'package:flutter_playground/pages/routing.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => context.pushNamed(AppRoute.myHome.name),
          child: Text('MyHome'),
        ),
        TextButton(
          onPressed: () => context.pushNamed(AppRoute.signupWithEmail.name),
          child: Text('signUpWithEmail'),
        ),
        TextButton(
          onPressed: () => context.pushNamed(AppRoute.b.name),
          child: Text('b'),
        ),
      ],
    );
  }
}
