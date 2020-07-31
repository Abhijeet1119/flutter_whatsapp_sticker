import 'package:flutter/material.dart';
import 'package:flutterwhatsappstickers/Widgets/Admob.dart';
import 'package:flutterwhatsappstickers/Widgets/Drawer.dart';
import 'body.dart';


class MyHomePage extends StatefulWidget {
 @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    AdmobAd.initialize();
    AdmobAd.showBannerAd();
  }
  @override
  void dispose() {
    AdmobAd.hideBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF0C9869),
      ),

      body: Body(),
      drawer: Drawer(
        child: MyDrawer(),
      ),
    );
  }
}

