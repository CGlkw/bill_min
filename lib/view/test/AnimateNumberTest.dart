
import 'package:bill/view/test/AnimateNumber.dart';
import 'package:flutter/material.dart';

import '../../config.dart';

class AnimateNumberTest extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AnimateNumberTestState();

}

class AnimateNumberTestState extends State<AnimateNumberTest> with SingleTickerProviderStateMixin{


  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AnimateNumberTest"),
      ),
      body: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 50.0,
              //padding: EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20),
              child: Row(
                children: [
                  Text("总消费",
                    style: TextStyle(
                        color: ColorConfig.primary_text,
                        fontSize: 20
                    ),
                  ),
                  Expanded(
                    child: AnimateNumber(
                        num: '1234567890.5',
                        fontSize: 30
                    ),
                  ),
                ],
              )
          ),
          Container(
            height: 50,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

}