
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class BillLineChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  BillLineChart(this.seriesList, {this.animate});

  @override
  BillLineChartState createState() => BillLineChartState();


}

class BillLineChartState extends State<BillLineChart> {
  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(widget.seriesList,
        animate: widget.animate,
        dateTimeFactory: LocalDateTimeFactory(),
        defaultRenderer:
        charts.LineRendererConfig(
          // 圆点大小
          radiusPx: 5.0,
          stacked: false,
          // 线的宽度
          strokeWidthPx: 2.0,
          // 是否显示线
          includeLine: true,
          // 是否显示圆点
          includePoints: true,
          // 是否显示包含区域
          includeArea: true,
          // 区域颜色透明度 0.0-1.0
          areaOpacity: 0.2 ,
        ));
  }
}

/// A local time [DateTimeFactory].
class LocalDateTimeFactory implements DateTimeFactory {
  const LocalDateTimeFactory();

  DateTime createDateTimeFromMilliSecondsSinceEpoch(
      int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  DateTime createDateTime(int year,
      [int month = 1,
        int day = 1,
        int hour = 0,
        int minute = 0,
        int second = 0,
        int millisecond = 0,
        int microsecond = 0]) {
    return DateTime(
        year, month, day, hour, minute, second, millisecond, microsecond);
  }

  /// Returns a [DateFormat].
  DateFormat createDateFormat(String pattern) {
    DateFormat d = DateFormat(pattern,'zh');
    return  d;
  }
}