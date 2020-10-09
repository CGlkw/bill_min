import 'dart:math';

import 'package:bill/api/BillService.dart';
import 'package:bill/api/module/Bill.dart';
import 'package:bill/common/BillIcon.dart';
import 'package:bill/common/SlideButton.dart';
import 'package:bill/config.dart';
import 'package:bill/dao/bill_dao.dart';
import 'package:bill/utils/SHSectionHeadConfig.dart';
import 'package:bill/view/Pages.dart';
import 'package:bill/view/test/ThemeColors.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

class BillListPage extends Pages{

  List tabs = ['支出','收入'];

  TabController _tabController;

  final TickerProviderStateMixin vsync;

  BillListPage(this.vsync);

  GlobalKey<_BillListState> key = GlobalKey();

  @override
  Pages init() {
    _tabController = TabController(length: tabs.length, vsync: vsync);
    return this;
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context) {
    return AppBar( //导航栏
        title: Text("List"),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColor, Theme.of(context).textSelectionColor],
          ),
        ),
      ),
      );
  }

  @override
  Widget getBody() {
    return BillList(key:key,tabs: tabs, tabController: _tabController,);
  }

  @override
  void flush() {
    key.currentState?.onRefresh();
  }
}

class BillList extends StatefulWidget {

  BillList({Key key, @required this.tabController, @required this.tabs}):super(key:key);

  final TabController tabController;
  final List tabs;

  @override
  _BillListState createState() => _BillListState();
}

class _BillListState extends State<BillList>{
  int _page = 1;

  DateTime _month;

  Map<String, num> _sign= {};

  List<Map> _bills = [];

  EasyRefreshController _controller = EasyRefreshController();
  ScrollController _listScrollC = ScrollController();

  GlobalKey<_HeadBuildState> textKey = GlobalKey();

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return EasyRefresh(
      firstRefresh: true,
      controller: _controller,
      header: MaterialHeader(),
      footer: MaterialFooter(),
      child: ListView.separated(
        controller: _listScrollC,
        itemBuilder: (buildContext, index) {
          return _buildItem(context, index);
        },
        itemCount: _bills.length,
        separatorBuilder: (buildContext, index) {
          return Divider(
            height: 0.5,
            color: Colors.grey,
          );
        },
      ),
      onRefresh: () => onRefresh(),
      onLoad: () => _loadMoreData(),
    );
  }

  // 加载数据
  void _loadData({int page,DateTime month}) {
    BillService().getBillList(page:page,month:month).then((value) => {
      setState(() {
        if(value == null || value.length ==0){
          _controller.finishLoad(success:true,noMore: true);
        }else {
          _controller.finishLoad(success:true,noMore: false);
        }
        value.forEach((element) {
          var date = DateUtil.formatDate(element.time, format: "yyyy-MM");
          if(_sign.containsKey(date)){
            _bills[_sign[date]]["latter"]["money"] += element.money;
            _bills[_sign[date]]["group"].add(element);
          }else {
            List<Bill> b = [] ..add(element);
            var m = {
              "latter" : {
                "date" : date,
                "money": element.money
              },
              "group" : b
            };
            _bills.add(m);
            _sign.putIfAbsent(date, () => _bills.indexOf(m));
          }
        });
        if((value == null || value.length == 0) && _bills.length == 0){
          var m = {
            "latter" : {
              "date" : DateUtil.formatDate(_month ?? DateTime.now(),format: "yyyy-MM"),
              "money": 0
            },
            "group" : null
          };
          _bills.add(m);
        }
      })
    });
  }

  // 下拉刷新
  Future<Null> onRefresh() {
    return Future.delayed(Duration(milliseconds: 0), () {
      _page = 1;
      _bills.clear();
      _sign.clear();
      _loadData(page: _page, month: _month);
      _controller.finishRefresh(success:true,noMore: false);

    });
  }

  // 加载更多
  Future<Null> _loadMoreData() {
    return Future.delayed(Duration(milliseconds: 0), () {
      _page++;
      _loadData(page: _page, month: _month);

    });
  }

  Widget _buildItem(context, index){
    return StickyHeader(
      header: InkWell(
        onTap: (){
          DatePicker.showDatePicker(context,
            maxDateTime: DateTime.now(),
            initialDateTime:DateTime.parse("${_bills[index]["latter"]["date"]}-01"),
            dateFormat:"yyyy-MM",
            locale: DateTimePickerLocale.zh_cn,
            onConfirm: (dateTime,index){
              this._month = dateTime;
              this.onRefresh();
            }
          );
        },
        child: Container(
          height: 50.0,
          color: Theme.of(context).secondaryHeaderColor,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(_bills[index]["latter"]["date"],
                style: const TextStyle(color: ColorConfig.primary_text),
              ),
              Expanded(child: Text(""),),
              Text("支出：${_bills[index]["latter"]["money"]}",
                style: const TextStyle(color: ColorConfig.primary_text),
              ),
            ]
          ),
        ),
      ),
      content:_bills[index]['group'] == null ? Container(
        margin: EdgeInsets.only(top: 50),
        child: Center(
          child: Image.asset(
            "assets/imgs/no_data.png",
            width: 300,
          ),
        ),
      ): Column(
        children: _bills[index]['group'].map<Widget>((e) => items(e) ).toList(),
      )
    );
  }

  // item控件
  Widget items(bill) {
    var key = GlobalKey<SlideButtonState>();

    return SlideButton(
      key: key,
      child: Container(
        color:Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.all(5),
          leading: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius:BorderRadius.circular(60) ,
            ),
            child: Icon(BillIcons.all[bill.icon],
              size: 36,
              color: Theme.of(context).primaryColor,
            ),
          ) ,
          title: Text('${bill.type}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${bill.remark}',style: TextStyle(color: ColorConfig.secondary_text),),
              Text(TimelineUtil.formatByDateTime(bill.time, dayFormat: DayFormat.Common,locale: 'zh'),
                  style: TextStyle(color: ColorConfig.secondary_text)),
            ],
          ),
          trailing: Text('${bill.money}'),

        ),
      ),

      singleButtonWidth: 80,
      buttons: [
          buildAction(key, "编辑", Colors.amber, () {
            key.currentState.close();
          }),
          buildAction(key, "删除", Colors.red, () {
            key.currentState.close();
          }),
      ],
    );


  }

  Widget buildAction(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {

    return Padding(
      padding: EdgeInsets.only(top: 1, bottom: 1),
      child: InkWell(
        onTap: tap,
        child: Container(
          alignment: Alignment.center,
          width: 80,
          color: color,
          child: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
        ),
      )
    );
  }

  String debugLabel(key) {
    String temp = key.toString();
    if (temp.contains(' ')) {
      List list = temp.split(' ');
      String str = list.last;
      return str.split(']').first;
    }
    return '';
  }
}

class HeadBuild extends StatefulWidget{
  SHSectionHeadConfig config;

  HeadBuild(Key key,this.config):super(key:key);

  @override
  State<StatefulWidget> createState() => _HeadBuildState();

}

class _HeadBuildState extends State<HeadBuild> {
  @override
  Widget build(BuildContext context) {
    if (widget.config.currentIndex >= 0) {
      return Positioned(
        top: widget.config.offset,
        child: getHeadView(widget.config.currentIndex, null),
      );
    }

    return Container();
  }

  void reBuild(){
    setState(() {

    });
  }

  Widget getHeadView(int index, Key key) {
    return Container(
      key: key,
      height: 90,
      width: 400,
      color: Colors.cyan,
      alignment: Alignment.center,
      child: Text(
        '我是head === $index',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

}