import 'package:flutter/material.dart';
import 'package:food_riders_app/global/global.dart';
import 'package:food_riders_app/splash/splash_screen.dart';

class EraningsScreen extends StatefulWidget {
  @override
  State<EraningsScreen> createState() => _EraningsScreenState();
}

class _EraningsScreenState extends State<EraningsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₦ ' + previousEarnings,
              style: const TextStyle(
                  fontSize: 80, color: Colors.white, fontFamily: 'Signatra'),
            ),
            const Text(
              'Total Earnings',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(
              height: 40,
              width: 200,
              child: Divider(
                thickness: 1.5,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const MySplashScreen()));
              },
              child: const Card(
                color: Colors.white54,
                margin: EdgeInsets.symmetric(vertical: 60, horizontal: 140),
                child: ListTile(
                  leading: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  title: Text('Back',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
