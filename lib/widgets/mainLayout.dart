import 'package:depanini/provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:depanini/views/chat/chat_view.dart';
import 'package:depanini/views/home/home_view.dart';
import 'package:depanini/views/profile/profile_view.dart';
import 'package:depanini/views/search/search_view.dart';
class MainLayout extends ConsumerStatefulWidget {
  final Widget? nestedView;
  const MainLayout({Key? key, this.nestedView}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    ref.read(bottomNavIndexProvider.notifier).add(index);

    if (widget.nestedView != null) {
      ref.read(bottomNavIndexProvider.notifier).add(index);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainLayout(),
        ),
        (route) => false, // Remove all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavIndex = ref.watch(bottomNavIndexProvider);
    print("the type is ${ref.watch(userTypeProvider)}");
    final isClient = ref.watch(userTypeProvider) == 'CLIENT';
    print(isClient);
    List<Widget> navItems = [
      if (isClient) Icon(Icons.home_outlined, size: 30, color: Colors.white),
      if (isClient) Icon(Icons.search_outlined, size: 30, color: Colors.white),
      Icon(Icons.messenger_outline, size: 30, color: Colors.white),
      Icon(Icons.perm_identity_sharp, size: 30, color: Colors.white),
    ];
    final List<Widget> screens = [
   if (isClient) HomeView(),
   if (isClient) SearchView(),
  ChatView(),
  ProfileView()
];
    return Scaffold(
      body: widget.nestedView ??
          IndexedStack(
            index: bottomNavIndex,
            children: screens,
          ),
      bottomNavigationBar: CurvedNavigationBar(
        index: bottomNavIndex,
        height: 60.0,
        items: navItems,
        color: Color(0xFFebab01),
        buttonBackgroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: _onItemTapped,
        letIndexChange: (index) => true,
      ),
    );
  }
}
