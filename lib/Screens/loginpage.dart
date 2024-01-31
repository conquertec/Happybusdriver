import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happy_bus_driver/Screens/signup_page.dart';
import 'package:happy_bus_driver/color/constant_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Homepage.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _userPassword = '';
  var _userEmail = '';

  bool _isvisible = true;

  bool _rememberMe = false;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  var _isLoading = false;

  _loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        emailController.text = prefs.getString('username') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  // Save the "Remember Me" status and user credentials
  _saveRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      prefs.setString('username', emailController.text);
      prefs.setString('password', passwordController.text);
    } else {
      prefs.remove('username');
      prefs.remove('password');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xFFCDE5EF),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 58,
              ),
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
                        height: 65,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25, left: 28),
                        child: TextFormField(
                          cursorHeight: 23,
                          cursorColor: ColorConstants.mainColor,
                          key: ValueKey('email'),
                          onSaved: (value) {
                            _userEmail = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants.mainColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants.mainColor)),
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
                          key: ValueKey('password'),
                          onSaved: (value) {
                            _userPassword = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'The password should be at least 7 characters long';
                            }
                            return null;
                          },
                          cursorColor: ColorConstants.mainColor,
                          cursorHeight: 24,
                          obscureText: (_isvisible) ? true : false,
                          controller: passwordController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants.mainColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants.mainColor)),
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
                        padding: const EdgeInsets.only(left: 32),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              activeColor: ColorConstants.mainColor,
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            Text(
                              'Remember me',
                              style: GoogleFonts.abel(
                                color: Colors.black45,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _saveRememberMeStatus();
                              _signInWithEmailAndPassword();
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
                                      child: Text('Login',
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              color: Colors.white)),
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
                            'I do not have an account',
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
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SignupScreen();
                            })),
                            child: Text(
                              'Create',
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
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
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

      setState(() {
        _isLoading = false;
      });

      DocumentSnapshot userSnapshot = await _firestore
          .collection('Drivers')
          .doc(_auth.currentUser!.uid)
          .get();

      if (userSnapshot.exists && userSnapshot.get('Role') == 'Driver') {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return Homepage();
        }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login invalid. You are not a driver'),
          ),
        );
      }

      // User signed up
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An account already exists for that email.'),
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