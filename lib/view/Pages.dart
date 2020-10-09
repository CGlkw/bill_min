import 'package:flutter/cupertino.dart';

abstract class Pages{

  Pages init();

  PreferredSizeWidget getAppBar(BuildContext context);

  Widget getBody();

  void flush();
}