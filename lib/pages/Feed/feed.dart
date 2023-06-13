import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../common/botton_navigation_bar_custom.dart';
import '../../redux/App.state.dart';
import '../../redux/locations/locations.action.dart';
import '../../redux/locations/locations.model.dart';
import '../../redux/locations/locations.state.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);
  static const String routeName = 'feed';

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late AsyncMemoizer _memoizer;

  @override
  void initState() {
    super.initState();
    _memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(locationsListAction);
    return StoreConnector<AppState, LocationsState>(
        distinct: false,
        converter: (store) => store.state.locationsState,
        builder: (context, storeData) {
          for (var element in storeData.locations) {}
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
            body: ListView.builder(
              itemCount: storeData.locations.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _header(index, storeData.locations[index], context),
                      _imageInsta(context,
                          storeData.locations[index].imagenUrl.toString()),
                      Row(
                        children: <Widget>[
                          StoreConnector<AppState, AppState>(
                              distinct: true,
                              converter: (store) => store.state,
                              builder: (context, auth) {
                                return Container();
                                // return  _likeButton(index, auth.authState, auth.assemblyState.likes, widget.items[index]);
                              }),
                          // _commentButton(index, context),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            // "Este post le ha gustado a ${widget.items[index].likes} personas",
                            // style: TextStyle(fontWeight:14);
                            storeData.locations[index].locationName.toString()),
                      ),
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: Visibility(
                // visible: (storeData.locations.isNotEmpty),
                child: const BottonNavigationBarCustom()),
          );
        });
  }

  _fetchData(String path) async {
    //  String ref = await FireStorageService.loadFromStorage(path);
    //   return ref;
    // return this._memoizer.runOnce(() async {
    Reference ref = await FirebaseStorage.instance.ref(path);
    return ref.fullPath;
    // });
  }

  FutureBuilder _imageInsta(BuildContext context, String ref) {
    return FutureBuilder(
        future: _fetchData(ref),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String ref = snapshot.data;

            print("REFFFFF");
            print(ref);
            if (ref.contains(".mp4") || ref.contains(".MOV")) {
              return GestureDetector(
                onTap: () {
                  //        Navigator.pushNamed(context, VideoPage.routeName, arguments: ref);
                },
                child: Column(
                  children: [
                    // AspectRatio(
                    //     aspectRatio: 16 / 16,
                    //     child: Container(
                    //       child: (ref != null
                    //           ? HLSVideoExample(
                    //               ref: ref,
                    //             ) //Image.asset("assets/video.png")
                    //           : Container()),
                    //     )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Pulsa el video para reproducirlo"),
                    )
                  ],
                ),
              );
            } else if (ref.contains(".jpg") ||
                ref.contains(".jpeg") ||
                ref.contains(".gif") ||
                ref.contains(".png")) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        snapshot.data,
                      ),
                    ),
                  ));
            } else
              return Container();
          } else
            return CircularProgressIndicator();
        });
    // }
  }

  Padding _header(int index, LocationModel item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            foregroundImage: AssetImage("assets/images/face.png"),
          ),
          Text(
            (item.locationName == null) ? ' ' : "    ${item.nombre}",
            style: Theme.of(context).textTheme.headline6,
          ),
          Expanded(child: Container()),
          // StoreConnector<AppState, AuthState>(
          //   distinct: true,
          //   converter: (store) => store.state.authState,
          //   builder: (context, authState) {
          //     if (authState.userDetail.admin) {
          //       return PopupMenuButton<AfterModel>(
          //         onSelected: (AfterModel result) {
          //           Redux.store.dispatch(
          //               deletePostAssembly(Redux.store, context, result));
          //         },
          //         itemBuilder: (BuildContext context) =>
          //             <PopupMenuEntry<AfterModel>>[
          //           PopupMenuItem<AfterModel>(
          //             value: item,
          //             child: Text('Borrar publicación'),
          //           ),
          //         ],
          //       );
          //     } else {
          //       return SizedBox.shrink();
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
