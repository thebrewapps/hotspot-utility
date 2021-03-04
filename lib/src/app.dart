import 'package:flutter/material.dart';
import 'package:hotspotutility/src/screens/HomeScreen.dart';
// import 'package:hotspotutility/src/screens/hotspots_screen1.dart';
import 'package:hotspotutility/src/screens/more_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotspot Utility',
      theme: ThemeData(
          primaryColor: MaterialColor(0xff0F265A, {
        50: Color(0xff0F265A),
        100: Color(0xff0F265A),
        200: Color(0xff0F265A),
        300: Color(0xff0F265A),
        400: Color(0xff0F265A),
        500: Color(0xff0F265A),
        600: Color(0xff0F265A),
        700: Color(0xff0F265A),
        800: Color(0xff0F265A),
        900: Color(0xff0F265A),
      })),
      home: ParentWidget(),
    );
  }
}

class ParentWidget extends StatefulWidget {
  ParentWidget({Key key}) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[HomeScreen(), MoreScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home),
            title: Text('Hotspots'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text('More'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(int.parse('0xff0F265A')),
        onTap: _onItemTapped,
      ),
    );
  }
}
