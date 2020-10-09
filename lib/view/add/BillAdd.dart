
import 'package:bill/api/BillService.dart';
import 'package:bill/api/BillTypeService.dart';
import 'package:bill/common/BillIcon.dart';
import 'package:bill/dao/bill_dao.dart';
import 'package:bill/dao/bill_type_dao.dart';
import 'package:bill/view/add/component/BillTypeEdit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'component/AddKeyBord.dart';

class BillAdd extends StatefulWidget{
  @override
  _BillAddState createState() => _BillAddState();
}

class _BillAddState extends State<BillAdd>with SingleTickerProviderStateMixin {

  List<BillType> billTypes= List();

  int selectIndex = -1;

  bool isShow = false;

  AnimationController _animationController;
  Animation _sizeAnimation;
  Animation _addSizeAnimation;


  @override
  void initState() {
    _animationController =
    AnimationController(duration: Duration(milliseconds: 500), vsync: this)
      ..addListener((){setState(() {

      });});

    _sizeAnimation = Tween(begin: 2.0, end: 18.0).animate(CurvedAnimation(
        parent: _animationController, curve: Cubic(1,2.49,.5,.21)));
    _addSizeAnimation = Tween(begin: 2.0, end: 40.0).animate(CurvedAnimation(
        parent: _animationController, curve: Cubic(1,2.49,.5,.21)));
    //开始动画
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Add'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColor, Theme.of(context).textSelectionColor],
            ),
          ),
        ),
        actions: [
          _isHideDel?Container():InkWell(
            onTap: (){
              _animationController.reset();

              setState(() {
                billTypes.removeAt(billTypes.length - 1);

                _isHideDel = !_isHideDel;
              });

            },
            child: Container(
              padding: EdgeInsets.only(left: 18,right: 18),
              child: Center(
                child: Text("取消",style: TextStyle(
                  color: Colors.white
                ),),
              ),
            ),
          )
        ],
      ),
      body:Container(
        alignment: Alignment.center,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, //横轴三个子widget
              childAspectRatio: 1.0 //宽高比为1时，子widget
          ),
          itemBuilder: (context, index) =>_buildItem(index),
          itemCount: billTypes.length,
        )

        /*GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, //横轴三个子widget
              childAspectRatio: 1.0 //宽高比为1时，子widget
          ),
          children:iconButtons
        )*/
      )
    );
  }

  _onSubmit(Bill bill){
    BillService().addBill(bill);

  }

  _init(){
    BillTypeService().querySelected().then((value) => {
      setState((){
        billTypes = value;
      })
    });
  }

  bool _isHideDel = true;

  Widget _buildItem(index){
    if(!_isHideDel && index == billTypes.length - 1){
      return Container(
        child: IconButton(
          icon: Icon(
            Icons.add,
          ),
          color: Theme.of(context).primaryColor,
          iconSize:_addSizeAnimation.value,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => BillTypeEdit())).then((value) =>
            {
              _animationController.reset(),
              setState(() {
                _isHideDel = true;
              }),
              _init()
            });
          },
        )
      );
    }

    
    var off = 9 - _sizeAnimation.value / 2;
    return Stack(
      children: [
        _buildIcon(billTypes[index]),
        Positioned(
            right: 22.0 + off,
            top: 12.0 + off,
            child:Offstage(
              //duration: Duration(milliseconds: 200),
              //opacity: _isHideDel? 1:0,
              offstage: _isHideDel,
              child: Container(
                alignment: Alignment.center,
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
                child: InkWell(
                  child: Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: _sizeAnimation.value-2,
                      )
                  ),
                  onTap: (){
                    setState(() {
                      BillType t = billTypes.elementAt(index);
                      BillTypeService().unSelect(t.id);
                      billTypes.removeAt(index);
                    });
                  },
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(18.0),
                  ),
                ),
              ),
            )
        )
      ],
    );
  }



  Widget _buildIcon(BillType element){
    return Center(
      child: Material(
        child: Ink(
          decoration: BoxDecoration(
            borderRadius:BorderRadius.circular(60) ,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                shape: HoleShapeBorder(
                  size: 100
                ),
                context: context,
                builder: (BuildContext context) {
                  return  AddKeyBord(
                    name:element,
                    controller: TextEditingController(),
                    onSubmit: _onSubmit,
                  );
                },
              );
            },
            onLongPress: (){

              setState(() {
                if(_isHideDel){
                  billTypes.add(BillType());
                  _animationController.forward();
                }else{
                  billTypes.removeAt(billTypes.length - 1);
                  _animationController.reset();
                }
                _isHideDel = !_isHideDel;
                print(_isHideDel);
              });
            },
            child:Container(
              width: 70,
              height: 70,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(tag:element.icon,
                        child: Icon(BillIcons.all[element.icon],
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        )),
                    Text(element.type,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14
                      ),
                    )
                  ]
              ),

            ),
            borderRadius:BorderRadius.circular(70) ,
            radius: 70.0,
          ),
        ),
      ),
    );
  }
}

class HoleShapeBorder extends ShapeBorder{

  final double size;

  HoleShapeBorder({this.size=20});

  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    var path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(5)));
    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    var path = Path();
    double y = rect.top;
    var w = rect.width;
    var r = this.size / 2;
    path.addRect(Rect.fromLTRB(rect.left, y + r, w, rect.height));
    path.addOval(Rect.fromLTRB(w / 2 - r, y , w / 2 + r, y + this.size));
    return path;
  }


  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
  }

  @override
  ShapeBorder scale(double t) {
    return null;
  }
}
