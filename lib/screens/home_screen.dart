import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_riders_app/assistant/get_current_location.dart';
import 'package:food_riders_app/authentication/auth_screen.dart';
import 'package:food_riders_app/global/global.dart';
import 'package:food_riders_app/screens/earnings_screen.dart';
import 'package:food_riders_app/screens/history_screen.dart';
import 'package:food_riders_app/screens/new_orders_screen.dart';
import 'package:food_riders_app/screens/not_yet_delivered.dart';
import 'package:food_riders_app/screens/parcel_in_progress_screen.dart';
import 'package:food_riders_app/splash/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan,
                    Colors.amber,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              )
            : const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.redAccent,
                    Colors.amber,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              // new available order
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewOrderScreen(),
                ),
              );
            }
            if (index == 1) {
              // perc
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParcelInProgressScreen(),
                ),
              );
            }
            if (index == 2) {
              // new order

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotYetDeliveredScreen(),
                ),
              );
            }
            if (index == 3) {
              // history

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Historycreen(),
                ),
              );
            }
            if (index == 4) {
              // total earnings
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EraningsScreen(),
                ),
              );
            }
            if (index == 5) {
              // log out

              firebaseAuth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50.0),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  restrictctBlockedeRiders() async {
    await FirebaseFirestore.instance
        .collection('riders')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.data()!['riderSatus'] != 'approved') {
        Fluttertoast.showToast(
            msg: 'You have been blocked \n\n Mail Here : admin@lunchbox.com');
        firebaseAuth.signOut();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MySplashScreen()));
      } else {
        UserLocation? uLocation = UserLocation();
        uLocation.getCurrentLocation();
        getParcelDeliveryAmount();
        getRiderPreviousEarnings();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    restrictctBlockedeRiders();
  }

  getRiderPreviousEarnings() {
    FirebaseFirestore.instance
        .collection('riders')
        .doc(sharedPreferences!.getString('uid'))
        .get()
        .then((snap) {
      previousRiderEarnings = snap.data()!['earnings'];
    });
  }

  getParcelDeliveryAmount() {
    FirebaseFirestore.instance
        .collection('perDelivery')
        .doc('tersen1996')
        .get()
        .then((snap) {
      perParcelDeliveryAmount = snap.data()!['amount'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
            ),
          ),
        ),
        title: Text(
          'Welcome ' + sharedPreferences!.getString('name')!,
          style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontFamily: 'Signatra',
              letterSpacing: 2),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem('New Available Orders', Icons.assessment, 0),
            makeDashboardItem('Parcel in Progress', Icons.airport_shuttle, 1),
            makeDashboardItem('Not Yet Delivered', Icons.location_history, 2),
            makeDashboardItem('History', Icons.done_all, 3),
            makeDashboardItem('Total Earning', Icons.monetization_on, 4),
            makeDashboardItem('Logout', Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
