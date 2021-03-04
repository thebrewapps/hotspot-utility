import 'package:flutter/material.dart';
import 'package:hotspotutility/src/screens/hotspots_screen2.dart';

import 'hotspots_screen1.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CoastFi',
          style: TextStyle(
              fontFamily: 'Nexa', fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
      ),
      body: Column(
         mainAxisSize: MainAxisSize.max,
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Center(),
            Text(
              'CHOOSE HOTSPOT MODEL',
              style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25.0,
                        color: Theme.of(context).primaryColor
                        ),
            ),
            SizedBox(height: 40),
            Text(
              'Click the image below that looks like your CoastFi Hotspot',
              textAlign: TextAlign.center,
              style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: Colors.black38),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HotspotsScreen1()),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset('assets/images/hotspot-model-1.png',width: 100,),
                      Text('Model 1',style: TextStyle(decoration: TextDecoration.underline,),)
                    ],
                  )
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HotspotsScreen2()),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset('assets/images/hotspot-model-2.png',width: 100,),
                      Text('Model 2',style: TextStyle(decoration: TextDecoration.underline,),)
                    ],
                  )
                ),
              ],
            ),
          ],
        ),
    );
  }
}