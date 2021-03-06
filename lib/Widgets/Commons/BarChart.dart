import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_pedometer/Constants/Colors.dart' as CustomColors;
import 'package:flutter_pedometer/Constants/Fonts.dart' as Fonts;
import 'package:flutter_pedometer/Utils/Colors.dart';
import 'package:flutter_pedometer/Models/ChartItem.dart';

class BarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final List<charts.TickSpec<String>> ticksList;
  final bool renderPrimaryAxis;
  final int labelOffsetFromAxisPx;
  BarChart._(this.seriesList, this.ticksList, this.renderPrimaryAxis,
      this.labelOffsetFromAxisPx);

  factory BarChart(
      {@required List<ChartItem> chartItems,
      @required String seriesId,
      bool renderPrimaryAxis = false,
      int labelOffsetFromAxisPx = 10}) {
    return new BarChart._(
        transmforToSeriesList(list: chartItems, seriesId: seriesId),
        transformToTickSpeckList(list: chartItems),
        renderPrimaryAxis,
        labelOffsetFromAxisPx);
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: true,
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec:
            new charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
        renderSpec: this.renderPrimaryAxis
            ? charts.GridlineRendererSpec(
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 12,
                    color: colorToChartColor(CustomColors.white),
                    fontFamily: Fonts.mainFont),
                lineStyle: new charts.LineStyleSpec(
                    thickness: 1, color: colorToChartColor(CustomColors.white)),
              )
            : new charts.NoneRenderSpec(),
      ),
      domainAxis: new charts.OrdinalAxisSpec(
        showAxisLine: true,
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
              fontSize: 12,
              color: colorToChartColor(CustomColors.white),
              fontFamily: Fonts.mainFont),
          lineStyle: new charts.LineStyleSpec(
              thickness: 2, color: colorToChartColor(CustomColors.white)),
          labelOffsetFromAxisPx: this.labelOffsetFromAxisPx,
          tickLengthPx: 0,
        ),
        tickProviderSpec: new charts.StaticOrdinalTickProviderSpec(ticksList),
      ),
    );
  }
}

List<charts.Series<ChartItem, String>> transmforToSeriesList(
    {@required List<ChartItem> list, @required String seriesId}) {
  return [
    new charts.Series<ChartItem, String>(
      fillColorFn: (ChartItem item, __) => colorToChartColor(
          item.color != null ? item.color : CustomColors.completeColor),
      id: seriesId,
      domainFn: (ChartItem item, _) => item.id,
      measureFn: (ChartItem item, _) => item.amount,
      data: list,
    ),
  ];
}

List<charts.TickSpec<String>> transformToTickSpeckList(
    {@required List<ChartItem> list}) {
  List<charts.TickSpec<String>> tickSpecList = [];
  list.forEach((item) {
    if (item.labelName != null) {
      tickSpecList.add(new charts.TickSpec(
        item.id,
        label: item.labelName,
      ));
    }
  });
  return tickSpecList;
}
