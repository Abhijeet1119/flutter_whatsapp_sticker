import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_whatsapp_stickers/flutter_whatsapp_stickers.dart';
import 'package:flutterwhatsappstickers/utils.dart';
import 'package:flutterwhatsappstickers/sticker_pack_info.dart';
import 'constants.dart';

class StickerList extends StatefulWidget {
  @override
  _StickerListState createState() => _StickerListState();
}

class _StickerListState extends State<StickerList> {
  final WhatsAppStickers _waStickers = WhatsAppStickers();
  List stickerList = new List();
  List installedStickers = new List();

  void _loadStickers() async {
    String data =
        await rootBundle.loadString("sticker_packs/sticker_packs.json");
    final response = json.decode(data);
    List tempList = new List();

    for (int i = 0; i < response['sticker_packs'].length; i++) {
      tempList.add(response['sticker_packs'][i]);
    }
    setState(() {
      stickerList.addAll(tempList);
    });
    _checkInstallationStatuses();
  }

  void _checkInstallationStatuses() async {
    print("Total Stickers : ${stickerList.length}");
    for (var j = 0; j < stickerList.length; j++) {
      var tempName = stickerList[j]['identifier'];
      bool tempInstall =
          await WhatsAppStickers().isStickerPackInstalled(tempName);

      if (tempInstall == true) {
        if (!installedStickers.contains(tempName)) {
          setState(() {
            installedStickers.add(tempName);
          });
        }
      } else {
        if (installedStickers.contains(tempName)) {
          setState(() {
            installedStickers.remove(tempName);
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStickers();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: stickerList.length,
        itemBuilder: (context, index) {
          if (stickerList.length == 0) {
            return Container(
              child: CircularProgressIndicator(),
            );
          } else {
            var stickerId = stickerList[index]['identifier'];
            var stickerName = stickerList[index]['name'];
            var stickerPublisher = stickerList[index]['publisher'];
            var stickerTrayIcon = stickerList[index]['tray_image_file'];
            var tempStickerList = List();

            bool stickerInstalled = false;
            if (installedStickers.contains(stickerId)) {
              stickerInstalled = true;
            } else {
              stickerInstalled = false;
            }
            tempStickerList.add(stickerList[index]['identifier']);
            tempStickerList.add(stickerList[index]['name']);
            tempStickerList.add(stickerList[index]['publisher']);
            tempStickerList.add(stickerList[index]['tray_image_file']);
            tempStickerList.add(stickerList[index]['stickers']);
            tempStickerList.add(stickerInstalled);
            tempStickerList.add(installedStickers);

            return stickerPack(
              tempStickerList,
              stickerName,
              stickerPublisher,
              stickerId,
              stickerTrayIcon,
              stickerInstalled,
            );
          }
        });
  }

  Widget stickerPack(List stickerList, String name, String publisher,
      String identifier, String stickerTrayIcon, bool installed) {
    Widget depInstallWidget;
    if (installed == true) {
      depInstallWidget = IconButton(
        icon: Icon(
          Icons.check,
        ),
        color: Colors.teal,
        tooltip: 'Add Sticker to WhatsApp',
        onPressed: () {},
      );
    } else {
      depInstallWidget = IconButton(
        icon: Icon(
          Icons.add,
        ),
        color: Colors.teal,
        tooltip: 'Add Sticker to WhatsApp',
        onPressed: () async {
          _waStickers.addStickerPack(
            packageName: WhatsAppPackage.Consumer,
            stickerPackIdentifier: identifier,
            stickerPackName: name,
            listener: (action, result, {error}) => processResponse(
              action: action,
              result: result,
              error: error,
              successCallback: () async {
                _checkInstallationStatuses();
              },
              context: context,
            ),
          );
        },
      );
    }

    return Container(
      child: InkWell(
        child: Card(
          elevation: 7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(80.0),
            ),
          ),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    StickerPackInformation(stickerList),
              ));
            },
            title: Text("$name"),
            subtitle: Text("$publisher"),
            leading: Image.asset("sticker_packs/$identifier/$stickerTrayIcon"),
            trailing: Column(
              children: <Widget>[
                depInstallWidget,
              ],
            ),
          ),
        ),
      ),
      padding: EdgeInsets.all(10.0),
    );
  }
}

class CardTiles extends StatelessWidget {
  const CardTiles({
    Key key,
    this.image,
    this.title,
    this.press,
  }) : super(key: key);

  final String image, title;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding * 2.5,
      ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          Image.asset(image),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "$title\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
