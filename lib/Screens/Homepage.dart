import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:happy_bus_driver/Screens/map_page.dart';
import 'package:happy_bus_driver/Screens/school_id_input_page.dart';
import 'package:happy_bus_driver/color/constant_colors.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'SETTINGS/settings_page.dart';
import 'students_list.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> doesDocumentExist() async {
  var docSnapshot = await FirebaseFirestore.instance
      .collection('DriversLocation')
      .doc(_auth.currentUser!.uid)
      .get();
  return docSnapshot.exists;
}


 Future<void> checkDocumentExistence() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if (userId != null) {
      bool documentExists = await doesDocumentExist();
      if (!documentExists) {
        // Redirect to your blank page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SchoolIDInputPage()),
        );
      }
    }
  }

 
@override
void initState() {
  super.initState();
  checkDocumentExistence();
}


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: StreamBuilder(
          stream: _firestore
              .collection('DriversData')
              .doc(_auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SpinKitChasingDots(
                  color: ColorConstants.mainColor,
                ),
              );
            } else {
              var school_id = snapshot.data!.get('School ID');
              if (school_id == '') {
                return SchoolIDInputPage();
              } else {
                return PersistentTabView(
                  context,
                  controller: PersistentTabController(initialIndex: 0),
                  screens: [
                    MapPage(),
                    StudentsList(),
                    SettingsPage(),
                  ],
                  items: [
                    PersistentBottomNavBarItem(
                      icon: Icon(Icons.map),
                      title: 'Map',
                      activeColorPrimary: Colors.blue,
                      inactiveColorPrimary: Colors.grey,
                    ),
                    PersistentBottomNavBarItem(
                      icon: Icon(Icons.person),
                      title: 'Students',
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
                );
              }
            }
          }),
    );
  }
}
