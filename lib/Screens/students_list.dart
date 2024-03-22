import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:happy_bus_driver/color/constant_colors.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({super.key});

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: 32),
        child: StreamBuilder(
            stream: _firestore
                .collection('Students')
                .where('driver_id', isEqualTo: _auth.currentUser!.uid)
                .where('Approval', isEqualTo: 'True')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SpinKitChasingDots(color: ColorConstants.mainColor),
                );
              } else {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    var students = snapshot.data!.docs[index];

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(students['image']),
                      ),
                      title: Text(students['student_name']),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black45,
                    endIndent: 30,
                    indent: 23,
                    thickness: 0,
                  ),
                  itemCount: snapshot.data!.docs.length,
                );
              }
            }),
      ),
    );
  }
}
