import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../common/botton_navigation_bar_custom.dart';
import '../../redux/App.state.dart';
import '../../redux/locations/locations.action.dart';
import '../../redux/locations/locations.state.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({Key? key}) : super(key: key);
  static const String routeName = 'LocationsPage';

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(locationsListAction);
    return StoreConnector<AppState, LocationsState>(
        distinct: false,
        converter: (store) => store.state.locationsState,
        builder: (context, storeData) {
          return Scaffold(
            body: Text(storeData.toString()),
            bottomNavigationBar: Visibility(
                visible: (storeData.locations.isNotEmpty),
                child: const BottonNavigationBarCustom()),
          );
        });
  }
}
