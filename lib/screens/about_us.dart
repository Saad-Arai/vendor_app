import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_vendor_app/constraints/colors.dart';
import 'package:share/share.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  List<String> itemContent = [
    'What is this app about?',
    'Our app is a community platform that connects '
        'skilled and unskilled people who want to sell their services'
        'time to individual users household business.\n\n'
        'Our app is a solution that lets you live '
        'an economically stable life by selling your skills'
        'to the right people with no capital requirements.'
        'me a shoutout. Pull requests are more than '
        'welcome too.\n\nThanks!',
    'Credits',
    'This app would not have been possible without '
        'the Flutter framework.'
        'This app is our team tireless efforts to make this possible\n\n'
        'This project is open source project.Please see the '
        'README.md file in the repository below for '
        'more details.\n\n Keep working!!',
  ]; //the text in the tile

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: invertInvertColorsStrong(context),
      body: Container(
        color: AppColors.primary,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Hero(
                    tag: 'tile1',
                    child: CustomTile(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('images/logo.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'FOODIE',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22.0,
                                color: invertColorsStrong(context),
                              ),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.twitter,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => launchURL(''),
                                ),
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.pink,
                                  ),
                                  onPressed: () => launchURL(''),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      splashColor: AppColors.primary,
                    ),
                  ),
                  CustomTile(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            itemContent[0],
                            //style: MyTextStyles.highlightStyle,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            itemContent[1],
                            style: TextStyle(
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              color: invertColorsStrong(context),
                            ),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                    splashColor: AppColors.primary,
                  ),
                  CustomTile(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            itemContent[2],
                            // style: MyTextStyles.highlightStyle,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            itemContent[3],
                            style: TextStyle(
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              color: invertColorsStrong(context),
                            ),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                    splashColor: MyColors.dark,
                  ),
                  SizedBox(
                    height: 36.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        child: Icon(
          FontAwesomeIcons.github,
        ),
        tooltip: 'View GitHub repo',
        foregroundColor: invertInvertColorsStrong(context),
        backgroundColor: invertColorsStrong(context),
        elevation: 5.0,
        onPressed: () => launchURL(''),
      ),
    );
  }
}
