import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_bus_driver/Screens/Homepage.dart';
import '../color/constant_colors.dart';

class SchoolIDInputPage extends StatefulWidget {
  const SchoolIDInputPage({super.key});

  @override
  State<SchoolIDInputPage> createState() => _SchoolIDInputPageState();
}

class _SchoolIDInputPageState extends State<SchoolIDInputPage> {
  var _userName = '';
  var _schoolID = '';
  bool _isLoading = false;

  String _userId = '';
  dynamic _userData;
  bool _userExists = false;

  TextEditingController IDController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? _errorText;

  Future<void> checkUserIdExists() async {
    setState(() {
      _isLoading = true;
    });
    String userId = IDController.text.trim();
    try {
      // Check if the user ID exists in Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _userId = user.uid;
          _userExists = true;
        });

        // Retrieve user document from Firestore
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Administrator')
            .doc(userId)
            .get();

        if (snapshot.exists) {
          // Do something with the user document
          setState(() {
            _userName = snapshot.get('School');
            _schoolID = snapshot.get('ID');
          });
          // print('User document found: ${snapshot.data()}');
          _firestore
              .collection('DriversData')
              .doc(_auth.currentUser!.uid)
              .update({
            'School ID': snapshot.get('ID'),
            'School': snapshot.get('School'),
          });
          setState(() {
            _isLoading = false;
          });
          // showDialog(
          //   context: context,
          //   barrierDismissible:
          //       false, // Prevent dismissing the dialog with a tap outside
          //   builder: (context) {
          //     return Center(
          //       child: SpinKitChasingDots(
          //         color: Colors.white,
          //       ),
          //     );
          //   },
          // );
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homepage()));
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'The school ID does not exist. Contact the school administrator.')));
        }
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error checking user ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 320),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 19,
                    right: 8,
                  ),
                  child: Text(
                    'Paste the school ID provided by the school administrator in the field below.',
                    style: GoogleFonts.poppins(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35, left: 17, right: 17),
                  child: TextFormField(
                    // keyboardType: TextInputType.number,
                    // inputFormatters: <TextInputFormatter>[
                    //     FilteringTextInputFormatter.digitsOnly
                    //   ],
                    // maxLength: 10,

                    cursorColor: ColorConstants.mainColor,
                    cursorHeight: 22,
                    key: ValueKey('name'),
                    onSaved: (value) {
                      _userName = value!;
                    },
                    validator: (value) {
                      if (value!.length < 1) {
                        return 'The field is empty';
                      } else {
                        return null;
                      }
                    },
                    controller: IDController,
                    decoration: InputDecoration(
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
                          if (IDController.text.length < 1) {
                            Fluttertoast.showToast(msg: 'The field is empty');
                          } else {
                            checkUserIdExists();
                          }
                        },
                        child: (_isLoading)
                            ? SpinKitChasingDots(
                                color: Colors.white,
                              )
                            : Text('Verification',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    // SizedBox(height: 20),
                    // _userExists
                    //     ? Text(_userName)
                    //     : Text('User ID does not exist'),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
