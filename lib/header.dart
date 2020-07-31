import 'package:flutter/material.dart';
import 'constants.dart';


class Header extends StatelessWidget {
  const Header({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: kDefaultPadding * 0.01),
        // It will cover 20% of our total height
        height: size.height * 0.2,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: 22 + kDefaultPadding,
              ),
              height: size.height * 0.2 - 27,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'Whatsapp Sticker',
                    style: Theme.of(context).textTheme.headline.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Image.asset("assets/images/logo.png")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
