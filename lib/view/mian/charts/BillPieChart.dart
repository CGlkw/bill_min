import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class  DonutAutoLabelChart extends StatefulWidget{
  final List<charts.Series> seriesList;
  final bool animate;
  DonutAutoLabelChart(this.seriesList, {this.animate});

  @override
  DonutAutoLabelChartState createState() => DonutAutoLabelChartState();
}

class DonutAutoLabelChartState extends State<DonutAutoLabelChart> with AutomaticKeepAliveClientMixin{
  

  @protected
  bool get wantKeepAlive=>true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new charts.PieChart(widget. seriesList,
        animate: widget. animate,
        behaviors: [new charts.DatumLegend(desiredMaxRows:20,desiredMaxColumns: 5)],
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(
            // arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
      new LinearSales(2, 25),
      new LinearSales(3, 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        seriesColor: charts.Color(
          r:Colors.red.red,
          g:Colors.red.green,
          b:Colors.red.blue
        ),
        // colorFn: (LinearSales sales, _) => sales.color,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;
  final charts.Color color = charts.Color(
          r:Colors.red.red,
          g:Colors.red.green,
          b:Colors.red.blue,
          a:Colors.red.alpha
        );


  LinearSales(this.year, this.sales);
}