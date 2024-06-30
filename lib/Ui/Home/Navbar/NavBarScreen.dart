import 'package:flutter/material.dart';
import 'package:gemini/Ui/Home/FavoriteScreen/FavoriteMemoriesScreen.dart';
import 'package:gemini/Ui/Home/GlobalMemoriesScreen/GlobamMemoriesScreen.dart';
import 'package:gemini/Ui/Home/GlobalMemoriesScreen/component/component.dart';
import 'package:gemini/Ui/Home/MyMemoriesScreen/MyMemoriesScreen.dart';
import 'package:gemini/Ui/Home/NewMemoryScreen/NewMemoryScreen.dart';
import 'package:gemini/Ui/Home/ProfileScreen/ProfileScreen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Navbarscreen extends StatefulWidget {
  const Navbarscreen({super.key});

  @override
  State<Navbarscreen> createState() => _NavbarscreenState();
}

class _NavbarscreenState extends State<Navbarscreen> {
  var _currentIndex = 0;
  var screens=[MyMemoriesScreen(),Favoritememoriesscreen(),Globammemoriesscreen(),ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("EBF4F6"),

      bottomNavigationBar: SalomonBottomBar(

        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home_outlined),
            title: Text("Home"),
            selectedColor: Colors.orange,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Likes"),
            selectedColor: Colors.orange,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.people_alt_outlined),
            title: Text("Globe"),
            selectedColor: Colors.blue,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.blue,
          ),
        ],

      ),
      body: screens[_currentIndex],
    );
  }
}
