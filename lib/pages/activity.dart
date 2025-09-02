import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:pashusaarthi/pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pashusaarthi/pages/options.dart';


class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  bool isLogin = true;
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "My Activity",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyIntro()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Options()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Activity()),
            );
          }
        },
        type: BottomNavigationBarType.fixed, // Fixed
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 12,
        // backgroundColor: Colors.white, // <-- This works for fixed
        // selectedItemColor: Colors.blueAccent,
        // unselectedItemColor:Color.fromRGBO(75,75,75, 1.0),
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_swap),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_grid_4x3_fill),
            label: 'Services',
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: Colors.white,
        ),
        child: Column(
          children: [
          ],
        ),
      ),
    );
  }
}

