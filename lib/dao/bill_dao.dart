import 'package:bill/db/db_provider.dart';
import 'package:common_utils/common_utils.dart';
import 'package:sqflite_common/sqlite_api.dart';

final String _tableName = "bill";

final String ColumnId = "_id";
final String ColumnType = "type";
final String ColumnIcon = "icon";
final String ColumnRemark = "remark";
final String ColumnTime = "time";
final String ColumnMoney = "money";

final List<String> Columns = [ColumnId,ColumnType, ColumnIcon, ColumnRemark, ColumnTime, ColumnMoney];

class Bill{
  num id;
  String type;
  String icon;
  String remark;
  DateTime time;
  num money;

  Bill({this.id, this.type, this.icon, this.remark, this.time, this.money});

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
        id: json['id'],
        type: json['type'],
        icon: json['icon'],
        remark: json['remark'],
        time: DateTime.parse(json['time']),
        money: double.parse(json['money'])
    );
  }

  Bill.fromMap(Map<String, dynamic> map){
    id = map[ColumnId];
    type = map[ColumnType];
    icon = map[ColumnIcon];
    remark = map[ColumnRemark];
    time = DateTime.fromMillisecondsSinceEpoch(map[ColumnTime]);
    money = map[ColumnMoney];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      ColumnType: type,
      ColumnIcon: icon,
      ColumnRemark:remark,
      ColumnTime: time.millisecondsSinceEpoch,
      ColumnMoney: money
    };
    if (id != null) {
      map[ColumnId] = id;
    }
    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'type:$type, time:$time, money:$money;\n';
  }
}

class BillDao extends BaseDBProvider{

  Future<bool> insert(Bill bill) async {
    Database db = await getDataBase();
    bill.id = await db.insert(_tableName, bill.toMap());
    return true;
  }

  Future<List<Bill>> selectByPage({page:1, size:10, DateTime month}) async {
    Database db = await getDataBase();
    int startTime, endTime;
    
    if(month != null){
      startTime = DateTime(month.year,month.month,1).millisecondsSinceEpoch;
      int lastMDays = MONTH_DAY[month.month == 0? 12 : month.month];
      lastMDays = DateUtil.isLeapYearByYear(month.year) && month.month == 2?  lastMDays+ 1: lastMDays;
      endTime = DateTime(month.year,month.month,lastMDays).millisecondsSinceEpoch;
    }
    int limit = (page - 1 ) * size;
    
    String whereParam = " 1 = 1 ";
    if(startTime != null){
      whereParam += "and time >= $startTime";
    }
    if(endTime != null){
      whereParam += "and time <= $endTime";
    }
    
    List<Map> maps = await db.query(_tableName,
        columns: Columns,
        where: whereParam,
        limit: limit,
        offset: size,);
    return maps.map((e) => Bill.fromMap(e)).toList();
  }

  Future<List<Bill>> getBillByDate(int startTime, int endTime) async {
    assert(startTime != null);
    assert(endTime != null);
    Database db = await getDataBase();
    List<Map> maps = await db.query(_tableName,
      columns: Columns,
      where: "time >= ? and time <= ?",
      whereArgs: [startTime, endTime]);
    return maps.map((e) => Bill.fromMap(e)).toList();
  }

  Future<bool> delBill(num id) async {
    Database db = await getDataBase();
    await db.delete(_tableName, where: "$ColumnId = ?", whereArgs: [id]);
    return true;
  }

  Future<Map<String, DateTime>> getMinMaxTime() async {
    Database db = await getDataBase();
    DateTime minTime,maxTime;
    List<Map<String, dynamic>> minMaps = await db.rawQuery("select MIN(time) as minTime from $_tableName");
    List<Map<String, dynamic>> maxMaps = await db.rawQuery("select MAX(time) as maxTime from $_tableName");
    minTime = DateTime.fromMillisecondsSinceEpoch(minMaps[0]["minTime"]);
    maxTime = DateTime.fromMillisecondsSinceEpoch(maxMaps[0]["maxTime"]);
    return {'minTime': minTime, 'maxTime': maxTime};
  }

  @override
  Future<void> init(Database db) {

  }

  @override
  tableName() {
    return _tableName;
  }

  @override
  tableSqlString() {
    return tableBaseString(_tableName, ColumnId) +
        '''
    $ColumnType text,
    $ColumnIcon text,
    $ColumnRemark text,
    $ColumnTime integer,
    $ColumnMoney NUMERIC
          )
    ''';
  }

}
