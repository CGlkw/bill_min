import 'dart:convert';
import 'package:bill/db/db_provider.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common/sqlite_api.dart';


final String _tableName = "bill_type";

final String ColumnId = "_id";
final String ColumnType = "type";
final String ColumnIcon = "icon";
final String ColumnIsSelect = "isSelect";
final String ColumnTime = "time";

final List<String> Columns = [ColumnId,ColumnType, ColumnIcon, ColumnIsSelect , ColumnTime];

class BillType{
  num id;
  String type;
  String icon;
  bool isSelect;
  DateTime time;

  BillType({this.id, this.type, this.icon, this.isSelect, this.time});


  factory BillType.fromJson(Map<String, dynamic> json) {
    return BillType(
      id: json['id'],
      type: json['type'],
      icon: json['icon'],
      isSelect: json['isSelect'],
      time: DateTime.parse(json['time']),
    );
  }

  BillType.fromMap(Map<String, dynamic> map){
    id = map[ColumnId];
    type = map[ColumnType];
    icon = map[ColumnIcon];
    isSelect = map[ColumnIsSelect] == 1;
    time = DateTime.fromMillisecondsSinceEpoch(map[ColumnTime]);
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      ColumnType: type,
      ColumnIcon: icon,
      ColumnIsSelect:isSelect?1:0,
      ColumnTime: time.millisecondsSinceEpoch,
    };
    if (id != null) {
      map[ColumnId] = id;
    }
    return map;
  }

}


// 读取 assets 文件夹中的 person.json 文件s
Future<String> _loadPersonJson() async {
  return await rootBundle.loadString('json_data/billType.json');
}

// 将 json 字符串解析为 Person 对象
Future<List<BillType>> decodeBill() async {

  // 获取本地的 json 字符串
  String personJson = await _loadPersonJson();

  // 解析 json 字符串，返回的是 Map<String, dynamic> 类型
  final jsonList = json.decode(personJson) as List;
  return jsonList.map((e) => BillType.fromJson(e)).toList();

}

class BillTypeDao extends BaseDBProvider{

  Future<BillType> insert(BillType billType) async {
    Database db = await getDataBase();
    billType.id = await db.insert(_tableName, billType.toMap());
    return billType;
  }

  Future<List<BillType>> queryAll() async {
    Database db = await getDataBase();
    List<Map> res = await db.query(_tableName, columns: Columns);
    return res.map((e) => BillType.fromMap(e)).toList();
  }

  Future<List<BillType>> querySelected() async {
    Database db = await getDataBase();
    List<Map> res = await db.query(_tableName,
      columns: Columns,
      where: "$ColumnIsSelect = 1"
    );
    return res.map((e) => BillType.fromMap(e)).toList();
  }

  Future<bool> unSelect(num id) async {
    Database db = await getDataBase();
    db.rawUpdate("update $_tableName set $ColumnIsSelect = ? where id = ?",
        [0, id]
    );
    return true;
  }

  Future<bool> selectAll(List ids) async {
    String sql = "update $_tableName set $ColumnIsSelect = 1 where id in (";
    ids.forEach((element) {
      sql += "$element,";
    });
    sql = sql.substring(0, sql.length - 1);
    sql += ")";
    Database db = await getDataBase();
    db.rawUpdate(sql);
    return true;
  }


  @override
  Future<void> init(Database db) async {
    List<BillType> billTypes = await decodeBill();
    billTypes.forEach((element) {
      this.insert(element);
    });
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
    $ColumnIsSelect integer,
    $ColumnTime integer
          )
    ''';
  }

}
