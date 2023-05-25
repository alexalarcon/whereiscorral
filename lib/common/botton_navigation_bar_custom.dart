import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:whereiscorral/pages/locations/locations.dart';

import '../redux/App.state.dart';
import '../redux/barNavigation/barNavigation.action.dart';
import '../redux/barNavigation/barNavigation.state.dart';

class BottonNavigationBarCustom extends StatelessWidget {
  const BottonNavigationBarCustom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BarNavigationState>(
        distinct: false,
        converter: (store) => store.state.barNavigationState,
        builder: (context, storeData) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                    color: Theme.of(context).colorScheme.secondary, width: 0.2),
              ),
            ),
            child: BottomNavigationBar(
              elevation: 0,
              iconSize: 22,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.list,
                  ),
                  label: 'Rutas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                  ),
                  label: 'Buscar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.stay_current_landscape,
                  ),
                  label: 'Estadísticas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.send,
                  ),
                  label: 'Enviar',
                ),
              ],
              currentIndex: storeData.barNavigation.currentIndex ?? 0,
              selectedItemColor: Theme.of(context).colorScheme.tertiary,
              unselectedItemColor: Theme.of(context).disabledColor,
              onTap: (v) => {
                // If you also want to pop all the routes on the Navigator stack, use
                // Navigator.pushNamedAndRemoveUntil(context, '/page2', (route) => false);
                if (v == 0)
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(builder: (_) => LocationsPage()),
                        (route) => false),
                  },
                if (v == 1)
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LocationsPage()),
                        (route) => false),
                  },
                if (v == 2)
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LocationsPage()),
                        (route) => false),
                  },
                if (v == 3)
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationsPage())),
                  },
                Redux.store.dispatch(barNavigationIndexAction(Redux.store, v)),
              },
            ),
          );
        });
  }
}
