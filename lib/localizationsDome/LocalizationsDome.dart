import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'MyLocalizations.dart';

void main() async {
  runApp(
    LocalizationsDome(),
  );
}

class LocalizationsDome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocalizationsDomeState();
  }
}

class LocalizationsDomeState extends State<LocalizationsDome> {
  Locale _locale = Locale('zh', '');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        MyLocalizationsDemoDelegate(),
      ],
      locale: _locale,
      supportedLocales: [Locale('zh', ''), Locale('en', '')],// 必须声明
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: RaisedButton(
            child: Builder(
              builder: (ctx) {
                return Text(MyLocalizations.of(ctx).title());
              },
            ),
            onPressed: () {
              String languageCode = _locale.languageCode;
              setState(() {
                if (languageCode == 'en') {
                  _locale = Locale('zh', '');
                } else {
                  _locale = Locale('en', '');
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
