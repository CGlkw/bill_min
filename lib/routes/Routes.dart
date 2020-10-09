
import 'package:bill/view/test/AnimateNumber.dart';
import 'package:bill/view/test/AnimateNumberTest.dart';
import 'package:flutter/material.dart';
import 'package:bill/view/add/BillAdd.dart';
import 'package:bill/view/index/index.dart';
import 'package:bill/view/theme/ThemeChangeRoute.dart';

class Routes{
  final Map<String, WidgetBuilder> routes = {};
  BuildContext c;

  Routes(this.c);

  Map<String, WidgetBuilder> init(){
    return {
      '/' : (c) => Index(),
      'bill_add' : (c) => BillAdd(),
      'themes': (c) => ThemeChangeRoute(),
      '/test': (c) => AnimateNumberTest(),
    };
  }

  dynamic argsFromContext(BuildContext context) {
    return ModalRoute.of(context).settings.arguments;
  }
}