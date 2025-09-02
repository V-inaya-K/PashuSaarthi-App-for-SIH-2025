import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pashusaarthi/pages/options.dart';
import 'package:pashusaarthi/pages/activity.dart';

class MyIntro extends StatefulWidget {
  @override
  _MyIntroState createState() => _MyIntroState();
}

class _MyIntroState extends State<MyIntro> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyIntro()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Options()));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Activity()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: _selectedIndex,
        // onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.house_fill), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.arrow_swap), label: 'Options'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.square_grid_4x3_fill), label: 'Activity')
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
