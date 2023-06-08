import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_compression/image_compression.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_geocoder/model.dart';
import 'package:flutter_geocoder/services/base.dart';
import 'package:flutter_geocoder/services/distant_google.dart';
import 'package:flutter_geocoder/services/local.dart';
import 'package:searchfield/searchfield.dart';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

const kGoogleApiKey = 'AIzaSyCD9co-B7xbWxSHU5KulvIM-Z2kMjd8_SA';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  Set<Marker> markersList = {};

  late GoogleMapController googleMapController;

  final Mode _mode = Mode.overlay;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerQuantity = TextEditingController();
  TextEditingController _controllerLocation = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('shopping_list');

  String imageUrl = '';

  List<Address> results = [];

  bool isLoading = false;

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [
          // Component(Component.country, "pk"),
          // Component(Component.country, "usa"),
          // Component(Component.country, "es")
        ]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: Text(
        response.errorMessage!,
      ),
    ));

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    print(detail);
    print(detail.result.name);
    print(detail.result.formattedAddress);
    print(detail.result.geometry!.location.lat);
    print(detail.result.geometry!.location.lng);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));
    print(LatLng(lat, lng));
    setState(() {});
//POSIBLE INCORPORACION
    // googleMapController
    //     .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration:
                    InputDecoration(hintText: 'Enter the name of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }

                  return null;
                },
              ),
              TextFormField(
                onTap: _handlePressButton,
                controller: _controllerQuantity,
                decoration:
                    InputDecoration(hintText: 'Enter the quantity of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item quantity';
                  }

                  return null;
                },
              ),

              new Card(
                child: new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new TextField(
                          onTap: _handlePressButton,
                          controller: _controllerLocation,
                          decoration:
                              new InputDecoration(hintText: "Enter an address"),
                        ),
                      ),
                      new IconButton(
                          icon: new Icon(Icons.search),
                          onPressed: _handlePressButton),
                      new IconButton(
                          icon: new Icon(Icons.location_on),
                          onPressed: _handlePressButton)
                    ],
                  ),
                ),
              ),
              SearchField<Address>(
                suggestions: this
                    .results
                    .map(
                      (e) => SearchFieldListItem<Address>(
                        e.addressLine.toString(),
                        item: e,
                        // Use child to show Custom Widgets in the suggestions
                        // defaults to Text widget
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(e.coordinates.toString()),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              // TextFormField(
              //   controller: _controllerLocation,
              //   decoration: InputDecoration(hintText: 'LOCATION'),
              //   validator: (String? value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter the item quantity';
              //     }

              //     return null;
              //   },
              // ),
              IconButton(
                  onPressed: () async {
                    /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

                    /*Step 1:Pick image*/
                    //Install image_picker
                    //Import the corresponding library

                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    print('${file?.path}');

                    if (file == null) return;
                    //Import dart:core
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    /*Step 2: Upload to Firebase storage*/
                    //Install firebase_storage
                    //Import the library

                    //Get a reference to storage root
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');

                    //Create a reference for the image to be stored
                    Reference referenceImageToUpload =
                        referenceDirImages.child(file.name);

                    //Handle errors/success
                    try {
                      File fileCompress = await compressFile(file);

                      await referenceImageToUpload.putFile(fileCompress);
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      print(error);
                      //Some error occurred
                    }
                  },
                  icon: Icon(Icons.camera_alt)),
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please upload an image')));

                      return;
                    }

                    if (key.currentState!.validate()) {
                      String itemName = _controllerName.text;
                      String itemQuantity = _controllerQuantity.text;

                      //Create a Map of data
                      Map<String, String> dataToSend = {
                        'name': itemName,
                        'quantity': itemQuantity,
                        'image': imageUrl,
                      };

                      //Add a new item
                      _reference.add(dataToSend);
                    }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }

  //Comprimir video
  // https://pub.dev/packages/video_compress/install
  // Buscar direccion
// https://stackoverflow.com/questions/62399236/obtain-coordinates-from-an-address-flutter
  Future<File> compressFile(XFile file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 55,
    );
    return compressedFile;
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }
}
