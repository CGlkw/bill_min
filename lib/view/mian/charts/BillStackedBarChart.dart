/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StackedBarChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedBarChart(this.seriesList, {this.animate});

  @override
  StackedBarChartState createState() => StackedBarChartState();
  
  
}

class StackedBarChartState extends State<StackedBarChart> {
  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      widget.seriesList,
      animate: widget.animate,
      barGroupingType: charts.BarGroupingType.stacked,
    );
  }
}