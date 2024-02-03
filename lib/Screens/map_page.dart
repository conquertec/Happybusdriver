import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:happy_bus_driver/color/constant_colors.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location location = Location();
  GoogleMapController? _controller;
  bool _added = false;
  StreamSubscription<LocationData>? _locationSubscription;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getLocation();
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  _getLocation() async {
    
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('DriversData').doc(_auth.currentUser!.uid).get();

      if(documentSnapshot.exists){
        var SchoolID = documentSnapshot['School ID'];
        var SchoolName = documentSnapshot['School'];

        final LocationData _locationResult = await location.getLocation();
         location.enableBackgroundMode(enable: true);
      await FirebaseFirestore.instance
          .collection('DriversLocation')
          .doc(_auth.currentUser!.uid)
          .set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'School ID': SchoolID,
        'School': SchoolName,
        'Approval': 'False',
      }, SetOptions(merge: true));
      }else{
         print('Document does not exist.');
      }
      
    } catch (e) {
      print(e);
    }
   
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('DriversLocation')
          .doc(_auth.currentUser!.uid)
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('DriversLocation').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (_added) {
            mymap(snapshot);
          }
          if (!snapshot.hasData) {
            return Center(
                child: SpinKitChasingDots(
              color: Colors.white,
            ));
          }
          return Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.normal,
                // markers: {
                //   Marker(
                //       position: LatLng(
                //         snapshot.data!.docs.singleWhere((element) =>
                //             element.id == _auth.currentUser!.uid)['latitude'],
                //         snapshot.data!.docs.singleWhere((element) =>
                //             element.id == _auth.currentUser!.uid)['longitude'],
                //       ),
                //       markerId: MarkerId('id'),
                //       icon: BitmapDescriptor.defaultMarkerWithHue(
                //           BitmapDescriptor.hueMagenta)),
                // },
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      snapshot.data!.docs.singleWhere((element) =>
                          element.id == _auth.currentUser!.uid)['latitude'],
                      snapshot.data!.docs.singleWhere((element) =>
                          element.id == _auth.currentUser!.uid)['longitude'],
                    ),
                    zoom: 18),
                onMapCreated: (GoogleMapController controller) async {
                  setState(() {
                    _controller = controller;
                    _added = true;
                  });
                },
              ),
              StreamBuilder(
                  stream: _firestore
                      .collection('DriversLocation')
                      .doc(_auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return Text('Loading...');
                      
                    }else{
                      var doc = snapshot.data!.get('Approval');

                      if(doc == 'False'){
                        return Positioned(
                      child: Container(
                        child: Center(
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 13),
                                  child: Text(
                                    'Awaiting approval from',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                StreamBuilder(
                                    stream: _firestore
                                        .collection('DriversLocation')
                                        .doc(_auth.currentUser!.uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text('Loading...');
                                      }
                                      return Text(
                                        snapshot.data!.get('School'),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: ColorConstants.mainColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    })
                              ],
                            ),
                            width: 350,
                            height: 130,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                )),
                          ),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(115, 0, 0, 0),
                        ),
                      ),
                    );
                      }else{
                        return Text('');
                      }
                    }

                    
                  })
            ],
          );
        },
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller!
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere((element) =>
                  element.id == _auth.currentUser!.uid)['latitude'],
              snapshot.data!.docs.singleWhere((element) =>
                  element.id == _auth.currentUser!.uid)['longitude'],
            ),
            zoom: 18)));
  }
}
