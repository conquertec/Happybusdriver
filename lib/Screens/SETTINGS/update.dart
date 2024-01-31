import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happy_bus_driver/BottomSheets/name_sheet.dart';
import 'package:happy_bus_driver/color/constant_colors.dart';

import '../../BottomSheets/Numbersheet.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var _userName = '';

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _UpdateUserName() {
    _firestore.collection('Drivers').doc(_auth.currentUser!.uid).update({
      'Name': nameController.text.trim(),
    });
  }

  void _UpdateUserPhone() {
    _firestore.collection('Drivers').doc(_auth.currentUser!.uid).update({
      'Phone': phoneController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              ListTile(
                trailing: TextButton(
                    onPressed: () {
                      updateDriverName();
                    },
                    child: Text(
                      'Edit',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                      ),
                    )),
                leading: Icon(
                  Icons.person,
                  color: Colors.black45,
                ),
                title: StreamBuilder(
                    stream: _firestore
                        .collection('Drivers')
                        .doc(_auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Loading...');
                      } else {
                        var doc = snapshot.data!.get('Name');
                        return Text(
                          doc,
                          style: GoogleFonts.poppins(),
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    }),
              ),
              Divider(
                color: Colors.black45,
                endIndent: 30,
                indent: 23,
                thickness: 0,
              ),
              SizedBox(
                height: 12,
              ),
              ListTile(
                trailing: TextButton(
                    onPressed: () {
                      UpateDriverphone();
                    },
                    child: Text(
                      'Edit',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                      ),
                    )),
                leading: Icon(
                  Icons.phone,
                  color: Colors.black45,
                ),
                title: StreamBuilder(
                    stream: _firestore
                        .collection('Drivers')
                        .doc(_auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Loading...');
                      } else {
                        var doc = snapshot.data!.get('Phone');
                        return Text(
                          doc,
                          style: GoogleFonts.poppins(),
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }

  void updateDriverName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 354,
            height: 230,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                    ),
                    child: TextFormField(
                      // keyboardType: TextInputType.number,
                      // inputFormatters: <TextInputFormatter>[
                      //     FilteringTextInputFormatter.digitsOnly
                      //   ],
                      // maxLength: 10,
                      textCapitalization: TextCapitalization.characters,
                      cursorColor: ColorConstants.mainColor,
                      cursorHeight: 22,
                      key: ValueKey('name'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                      validator: (value) {
                        if (value!.length < 4) {
                          return 'The school name should be at least 4 characters long';
                        } else {
                          return null;
                        }
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      if (nameController.text.length < 4) {
                        Fluttertoast.showToast(
                            msg: 'The name should be 4 letters long at least');
                      } else {
                        _UpdateUserName();
                        Navigator.of(context).pop();
                        nameController.clear();
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          'Update',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void UpateDriverphone() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 354,
            height: 230,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      maxLength: 10,
                      textCapitalization: TextCapitalization.characters,
                      cursorColor: ColorConstants.mainColor,
                      controller: phoneController,
                      decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      if (phoneController.text.length < 10) {
                        Fluttertoast.showToast(
                            msg: 'The phone number should be 10 digits long');
                      } else {
                         _UpdateUserPhone();
                        Navigator.of(context).pop();
                       
                        phoneController.clear();
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          'Update',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
