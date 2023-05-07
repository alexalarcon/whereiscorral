import 'package:flutter/material.dart';

import 'helpers.dart';

class SubscriberDetailCard extends StatelessWidget {
  const SubscriberDetailCard({
    Key? key,
    required this.order,
    required this.status,
    required this.counter,
    required this.client,
    required this.address,
  }) : super(key: key);
  final String order;
  final String status;
  final String counter;
  final String client;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackgroundText(
                    tile: "Nº de orden: $order",
                  ),
                  CustomBackgroundText(
                    tile: firstLetterUpperCase(status),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 12, bottom: 12, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(client,
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Text(address,
                                    style:
                                        Theme.of(context).textTheme.headline3),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.abc,
                                    size: 18,
                                  ),
                                ),
                                Text(
                                  counter,
                                  style: const TextStyle(
                                    color: Color(0xFF243656),
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBackgroundText extends StatelessWidget {
  const CustomBackgroundText({
    Key? key,
    required this.tile,
  }) : super(key: key);
  final String tile;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: (tile == "Enviado")
                ? const Color.fromARGB(118, 40, 166, 99)
                : (tile == "Leido")
                    ? const Color.fromARGB(126, 250, 204, 88)
                    : const Color(0xFFF3F4F6),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
            child: Text(
              tile,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          )),
    );
  }
}
