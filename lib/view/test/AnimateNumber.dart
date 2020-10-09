
import 'dart:core';

import 'package:flutter/material.dart';

class AnimateNumber extends StatefulWidget{

  final String  num;

  final double fontSize;

  AnimateNumber({@required this.num, this.fontSize = 20});

  @override
  State<StatefulWidget> createState() => AnimateNumberState();

}

class AnimateNumberState extends State<AnimateNumber> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation<double> animation;

  int _length;

  String numStr;

  List<num> x =[];

  @override
  void initState() {
    super.initState();

    numStr = widget.num;
    _length = numStr.length;

    for(int i = 0;i<_length;i++){
      int unitCode = numStr.codeUnitAt(i);
      if(unitCode == 46){
        x.add(0);
        continue;
      }
      int indexNum = unitCode - 48;
      int l = 90909 * indexNum + 909091 * i;
      x.add(l / 909091) ;
    }
    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    //图片宽高从0变到300
    animation = new Tween(begin: 0.0, end: 909091.0).animate(controller);
    animation.addStatusListener((status) {

      if (status == AnimationStatus.completed) {
        //动画执行结束时反向执行动画
        //controller.reset();
        //controller.forward();
      }
    });
    animation.addListener(() {
      setState(() {

      });
    });
    //启动动画
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.fontSize* 0.618 * _length,
      child: OverflowBox(
        maxHeight:widget.fontSize * 11,
        child: Row(
          children: x.map<Widget>((e){
            if (e == 0){
              return _item('.');
            } else {
              return _buildNumItem(-(0.909091-((animation.value * e) % 909091) / 1000000));
            }
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNumItem(value){
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: 0.1,
        child: Container(
          height: widget.fontSize * 11,
          width: widget.fontSize* 0.618,
          //color: Colors.blue,
          child: FractionalTranslation(
            translation: Offset(0,value),
            //transformHitTests: false,
            child: _buildNums(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildNums(){
    return Container(
      width: widget.fontSize,
      height: widget.fontSize * 11,
      child: Column(
        children: [
          _item(0),
          _item(9),
          _item(8),
          _item(7),
          _item(6),
          _item(5),
          _item(4),
          _item(3),
          _item(2),
          _item(1),
          _item(0),
        ],
      ),
    );
  }

  Widget _item(index){

    return Container(
      height: widget.fontSize,
      child: Center(
        child: Text('$index',
        style: TextStyle(
          fontSize: widget.fontSize
        ),),
      ),
    );
  }
}
