import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/botton_navigation_bar_custom.dart';
import '../../redux/App.state.dart';
import '../../redux/locations/locations.action.dart';
import '../../redux/locations/locations.state.dart';

import 'dart:async';
import 'dart:ui' as ui;

Future<Uint8List> getImages(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetHeight: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

class LocationsPage extends StatefulWidget {
  const LocationsPage({Key? key}) : super(key: key);
  static const String routeName = 'LocationsPage';

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  GoogleMapController? mapController;
  Uint8List markIcons = Uint8List.fromList([]);
  LatLng blackPosition = const LatLng(39.15022284301703, -3.017762654345716);
  bool isLoad = false;
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    markIcons = await getImages("assets/images/face.png", 100);
    isLoad = true;
    setState(() {});
  }

  //markers for google map
  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(locationsListAction);
    return StoreConnector<AppState, LocationsState>(
        distinct: false,
        converter: (store) => store.state.locationsState,
        builder: (context, storeData) {
          for (var element in storeData.locations) {
            {
              markers.add(Marker(
                markerId: MarkerId(LatLng(element.lat, element.lng).toString()),
                position: LatLng(element.lat, element.lng), //position of marker
                infoWindow: InfoWindow(
                  title: element.nombre,
                  snippet: element.locationName,
                ),
                icon: (!isLoad)
                    ? BitmapDescriptor.defaultMarker
                    : BitmapDescriptor.fromBytes(markIcons), //Icon for Marker
              ));
            }
          }
          return Scaffold(
            appBar: AppBar(
              leading: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Image(
                  image: AssetImage("assets/images/face.png"),
                ),
              ),
              title: const Text("Donde esta corral"),
            ),
            body: GoogleMap(
              //Map widget from google_maps_flutter package
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: CameraPosition(
                //innital position in map
                target: blackPosition, //initial position
                zoom: 7.0, //initial zoom level
              ),
              markers: markers, //markers to show on map
              mapType: MapType.satellite, //map type
            ),
            bottomNavigationBar: const BottonNavigationBarCustom(),
          );
        });
  }
}
