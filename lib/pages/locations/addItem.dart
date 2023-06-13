import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_geocoder/geocoder.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../../redux/App.state.dart';
import '../../redux/locations/locations.action.dart';

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
  Location locationSearch = Location(lat: 0, lng: 0);
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerQuantity = TextEditingController();
  TextEditingController _controllerLocation = TextEditingController();
  String sortAddress = "";
  GlobalKey<FormState> key = GlobalKey();

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
                borderSide: const BorderSide(color: Colors.white))),
        components: []);
    if (p != null) {
      displayPrediction(p, homeScaffoldKey.currentState);
    }
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
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));
    print(LatLng(lat, lng));
    _controllerLocation.text = detail.result.formattedAddress!;
    locationSearch = detail.result.geometry!.location;
    setState(() {});
//POSIBLE INCORPORACION
    // googleMapController
    //     .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Corral'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _titleField(),
                _locationField(),
                GestureDetector(
                  onTap: () async {
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
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    // print('${file?.path}');

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
                      setState(() {});
                    } catch (error) {
                      log(error.toString());
                      //Some error occurred
                    }
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Pulsa para subir multimedia",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Icon(Icons.camera_alt),
                        ],
                      ),
                    ),
                  ),
                ),
                (imageUrl.isEmpty)
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(imageUrl),
                          ),
                        )),
                ElevatedButton(
                    onPressed: () async {
                      if (imageUrl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please upload an image')));

                        return;
                      }

                      if (key.currentState!.validate()) {
                        _controllerName.text;
                        _controllerLocation.text;
                        locationSearch;
                        Redux.store.dispatch(uploadSendAction(Redux.store, {
                          "name": _controllerName.text,
                          "imagenUrl": imageUrl,
                          "locationName": _controllerLocation.text,
                          "lng": locationSearch.lng,
                          "lat": locationSearch.lat,
                          "insertDate": DateTime.now(),
                          "sortAddress": sortAddress
                        }));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Subir a corral'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card _titleField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: _controllerName,
          decoration: const InputDecoration(hintText: 'Título del contenido'),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the item name';
            }

            return null;
          },
        ),
      ),
    );
  }

  Card _locationField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                onTap: _handlePressButton,
                controller: _controllerLocation,
                decoration: const InputDecoration(
                    hintText: "Introduce donde has dejado a Corral"),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.search), onPressed: _handlePressButton),
            IconButton(
                icon: const Icon(Icons.location_on),
                onPressed: () async {
                  Position position = await _determinePosition();
                  final coordinates =
                      Coordinates(position.latitude, position.longitude);
                  var addresses = await Geocoder.local
                      .findAddressesFromCoordinates(coordinates);
                  var first = addresses.first;
                  sortAddress = addresses.first.thoroughfare!;
                  locationSearch =
                      Location(lat: position.latitude, lng: position.longitude);
                  _controllerLocation.text = first.addressLine.toString();

                  setState(() {});
                })
          ],
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
