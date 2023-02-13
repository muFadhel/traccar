import 'dart:async';
import 'dart:convert';
import 'package:android_id/android_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// to show Google Maps
import 'package:google_maps_flutter/google_maps_flutter.dart';

// to Get current location
import 'package:geolocator/geolocator.dart';

// to Get location address by lat & long
import 'package:geocoding/geocoding.dart';
import 'package:mfadhel/src/constants/custom_colors.dart';
import 'package:mfadhel/src/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../constants/perferences.dart';
import '../../models/send_position_model.dart';
import '../../providers/send_position_provider.dart';

late SendPositionProvider provider;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// user data
  Map userData = {};

  /// controller for GoogleMaps widget
  final Completer<GoogleMapController> _controller = Completer();

  /// init markers
  final Set<Marker> _markers = {};

  /// default lat & long
  double latData = 24.774265;
  double longData = 46.738586;

  /// location address
  String city = 'Riyadh';
  String neighborhood = 'Alaziyziyah - Exit 20';

  /// init position on map page opened
  final CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(24.774265, 46.738586), zoom: 15);

  /// device Id
  late String deviceId;

  @override
  void initState() {
    super.initState();

    /// get device id
    _getDeviceId().then((androidDeviceId) => {
      setState(() {
        deviceId = androidDeviceId!;
      })
    });

    /// get current location
    getCurrentLocationOnMapOpen();

    /// get user data
    var prefUserData = Prefs.getUserData();
    prefUserData.then((value) => {
      setState(() {
        userData = jsonDecode(value);
      })
    });
  }

  /// on map created assign controller
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  /// check permissions if enabled return lat and long

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  /// get location when map opened
  getCurrentLocationOnMapOpen() async {
    _determinePosition().then((position) => {
          setLocation(position),
        });
  }

  /// set location by position
  setLocation(position) async {
    changeCameraAfterLocationChange(position);
    updateMarkerPlace(position);
    updateAddressName(position);
  }

  /// change camera place after select location
  void changeCameraAfterLocationChange(position) async {
    var newPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 16);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  Future<String?> _getDeviceId() async {
    const androidIdPlugin = AndroidId();

    return await androidIdPlugin.getId();
  }

  setLocationInTracCar(latu, long)async{
    print(latu.toString());
    print(long.toString());
    /// send positions
    SendPositionModel sendPositionModel = SendPositionModel(
      deviceId: deviceId,
      lat: latu.toString(),
      lon: long.toString(),
      token: userData['token']
    );
    provider = Provider.of<SendPositionProvider>(context, listen: false);
    await provider.postData(sendPositionModel);
  }


  /// update marker place after select location
  void updateMarkerPlace(position) async{
    /// set location in TracCar
    setLocationInTracCar(position.latitude, position.longitude);
    String imgurl = "https://www.fluttercampus.com/img/car.png";
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl))
        .load(imgurl))
        .buffer
        .asUint8List();
    setState(() {
      latData = position.latitude;
      longData = position.longitude;
      _markers.add(Marker(
        markerId: const MarkerId('id-1'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.fromBytes(bytes), //Icon for Marker
      ));
    });
  }

  /// update address name by lat & long
  void updateAddressName(position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: "en_SA",);
    setState(() {
      city = placemarks[0].locality!;
      neighborhood = '${placemarks[0].subLocality!} - ${placemarks[0].name}';
    });
  }

  /// save location data to database
  saveLocationToDB() {
    // firestore.doc('clients/${userId}').set({
    //   'client_city': city,
    //   'client_neighborhood': neighborhood,
    //   'client_lat': latData,
    //   'client_long': longData,
    // }, SetOptions(merge: true)).then((value) => {
    //   Navigator.pop(context),
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: Colors.white,
        //     // <-- SEE HERE
        //     statusBarIconBrightness: Brightness.dark,
        //     //<-- For Android SEE HERE (dark icons)
        //     statusBarBrightness:
        //         Brightness.light, //<-- For iOS SEE HERE (dark icons)
        //   ),
        //   title: const Text('Google Maps', style:  TextStyle(
        //       fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),),
        // ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [

                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(35),
                        topLeft: Radius.circular(35),
                      ),
                      child: GoogleMap(
                        onLongPress: (current) {
                          setLocation(current);
                        },
                        initialCameraPosition: _initialPosition,
                        markers: _markers,
                        onMapCreated: _onMapCreated,

                        /// to hide fab button in iOS
                        myLocationButtonEnabled: false,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: 0.9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 18),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          height: 95,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: ()=>{
                                  CustomNavigation.pushTo('/profile')
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(1),
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            color: Colors.blueAccent, width: 2)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        "assets/images/logo.png",
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                              const SizedBox(width: 12,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(city, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, height: 1.55),),
                                  Text(neighborhood, style: TextStyle(color: Colors.grey[400], fontSize: 12,height: 1.55),)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 55.0,
          width: 55.0,
          padding: const EdgeInsets.only(bottom: 10),
          child: FittedBox(
            child: FloatingActionButton(
              elevation: 0,

              onPressed: () {
                _determinePosition().then((position) => {
                      setLocation(position),
                    });
              },
              backgroundColor: CustomColors.mainColor,
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ),);
  }
}
