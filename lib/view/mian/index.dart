import 'package:bill/api/BillService.dart';
import 'package:bill/api/module/Bill.dart';
import 'package:bill/config.dart';
import 'package:bill/utils/DateUtils.dart';
import 'package:bill/view/mian/charts/BillLineChart.dart';
import 'package:bill/view/test/AnimateNumber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bill/view/Pages.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'charts/BillPieChart.dart';
import 'charts/BillStackedBarChart.dart';
 
class MainPage extends Pages {

  List tabs = ["周", "月", "年"];

  TabController _tabController;

  final TickerProviderStateMixin vsync;

  MainPage(this.vsync);

  Main page;

  GlobalKey<_MainState> key = GlobalKey();

  @override
  Pages init() {
    _tabController = TabController(length: tabs.length, vsync: vsync);
    return this;
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context) {
    return AppBar( //导航栏
        title: Text("BILL"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColor, Theme.of(context).textSelectionColor],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight : 4,
          // indicatorSize:TabBarIndicatorSize.label,
          tabs: tabs.map((e) => Tab(text: e)).toList()
        ),
      );
  }

  @override
  Widget getBody() {
    page = Main(key:key,tabController:_tabController, tabs: tabs,);
    return page;
  }

  @override
  void flush() {
    key.currentState?.init();
  }

}

class Main extends StatefulWidget {


  Main({Key key, @required this.tabController, @required this.tabs }):super(key:key);

  final TabController tabController;
  final List tabs;

  @override
  _MainState createState() => _MainState();

}

class _MainState extends State<Main> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin{


  List<BillChartDate> tabs;
  List<TabController> _tabControllers;
  int _firstIndex = 0;
  int _secondIndex = 0;

  List<List<BillChartDate>> tabs2 = [[BillChartDate('本周',null,null)],
  [BillChartDate('本月',null,null)],
  [BillChartDate('今年',null,null)]];

  List<Map<int,Widget>> pieCharts = [{},{},{}];
  List<Map<int,Widget>> stackCharts = [{},{},{}];
  Map<String, Widget> noCharts = {};
  Map<String, num> totalMoney = {};
  @protected
  bool get wantKeepAlive=>false;

  // 刷新
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {

      return true;
    });
  }

  @override
  void initState() {
    this.init();
    super.initState();
  }

  void init(){
    showRefreshLoading();
    BillService().getMinMaxTime().then((value) => {

      setState(() {
        DateTime minTime = value['minTime'];
        DateTime maxTime = value['maxTime'];
        if(minTime == null || maxTime == null){
          minTime = DateTime.now();
          maxTime = DateTime.now();
        }
        tabs2[0]= BillService().getWeekChartDate(value['minTime'],value['maxTime']);
        tabs2[1]= BillService().getMonthChartDate(value['minTime'],value['maxTime']);
        tabs2[2]= BillService().getYearChartDate(value['minTime'],value['maxTime']);
        _tabControllers = new List()
          ..add(TabController(length: tabs2[0].length, vsync: this))
          ..add(TabController(length: tabs2[1].length, vsync: this))
          ..add(TabController(length: tabs2[2].length, vsync: this));
        pieCharts = [{},{},{}];
        stackCharts = [{},{},{}];
        noCharts = {};
        _createSampleData();

      })
    });
    widget.tabController.addListener((){
      if (mounted) {
        setState(() {
          _firstIndex = widget.tabController.index;
          _secondIndex = _tabControllers[_firstIndex].index;
        });
      }

      _createSampleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TabBarView(
        controller: widget.tabController,
        children: widget.tabs.asMap().keys.map((e1) { //创建3个Tab页
          if(_tabControllers == null ){
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          }
          _tabControllers[e1].addListener(() {
            setState(() {
            _secondIndex = _tabControllers[e1].index;
            });
            _createSampleData();
          });
          return Column(
            children:[
              TabBar(
                controller: _tabControllers[e1],
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                indicatorSize:TabBarIndicatorSize.label,
                tabs: tabs2[e1].map((e) => Tab(
                  text: e.name,
                )).toList()
              ),
              
              Expanded(
                child: TabBarView(
                controller: _tabControllers[e1],
                children: 
                  tabs2[e1].asMap().keys.map((e2) {
                    return Container(
                      alignment: Alignment.topCenter,
                      width: double.infinity,
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16.0),              
                          child: pieCharts[e1][e2] == null
                              || totalMoney["$_firstIndex-$_secondIndex"] == null
                              || stackCharts[e1][e2] == null
                          ? Center(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          ) :

                          noCharts["$e1" + "$e2"]  ?? Column(
                            children: [
                              totalMoney["$_firstIndex-$_secondIndex"] == null ? Container() :Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  padding: EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20),
                                  child: Row(
                                    children: [
                                      Text("总消费",
                                        style: TextStyle(
                                          color: ColorConfig.primary_text,
                                          fontSize: 20
                                        ),
                                      ),
                                      Expanded(child: Text(""),),
                                      AnimateNumber(
                                          num: "${(totalMoney["$_firstIndex-$_secondIndex"]??0).toStringAsFixed(2)}",
                                          fontSize: 30
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20,bottom: 20),
                                child: Divider(
                                  height: 0.5,
                                  color: Colors.grey,
                                  ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 300.0,
                                child: pieCharts[e1][e2] ?? Center(
                                  child: Container(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              ),
                              Container(
                                width: double.infinity,
                                height: 300.0,
                                child: stackCharts[e1][e2] ?? Center(
                                  child: Container(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              )
                            ]
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),  
            ]
          );        
        }).toList(),
      );  
  }

  void _createSampleData() {
    if(pieCharts.length > 0 
        && pieCharts[_firstIndex] !=null 
        && pieCharts[_firstIndex].length > 0
        && pieCharts[_firstIndex][_secondIndex] != null){
          return;
    }
    _reFreshChartDate();
  }

  _reFreshChartDate(){
    BillChartDate billChartDate = tabs2[_firstIndex][_secondIndex];

    BillService().getBillByDate(billChartDate.startTime, billChartDate.endTime).then((value) => {
      if(value != null && value.length > 0){
        _createPieChartData(value),
        _createStackChartData(value,billChartDate)
      }else{
        noCharts["$_firstIndex" + "$_secondIndex"]= Container(
          margin: EdgeInsets.only(top: 50),
          child: Center(
            child: Image.asset(
              "assets/imgs/no_data.png",
              width: 300,
            ),
          ),
        ),
      }
    });
  }
  _createStackChartData(value,BillChartDate billChartDate){
      Map<DateTime, num> map = {};
      List<DateTime> date = [];
      num total = 0;
      int i = 0;
      if(_firstIndex == 0 || _firstIndex == 1){
        DateTime startTime = DateTime(billChartDate.startTime.year, billChartDate.startTime.month,billChartDate.startTime.day);
        DateTime endTime = DateTime(billChartDate.endTime.year, billChartDate.endTime.month,billChartDate.endTime.day);
        while(!startTime.isAfter(endTime)){
          date.add(startTime);
          startTime = startTime.add(Duration(days: 1));
        }
        value.forEach((element) {
          DateTime t = DateTime(element.time.year,element.time.month,element.time.day);
          if(map.containsKey(t)){
            map[t] += element.money;
          }else{
            map[t] = element.money;
          }
        });
      }else{
        DateTime startTime = DateTime(billChartDate.startTime.year, billChartDate.startTime.month);
        DateTime endTime = DateTime(billChartDate.endTime.year, billChartDate.endTime.month);
        while(!startTime.isAfter(endTime) ){
          date.add(startTime);
          startTime = DateTime(startTime.year, startTime.month + 1);
        }
        value.forEach((element) {
          DateTime t = DateTime(element.time.year,element.time.month);
          if(map.containsKey(t)){
            map[t] += element.money;
          }else{
            map[t] = element.money;
          }
        });
      }


      List<TimeSeriesSales> list =[];

      date.forEach((element) {
        total += map[element] ?? 0;
        list.add(TimeSeriesSales(element, map[element] ?? 0));
      });
      Color c = Theme.of(context).primaryColor;
      var  _seriesList =[
      new charts.Series<TimeSeriesSales, DateTime>(
        id: "key",
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        colorFn: (TimeSeriesSales sales, _) =>  charts.Color(
            r:c.red,
            g:c.green,
            b:c.blue,
        ),
        data: list,
      ),
      ];
    setState(() {
      var stackChart = BillLineChart(_seriesList,animate:true);
      stackCharts[_firstIndex][_secondIndex] = stackChart;
      totalMoney["$_firstIndex-$_secondIndex"] = total;
    });
  }
  _createPieChartData(value){
    Map<String, double> map = new Map();
    List<PieBillDate> data = [];
    Color c=  Theme.of(context).primaryColor;
    int i = 0;
    value.forEach((element) {
      if(map.containsKey(element.type)){
        map[element.type] += element.money;
      }else{
        map[element.type] = element.money;
      }
    });
    
    map.forEach((key, value) {
      data.add(PieBillDate(key, value, 
        charts.Color(
            r:c.red,
            g:c.green,
            b:c.blue,
            a:int.parse(((map.length - i) /map.length * 255).toStringAsFixed(0))
          )
      ));
      i++;
    });
    setState(() {
      var  _seriesList =  [new charts.Series<PieBillDate, String>(
        id: 'Sales',
        domainFn: (PieBillDate sales, _) => sales.type,
        measureFn: (PieBillDate sales, _) =>sales.money ,
        colorFn: (PieBillDate sales, _) => sales.color,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (PieBillDate row, _) => '${row.money.toStringAsFixed(2)}',
      )];
      var pieChart = DonutAutoLabelChart(_seriesList,animate:true);
      pieCharts[_firstIndex][_secondIndex] = pieChart;
    });
  }

  Future<Null> _refresh() async {
    this.init();
    return;
  }

  Future<Null> _onChanged(value) async {
    print(value);
    return;
  }

}

class PieBillDate {
  final String type;
  final double money;
  final charts.Color color;

  PieBillDate(this.type, this.money, this.color);
}

class TimeSeriesSales {
  final DateTime time;
  final num sales;

  TimeSeriesSales(this.time, this.sales);
}