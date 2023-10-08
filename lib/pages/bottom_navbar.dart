import 'package:flutter/material.dart';
import 'package:flutter_playground/pages/routing.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go('/protected/events');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.back_hand),
          onPressed: () => context.goNamed(AppRoute.home.name),
        )),
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _goBranch,
          items: const [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Icon(Icons.home),
                ),
                label: 'b'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Icon(Icons.search),
                ),
                label: 'c'),
          ],
          //styling
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 8,
          unselectedFontSize: 14,
          selectedFontSize: 14,
          unselectedItemColor: const Color.fromARGB(0, 0, 0, 0),
          selectedItemColor: const Color.fromARGB(0, 0, 0, 0),
          unselectedLabelStyle: const TextStyle(
            shadows: [
              Shadow(color: Colors.black, offset: Offset(0, -5)),
            ],
          ),
          selectedLabelStyle: const TextStyle(
            shadows: [
              Shadow(color: Colors.black, offset: Offset(0, -5)),
            ],
            decoration: TextDecoration.underline,
            decorationThickness: 5,
            decorationStyle: TextDecorationStyle.dashed,
          ),
        ),
      ),
    );
  }
}
