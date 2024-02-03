import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happy_bus_driver/Screens/school_id_input_page.dart';
import 'package:happy_bus_driver/color/constant_colors.dart';
import 'package:intl/intl.dart';

import 'Homepage.dart';
import 'loginpage.dart';


class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isvisible = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _schoolNamecontroller = TextEditingController();

  final _PhoneNumberController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _PhoneNumberController.dispose();
    _schoolNamecontroller.dispose();
  }

 

 

 

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xFFCDE5EF),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 55,
                  ),
                  Container(
                    width: 160,
                    height: 168,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('Assets/Images/happy buss.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 28),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      cursorColor: Color(0xFF4CA6E0),
                      cursorHeight: 22,
                      validator: (value) {
                        if (value!.length < 4) {
                          return 'The Name should be at least 4 characters long';
                        } else {
                          return null;
                        }
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.mainColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.mainColor)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: ColorConstants.mainColor,
                        ),
                        hintText: 'Name',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 28),
                    child: TextFormField(
                      cursorHeight: 23,
                      cursorColor: Color(0xFF4CA6E0),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.mainColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.mainColor)),
                        prefixIcon: Icon(
                          Icons.email,
                          color: ColorConstants.mainColor,
                        ),
                        hintText: 'Email address',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 28),
                    child: TextFormField(
                      cursorColor: Color.fromRGBO(76, 166, 224, 1),
                      cursorHeight: 24,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'The password should be at least 7 characters long';
                        }
                        return null;
                      },
                      obscureText: (_isvisible) ? true : false,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.mainColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.mainColor)),
                        suffix: (_isvisible)
                            ? GestureDetector(
                                onTap: () => setState(() {
                                      _isvisible = false;
                                    }),
                                child: Icon(Icons.visibility_off))
                            : GestureDetector(
                                onTap: () => setState(() {
                                      _isvisible = true;
                                    }),
                                child: Icon(Icons.visibility)),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: ColorConstants.mainColor,
                        ),
                        hintText: 'Password ',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 28),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      enableSuggestions: false,
                      maxLength: 10,
                      cursorColor: Color(0xFF4CA6E0),
                      cursorHeight: 24,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 10) {
                          return 'Number should be 10 digits long';
                        }
                        return null;
                      },
                      controller: _PhoneNumberController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.mainColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.mainColor)),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: ColorConstants.mainColor,
                        ),
                        hintText: 'Phone number',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _signUpWithEmailAndPassword();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 30,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Color(0xFF4CA6E0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // padding: EdgeInsets.only(left: 25, right: 25),
                          child: (_isLoading)
                              ? SpinKitChasingDots(
                                  color: Colors.white,
                                )
                              : Center(
                                  child: Text('Create account',
                                      style: GoogleFonts.poppins(
                                          fontSize: 17, color: Colors.white)),
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'I have an account',
                        style: GoogleFonts.abel(
                            color: Colors.black45, fontSize: 16),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text('|'),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                          return LoginScreen();
                        })),
                        child: Text(
                          'Login',
                          style: GoogleFonts.abel(
                            color: Color(0xFF4CA6E0),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .catchError((msg) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${msg}'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      });
      _firestore.collection('DriversData').doc(_auth.currentUser!.uid).set({
        'School ID':'',
        'Name': _nameController.text.trim(),
        'Email': _emailController.text.trim(),
        'Phone': _PhoneNumberController.text.trim(),
        'ID': _auth.currentUser!.uid,
        'Registered on': DateFormat.yMMMMEEEEd().format(DateTime.now()),
        'Role': 'Driver',
        'School':'',
        'Approval': 'False',
        'Image': 'waiting...',
        'Active': 'False',
        
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return SchoolIDInputPage();    
      }));
    
      // User signed up
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}