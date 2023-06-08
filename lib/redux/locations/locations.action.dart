import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whereiscorral/redux/locations/locations.state.dart';

import '../App.state.dart';
import 'package:redux/redux.dart';

import 'locations.model.dart';

class LocationsAction {
  final LocationsState locationsState;

  LocationsAction(this.locationsState);

  @override
  String toString() {
    return 'LocationAction { }';
  }
}

Future<void> locationsListAction(Store<AppState> store) async {
  store.dispatch(LocationsAction(LocationsState(
      false,
      "",
      store.state.locationsState.locations,
      store.state.locationsState.location)));
  String? uuid = store.state.authState.user?.uid;

  try {
    Stream<QuerySnapshot> collectionStream =
        FirebaseFirestore.instance.collection("locations").snapshots();
    List<LocationModel> locations = [];
    print("ENTRO");
    collectionStream.listen((event) {
      event.docChanges.asMap().forEach((index, change) {
        switch (change.type) {
          case DocumentChangeType.added:
            var data = change.doc.data() as Map<String, dynamic>;
            locations.add(LocationModel.fromJson(data));
            store.dispatch(LocationsAction(LocationsState(
                false, '', locations, store.state.locationsState.location)));
            break;
          case DocumentChangeType.modified:
            locations.asMap().forEach((index, element) {
              var d = change.doc.data() as Map<String, dynamic>;

              // if (element.idRuta == d["idRuta"]) {
              //   locations[index] = LocationModel.fromJson(d);

              //   store.dispatch(LocationsAction(LocationsState(false, '',
              //       locations, store.state.locationsState.location)));
              // }
            });

            break;
          // case DocumentChangeType.removed:
          //   bool delete = false;
          //   int index = 0;
          //   var d = change.doc.data() as Map<String, dynamic>;
          //   rutes.asMap().forEach((i, element) {
          //     if (element.idRuta == d["idRuta"]) {
          //       delete = true;
          //       index = i;
          //     }
          //   });
          //   if (delete) {
          //     rutes.removeAt(index);
          //     store.dispatch(RutesAction(RutesState(
          //       false,
          //       '',
          //       rutes,
          //       store.state.rutesState.rute,
          //     )));
          //   }
          //   break;
        }
      });
      // }
    });
  } catch (error) {
    store.dispatch(LocationsAction(LocationsState(
        true,
        error.toString(),
        store.state.locationsState.locations,
        store.state.locationsState.location)));
  }
}

Future<void> uploadSendAction(
  Store<AppState> store,
  id,
) async {
  CollectionReference collectionStream =
      FirebaseFirestore.instance.collection("locations");

  String estado = "enviado";
  try {
    collectionStream.doc().set({"nombre": "PROBANDO"});
  } catch (error) {}
}

class IncidenceSuccessAction {
  final int isSuccess;

  IncidenceSuccessAction({required this.isSuccess});
  @override
  String toString() {
    return 'IncidenceSuccessAction { isSuccess: $isSuccess }';
  }
}

class IncidenceFailedAction {
  final String error;

  IncidenceFailedAction({required this.error});

  @override
  String toString() {
    return 'IncidenceFailedAction { error: $error }';
  }
}
