import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rick_morty_app/ui/home.dart';
import 'package:rick_morty_app/ui/people.dart';
import '../utils/constant.dart' as Constants;


void main() {
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final screens = [
    const HomePage(),
    const PeoplePage(),
    const Center(child: Text(
        'Episode', style: TextStyle(fontFamily: 'Shwifty', fontSize: 60))),
  ];
  List<String> choices = <String>[
    Constants.DISCONNECTION,
  ];

  void choiceAction(String choice) {
    if (choice == Constants.DISCONNECTION) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Image.asset("assets/Rick_and_Morty_logo.png",
                  fit: BoxFit.contain, height: 40),
              centerTitle: true,
              backgroundColor: Colors.black,
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  icon: const Icon(Icons.settings),
                )
              ],
            ),
            body: screens[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black,
              selectedItemColor: Colors.lightGreen[700],
              unselectedItemColor: Colors.white,
              showUnselectedLabels: false,
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: "People"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.movie), label: "Episode"),
              ],
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ));
}
