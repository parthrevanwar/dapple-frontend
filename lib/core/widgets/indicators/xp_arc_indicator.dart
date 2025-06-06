import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../theme/app_palette.dart';
import '../text/custom_text_rubik.dart';

class XpArcIndicator extends StatelessWidget {
  const XpArcIndicator({super.key, required this.progress, required this.max, required this.color});
  final int progress;
  final int max;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextRubik(
                  text: 'XP GAINED',
                  weight: FontWeight.w400,
                  size: 12,
                  color: AppPalette.blackColor),
              CustomTextRubik(
                  text: "$progress",
                  weight: FontWeight.w800,
                  size: 24,
                  color: AppPalette.blackColor),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          width: double.infinity,
          child: SfRadialGauge(axes: <RadialAxis>[
            RadialAxis(
              radiusFactor: 0.80,
              minimum: 0,
              maximum: 100,
              showLabels: false,
              showTicks: false,
              axisLineStyle: AxisLineStyle(
                thickness: 2,
                cornerStyle: CornerStyle.bothCurve,
                color: Color(0x55CCCCCC),
              ),
            ),
            RadialAxis(
              radiusFactor: 0.90,
              minimum: 2,
              maximum: 98,
              showLabels: false,
              showTicks: false,
              pointers: <GaugePointer>[
                RangePointer(
                  color: color,
                  value: (progress*100)/max,
                  cornerStyle: CornerStyle.bothCurve,
                  width: 8,
                ),
              ],
              axisLineStyle: AxisLineStyle(
                thickness: 2,
                cornerStyle: CornerStyle.bothCurve,
                color: AppPalette.grey,
              ),
            )
          ]),
        ),
      ],
    );
  }
}
