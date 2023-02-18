import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_riders_app/global/global.dart';
import 'package:food_riders_app/splash/splash_screen.dart';

import '../assistant/get_current_location.dart';
import '../maps/map_utilities.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserAddress;
  String? purchaserId;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerId;
  String? getOrderId;
  ParcelDeliveringScreen(
      {this.getOrderId,
      this.purchaserAddress,
      this.purchaserId,
      this.purchaserLat,
      this.purchaserLng,
      this.sellerId});

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {
  String orderTotalAmount = '';
  confirmParcelHasBeenDelivered(getOrderId, sellerId, purchaserId,
      purchaserAddress, purchaserLat, purchaserLng) {
    String riderNewTotalEarningAmount = ((double.parse(previousRiderEarnings) +
            (double.parse(perParcelDeliveryAmount))))
        .toString();
    FirebaseFirestore.instance.collection('orders').doc(getOrderId).update({
      'status': 'ended',
      'address': completeAddress,
      'lat': position!.latitude,
      'lng': position!.longitude,
      'earnings': perParcelDeliveryAmount //pay per delivery
    }).then((value) {
      FirebaseFirestore.instance
          .collection('riders')
          .doc(sharedPreferences!.getString('uid'))
          .update({
        'earnings': riderNewTotalEarningAmount, // total rider earnings
      }).then((value) {
        FirebaseFirestore.instance
            .collection('sellers')
            .doc(widget.sellerId)
            .update({
          'earnings': (double.parse(orderTotalAmount) +
                  (double.parse(previousEarnings)))
              .toDouble(),
        });
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(purchaserId)
          .collection('orders')
          .doc(getOrderId)
          .update({
        'status': 'ended',
        'riderUID': sharedPreferences!.getString('uid'),
      });
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => const MySplashScreen(),
      ),
    );
  }

  getOrderTotalAmount() {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.getOrderId)
        .get()
        .then((snap) {
      orderTotalAmount = snap.data()!['totalAmount'].toString();
      widget.sellerId = snap.data()!['sellerUID'].toString();
    }).then((value) {
      getSellerData();
    });
  }

  getSellerData() {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(widget.sellerId)
        .get()
        .then((snap) {
      previousEarnings = snap.data()!['earnings'].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    UserLocation uLocation = UserLocation(); // Rider location
    uLocation.getCurrentLocation();
    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/confirm2.png',
              // width: 50,
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // from rider towards seller
                MapUtilities.luncMapFromSourceToDestination(
                    position!.latitude,
                    position!.longitude,
                    widget.purchaserLat,
                    widget.purchaserLng);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/restaurant.png', width: 50),
                  const SizedBox(width: 7),
                  Column(
                    children: const [
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        'Show Delivery Drop off Location / Restaurant Location',
                        style: TextStyle(
                          fontFamily: 'Signatra',
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: InkWell(
                  onTap: () {
                    // PICKED CONFIRM that rider has picked parcel from restuarant
                    UserLocation uLocation = UserLocation(); // Rider location
                    uLocation.getCurrentLocation();
                    confirmParcelHasBeenDelivered(
                      widget.getOrderId,
                      widget.sellerId,
                      widget.purchaserId,
                      widget.purchaserAddress,
                      widget.purchaserLat,
                      widget.purchaserLng,
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.amber,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )),
                    width: MediaQuery.of(context).size.width - 90,
                    height: 50,
                    child: const Center(
                      child: Text(
                        "Order has been delivered/ Confirm",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
