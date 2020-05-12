import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MyLocalizations {
  String languageCode;

  MyLocalizations(this.languageCode);

  static MyLocalizations of(context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  title() {
    return this.languageCode == 'zh' ? "标题" : "TITLE";
  }
}

class MyLocalizationsDemoDelegate
    extends LocalizationsDelegate<MyLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ['zh','en'].contains(locale.languageCode);
  }

  // 触发load 事件条件
  // 1. locale 发生变换
  // 2. shouldReload 返回true 且 rebuild
  @override
  Future<MyLocalizations> load(Locale locale) {
    print('$locale');
    return SynchronousFuture<MyLocalizations>(
      MyLocalizations(locale.languageCode),
    );
  }

  // 当组件rebuild 是是否触发load 事件
  @override
  bool shouldReload(LocalizationsDelegate<MyLocalizations> old) {
    return false;
  }
}
