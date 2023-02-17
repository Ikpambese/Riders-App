import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_riders_app/assistant/get_current_location.dart';
import 'package:food_riders_app/global/global.dart';
import 'package:food_riders_app/maps/map_utilities.dart';
import 'package:food_riders_app/screens/parcel_delivering.dart';

class ParcelPickingScreen extends StatefulWidget {
  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerId;
  String? getOrderID;
  ParcelPickingScreen({
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserId,
    this.purchaserLat,
    this.purchaserLng,
    this.sellerId,
  });

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {
  double? sellerLat, sellerLng;
  getSellerData() {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(widget.sellerId)
        .get()
        .then((DocumentSnapshot) {
      sellerLat = DocumentSnapshot.data()!['lat'];
      sellerLng = DocumentSnapshot.data()!['lng'];
    });
  }

  confirmParcelHasBeenPicked(getOrderId, sellerId, purchaserId,
      purchaserAddress, purchaserLat, purchaserLng) {
    FirebaseFirestore.instance.collection('orders').doc(getOrderId).update({
      'status': 'delivering',
      'address': completeAddress,
      'lat': position!.latitude,
      'lng': position!.longitude,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => ParcelDeliveringScreen(
          purchaserId: purchaserId,
          purchaserAddress: purchaserAddress,
          purchaserLat: purchaserLat,
          purchaserLng: purchaserLng,
          sellerId: sellerId,
          getOrderId: getOrderId,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSellerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/confirm1.png',
              // width: 50,
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // from rider towards seller
                MapUtilities.luncMapFromSourceToDestination(position!.latitude,
                    position!.longitude, sellerLat, sellerLng);
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
                        'Show Cafe / Restaurant Location',
                        style: TextStyle(
                            fontFamily: 'Signatra',
                            fontSize: 18,
                            letterSpacing: 2),
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
                    UserLocation uLocation = UserLocation();
                    uLocation.getCurrentLocation();
                    confirmParcelHasBeenPicked(
                      widget.getOrderID,
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
                        "Order has been Picked Confirm",
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
