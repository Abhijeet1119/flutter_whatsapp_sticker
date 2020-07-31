import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class MyDrawer extends StatelessWidget {
  static const TextStyle _menuTextColor = TextStyle(
    color: Colors.black54,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static const IconThemeData _iconColor = IconThemeData(
    color: Colors.teal,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              "Whatsapp Sticker",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            accountEmail: Text("yourEmail@gmail.com"),
          ),
          ListTile(
            leading: IconTheme(
              data: _iconColor,
              child: Icon(Icons.share),
            ),
            title: Text("Share", style: _menuTextColor),
            onTap: () {
              Share.text(
                  "Download Best WhatsApp Stickers ",
                  "Download Best WhatsApp Stickers \n\n 👇👇👇👇👇 \nDownload Now\nhttps://play.google.com/YourPlayStoreLink",
                  "text/plain");
            },
          ),
          ListTile(
            leading: IconTheme(
              data: _iconColor,
              child: Icon(Icons.rate_review),
            ),
            title: Text("Rating & Review", style: _menuTextColor),
            onTap: () async {
              Navigator.of(context).pop();
              const url = 'https://play.google.com/YourPlayStoreLink';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not open App';
              }
            },
          ),
        ],
      ),
    );
  }
}
