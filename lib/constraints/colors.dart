import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppColors {
  static const white = Colors.white;
  static const secondary = Color(0xff323335);
  static const lightGray = Color(0xffc0c1c3);
  static const lighterGray = Color(0xffe0e0e0);
  static const black = Colors.black;
  static const primary = Color(0xFFfff5e6);
  static const tertiary = Color(0xffff36b6b);
  static const appbarcolor = Color(0xffFFCEA2);
}

class MyColors {
  static const primary = Color(0xff212121);
  static const accent = Color(0xff00e5ff);
  static const light = Color(0xffeceff1);
  static const dark = Color(0xffd3d3d3);
  static const white = Color(0xfffafafa);
  static const black = Color(0xff212121);
  static const heart = Color(0xfff50057);
  static const twitter = Color(0xff00b0ff);
  static const github = Color(0xff212121);
}

class MaterialColors {
  static const red = Color(0xffd50000);
  static const blue = Color(0xff2962ff);
  static const yellow = Color(0xffffd600);
  static const green = Color(0xff00c853);
  static const purple = Color(0xffaa00ff);
  static const pink = Color(0xffc51162);
  static const orange = Color(0xffff6d00);
  static const teal = Color(0xff00bfa5);
}

class ShadowColors {
  static const light = Color(0x80718792);
  static const dark = Color(0x801c313a);
}

void doNothing() {
  print('Nothing is happening here (yet)');
} //better than doing null-ing, right? ;)

bool isIOS(BuildContext context) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return true;
  } else {
    return false;
  }
} // check if android or ios

bool isThemeCurrentlyDark(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return true;
  } else {
    return false;
  }
} //returns current theme status

Color invertColorsTheme(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.primary;
  } else {
    return MyColors.accent;
  }
} //returns appropriate theme colors for ui elements

Color invertInvertColorsTheme(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.accent;
  } else {
    return MyColors.primary;
  }
} //keeps the same colors lol

Color invertColorsMild(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.light;
  } else {
    return MyColors.dark;
  }
} //returns appropriate mild colors for text visibility

Color invertInvertColorsMild(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.dark;
  } else {
    return MyColors.light;
  }
} //keeps the same colors lol

Color invertColorsStrong(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.white;
  } else {
    return MyColors.black;
  }
} //returns appropriate strong colors for text visibility

Color invertInvertColorsStrong(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.primary;
  } else {
    return MyColors.white;
  }
} //keeps the same colors lol

Color invertColorsMaterial(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MaterialColors.orange;
  } else {
    return MaterialColors.yellow;
  }
} //returns appropriate material colors

Color shadowColor(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return ShadowColors.dark;
  } else {
    return ShadowColors.light;
  }
} //returns appropriate colors for raised element shadows

launchURL(String url) async {
  if (await canLaunch(url)) {
    print('Launching $url...');
    await launch(url);
  } else {
    print('Error launching $url!');
  }
}

class CustomTile extends StatelessWidget {
  const CustomTile({
    Key? key,
    required this.child,
    this.color,
    required this.splashColor,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final Color? color;
  final Color splashColor;
  final Function()? onTap;

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Material(
        color: color,
        elevation: 10.0,
        borderRadius: BorderRadius.circular(15.0),
        shadowColor: shadowColor(context),
        child: InkWell(
          child: child,
          splashColor: splashColor,
          borderRadius: BorderRadius.circular(15.0),
          onTap: onTap == null ? doNothing : () => onTap!(),
        ),
      ),
    );
  }
}
