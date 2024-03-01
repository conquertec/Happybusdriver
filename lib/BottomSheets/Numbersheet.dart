import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happy_bus_driver/color/constant_colors.dart';

class UpdateNumber extends StatefulWidget {
  const UpdateNumber({super.key});

  @override
  State<UpdateNumber> createState() => _UpdateNumberState();
}

class _UpdateNumberState extends State<UpdateNumber> {
  TextEditingController phoneController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  var _userName = '';
  bool _isLoading = false;

  void UpdateNumber() {
    if (phoneController.text.length != 10) {
      Fluttertoast.showToast(
          msg: 'Phone number should be 10 digits long');
    } else {
      _firestore.collection('DriversData').doc(_auth.currentUser!.uid).update({
        'Phone': phoneController.text.trim(),
      });
      _firestore.collection('DriversLocation').doc(_auth.currentUser!.uid).update({
        'Phone':phoneController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedSize(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFe6e8e6),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          height: 250,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 45, left: 17, right: 17),
                  child: TextFormField(
                    
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    maxLength: 10,
                    textCapitalization: TextCapitalization.characters,
                    cursorColor: ColorConstants.mainColor,
                    cursorHeight: 22,
                    key: ValueKey('name'),
                    onSaved: (value) {
                      _userName = value!;
                    },
                    validator: (value) {
                      if (value!.length != 10) {
                        return 'Phone number should be 10 digits long';
                      } else {
                        return null;
                      }
                    },
                    controller: phoneController,
                    decoration: InputDecoration(
                    
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.black45,
                      ),
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 270,
                      height: 52,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              ColorConstants.mainColor),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          UpdateNumber();
                          Navigator.pop(context);
                        },
                        child: (_isLoading)
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('Update',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}