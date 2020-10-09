

class BillChartDate{
  String name;
  DateTime startTime;
  DateTime endTime;

  BillChartDate(this.name, this.startTime, this.endTime);

  @override
  String toString() {
    return 'name:$name, startTime:$startTime, endTime:$endTime;\n';
  }
}