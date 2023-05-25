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
            body: body(context, storeData),
            bottomNavigationBar: Visibility(
                visible: (storeData.locations.isNotEmpty),
                child: const BottonNavigationBarCustom()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
            ),
          );
        });
  }

  SingleChildScrollView body(BuildContext context, LocationsState storeData) {
    return SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                      size: 18,
                    ),
                    tooltip: 'Configuración',
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //         builder: (context) => const SettingsPage()));
                    },
                  ),
                ),
              ]),
              (storeData.locations.isEmpty)
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rutas",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          (storeData.locations.isNotEmpty)
                              ? "IS NOT EMPTY"
                              : "",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
              (storeData.locations.isEmpty)
                  ? SizedBox(
                      width: double.infinity,
                      height: 400.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              child: Text("")),
                          Text(
                            "No tienes rutas asignadas",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Text(
                            "Aquí podrás ver las rutas que te asigne el administrador.",
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : lista(storeData),
            ],
          ),
        ));
  }

  ListView lista(LocationsState storeData) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: storeData.locations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GeneralTile(
              tile: storeData.locations[index].nombre.toString(),
              icon: Icons.rocket,
              title: storeData.locations[index].nombre.toString(),
              id: storeData.locations[index].toString(),
              num: storeData.locations[index].numRutas ?? 0,
            ),
          );
        });
  }

  ///https://api.flutter.dev/flutter/material/Icons-class.html
}

class GeneralTile extends StatelessWidget {
  const GeneralTile({
    Key? key,
    required this.tile,
    required this.icon,
    required this.title,
    required this.id,
    required this.num,
  }) : super(key: key);
  final String tile;
  final IconData icon;
  final String title;
  final String id;
  final int num;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            // Navigator.of(context).push(
            //     CupertinoPageRoute(builder: (context) => const SettingsPage()));
          },
          child: Card(
            elevation: 0,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              onTap: () => {
                if (num <= 0)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      behavior: SnackBarBehavior.floating,
                      padding: const EdgeInsets.all(20),
                      duration: const Duration(seconds: 1),
                      content: const Text(
                        'Esta ruta no tiene equipos',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                      ),
                    )),
                  }
                else
                  {
                    // Redux.store.dispatch(subscriberListAction(Redux.store, id)),
                    // Navigator.push(
                    //     context,
                    //     SlideRightRoute(
                    //         widget: RutesResult(
                    //       title: title,
                    //     )))
                  }
              },
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 25,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(tile, style: Theme.of(context).textTheme.subtitle1),
              subtitle: Text('$num equipos',
                  style: Theme.of(context).textTheme.bodyText2),
              trailing: Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.fork_right,
                  size: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ));
  }
}
