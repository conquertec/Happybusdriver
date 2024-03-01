import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happy_bus_driver/color/constant_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import '../loginpage.dart';
import 'update.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _uploading = false;

  // Delete picture

  Future<void> deleteImage() async {
    setState(() {
      _uploading = true;
    });
    await FirebaseStorage.instance
        .ref()
        .child('Drivers_images/${_auth.currentUser!.uid}')
        .delete();

    await FirebaseFirestore.instance
        .collection('DriversLocation')
        .doc(_auth.currentUser!.uid)
        .update({
      'Image': 'waiting...',
    });
    setState(() {
      _uploading = false;
    });
  }

  // Upload picture to firestore

  Future<void> uploadImage() async {
    setState(() {
      _uploading = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Get a reference to the Firebase storage bucket
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('Drivers_images/${_auth.currentUser!.uid}');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(File(pickedFile.path));

      // Get the download URL once the upload is complete
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Save the download URL to Firestore
      await FirebaseFirestore.instance
          .collection('DriversLocation')
          .doc(_auth.currentUser!.uid)
          .update({
        'Image': downloadURL,
      });
      setState(() {
        _uploading = false;
      });
    } else {
      // Handle error or cancelation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          SafeArea(
            child: IconButton(
                onPressed: () {
                  imageboxdialog();
                },
                icon: Icon(
                  Icons.add_a_photo_rounded,
                  color: ColorConstants.mainColor,
                  size: 30,
                )),
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 236, 235, 235),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  StreamBuilder(
                      stream: _firestore
                          .collection('DriversLocation')
                          .doc(_auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Loading...');
                        }
                        var doc = snapshot.data!.get('Image');

                        if (doc == 'waiting...') {
                          return CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(
                              'Assets/Images/happy buss.png',
                            ),
                          );
                        } else {
                          return _uploading
                              ? CircleAvatar(
                                  radius: 60,
                                  child: SpinKitChasingDots(
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(doc),
                                  radius: 60,
                                );
                        }
                      }),
                  SizedBox(
                    height: 22,
                  ),
                  StreamBuilder(
                      stream: _firestore
                          .collection('DriversLocation')
                          .doc(_auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Loading...');
                        } else {
                          return Text(
                            snapshot.data!.get('Name'),
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                      }),
                  SizedBox(
                    height: 12,
                  ),
                  StreamBuilder(
                      stream: _firestore
                          .collection('DriversLocation')
                          .doc(_auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Loading...');
                        } else {
                          return Text(
                            snapshot.data!.get('Phone'),
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                      }),
                  SizedBox(
                    height: 12,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return UpdatePage();
                        }));
                      },
                      child: Text(
                        'Edit',
                        style: GoogleFonts.poppins(
                          color: ColorConstants.mainColor,
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              child: TextButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }));
                  },
                  icon: Icon(
                    Icons.logout,
                    size: 19,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 19,
                    ),
                  )),
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void imageboxdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StreamBuilder(
              stream: _firestore
                  .collection('DriversLocation')
                  .doc(_auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text(''));
                }
                var doc = snapshot.data!.get('Image');

                if (doc == 'waiting...') {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          )),
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _uploading = true;
                              });
                              uploadImage();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Upload image',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              width: 254,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ColorConstants.mainColor),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          )),
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              uploadImage();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Update profile',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              width: 254,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ColorConstants.mainColor),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              deleteImage();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Default profile',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              width: 254,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ColorConstants.mainColor),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  );
                }
              });
        });
  }
}
