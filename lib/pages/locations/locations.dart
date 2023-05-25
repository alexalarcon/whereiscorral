import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/botton_navigation_bar_custom.dart';
import '../../redux/App.state.dart';
import '../../redux/locations/locations.action.dart';
import '../../redux/locations/locations.state.dart';

class LocationsPage extends StatelessWidget {
  LocationsPage({Key? key}) : super(key: key);
  static const String routeName = 'LocationsPage';
  GoogleMapController? mapController;
  LatLng blackPosition = const LatLng(39.15022284301703, -3.017762654345716);
  Set<Marker> markers = Set(); //markers for google map

// make sure to initialize before map loading

  //contrller for Google map
  @override
  Widget build(BuildContext context) {
    BitmapDescriptor customIcon;

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/images/car-icon.png')
        .then((d) {
      customIcon = d;
    });
    Redux.store.dispatch(locationsListAction);
    return StoreConnector<AppState, LocationsState>(
        distinct: false,
        converter: (store) => store.state.locationsState,
        builder: (context, storeData) {
          for (var element in storeData.locations) {
            {
              markers.add(Marker(
                //add marker on google map
                markerId: MarkerId(LatLng(
                        element.location!.latitude, element.location!.longitude)
                    .toString()),
                position: LatLng(element.location!.latitude,
                    element.location!.longitude), //position of marker
                infoWindow: InfoWindow(
                  //popup info
                  title: element.nombre,
                  snippet: 'My Custom Subtitle',
                ),
                icon: BitmapDescriptor.defaultMarker, //Icon for Marker
              ));
            }
          }
          return Scaffold(
            body: GoogleMap(
              //Map widget from google_maps_flutter package
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: CameraPosition(
                //innital position in map
                target: blackPosition, //initial position
                zoom: 15.0, //initial zoom level
              ),
              markers: markers, //markers to show on map
              mapType: MapType.satellite, //map type
            ),
            bottomNavigationBar: Visibility(
                visible: (storeData.locations.isNotEmpty),
                child: const BottonNavigationBarCustom()),
          );
        });
  }
}
