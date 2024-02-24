import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  String? title;

  SimpleAppBar({this.bottom, this.title});

  @override
  Size get preferredSize {
    return bottom == null
        ? Size(56, AppBar().preferredSize.height)
        : Size(56, 80 + AppBar().preferredSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.amber[900]),
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
      centerTitle: true,
      title: Text(
        title!,
        style: const TextStyle(
            fontSize: 45, fontFamily: 'Signatra', letterSpacing: 3),
      ),
    );
  }
}
