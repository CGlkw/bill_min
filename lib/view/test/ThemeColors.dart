

import 'package:flutter/material.dart';

class ThemeColors extends StatelessWidget{


  @override
  Widget build(BuildContext context) {

    Map<String, Color> colors = {
      "primaryColor":Theme.of(context).primaryColor,
      "primaryColorLight":Theme.of(context).primaryColorLight,
      "textSelectionHandleColor":Theme.of(context).textSelectionHandleColor,
      "textSelectionColor":Theme.of(context).textSelectionColor,
      "splashColor":Theme.of(context).splashColor,
      "selectedRowColor":Theme.of(context).selectedRowColor,
      "secondaryHeaderColor":Theme.of(context).secondaryHeaderColor,
      "scaffoldBackgroundColor":Theme.of(context).scaffoldBackgroundColor,
      "indicatorColor":Theme.of(context).indicatorColor,
      "hoverColor":Theme.of(context).hoverColor,
      "hintColor":Theme.of(context).hintColor,
      "highlightColor":Theme.of(context).highlightColor,
      "focusColor":Theme.of(context).focusColor,
      "errorColor":Theme.of(context).errorColor,
      "dividerColor":Theme.of(context).dividerColor,
      "disabledColor":Theme.of(context).disabledColor,
      "dialogBackgroundColor":Theme.of(context).dialogBackgroundColor,
      "buttonColor":Theme.of(context).buttonColor,
      "bottomAppBarColor":Theme.of(context).bottomAppBarColor,
      "backgroundColor":Theme.of(context).backgroundColor,
      "accentColor":Theme.of(context).accentColor,
      "cursorColor":Theme.of(context).cursorColor,
      "cardColor":Theme.of(context).cardColor,
      "canvasColor":Theme.of(context).canvasColor,
      "toggleableActiveColor":Theme.of(context).toggleableActiveColor,
      "unselectedWidgetColor":Theme.of(context).unselectedWidgetColor,
      "primaryColorDark":Theme.of(context).primaryColorDark,

    };

    List<Widget> _buildItem(){
      List<Widget> res = new List();
      colors.forEach((key, value) {
        res.add(Container(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                color: value,
              ),
              Expanded(
                child: Text(key),
              )
            ],
          ),
        ));
      });
      return res;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('ThemeColors'),
        ),
        body:Container(
          child: GridView(
            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, //横轴三个子widget
                childAspectRatio: 1.0 //宽高比为1时，子widget
            ),
            children: _buildItem(),
          ),
        )
    );
  }

}