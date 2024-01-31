import 'package:flutter/material.dart';
import 'package:happy_bus_driver/Screens/map_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'SETTINGS/settings_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: PersistentTabView(
        context,
        controller: PersistentTabController(initialIndex: 0),
        screens: [
          MapPage(),
          SettingsPage(),
        ],
        items: [
          PersistentBottomNavBarItem(
            icon: Icon(Icons.home),
            title: 'Map',
            activeColorPrimary: Colors.blue,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.settings),
            title: 'Settings',
            activeColorPrimary: Colors.blue,
            inactiveColorPrimary: Colors.grey,
          ),
          // PersistentBottomNavBarItem(
          //   icon: Icon(Icons.bookmark),
          //   title: 'Bookmarks',
          //   activeColorPrimary: Colors.blue,
          //   inactiveColorPrimary: Colors.grey,
          // ),
          // PersistentBottomNavBarItem(
          //   icon: Icon(Icons.settings),
          //   title: 'Settings',
          //   activeColorPrimary: Colors.blue,
          //   inactiveColorPrimary: Colors.grey,
          // ),
          // PersistentBottomNavBarItem(
          //   icon: Icon(Icons.person),
          //   title: 'Profile',
          //   activeColorPrimary: Colors.blue,
          //   inactiveColorPrimary: Colors.grey,
          // ),
        ],
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        navBarStyle: NavBarStyle.style9,
      ),
    );
  }
}
