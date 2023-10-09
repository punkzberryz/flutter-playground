import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_playground/features/auth/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpWithEmail extends HookConsumerWidget {
  const SignUpWithEmail({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final otpController = useTextEditingController();
    final authRepo = ref.watch(authRepositoryProvider);
    final authState = ref.watch(authStateProvider);

    return ListView(
      children: [
        Row(children: [
          IconButton(onPressed: context.pop, icon: const Icon(Icons.arrow_back))
        ]),
        Text(authState.value?.accessToken.jwtToken ?? ''),
        Text(authState.value?.refreshToken?.token ?? ''),
        TextButton(
            onPressed: () {
              authRepo.authenticate();
            },
            child: Text('print input')),
        Container(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: FilledButton(
            onPressed: () {
              authRepo.signUpWithEmail(
                  email: emailController.text,
                  password: passwordController.text);
            },
            style: const ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
            child: const Text('Sign up'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: otpController,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: 'Verification Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: FilledButton(
            onPressed: () {
              authRepo.confirmRegistration(
                  email: emailController.text, otp: otpController.text);
            },
            style: const ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
            child: const Text('Confirm Registration'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: FilledButton(
            onPressed: () {
              authRepo.signIn(
                  email: emailController.text,
                  password: passwordController.text);
            },
            style: const ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
            child: const Text('Sign In'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: FilledButton(
            onPressed: () {},
            style: const ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
            child: const Text('Get Session'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: FilledButton(
            onPressed: () {
              authRepo.signOut();
            },
            style: const ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
            child: const Text('SignOut'),
          ),
        ),
      ],
    );
  }
}
