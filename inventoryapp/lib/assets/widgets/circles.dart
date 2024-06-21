import 'package:flutter/cupertino.dart';

class Circle extends StatelessWidget{
  final double circleSize;
  final Color circleColor;
  final double circleLeftMargin;
  final double circleTopMargin;
  final double circleRightMargin;
  final double circleBottomMargin;

  Circle({
    required this.circleSize,
    required this.circleColor,
    required this.circleLeftMargin,
    required this.circleTopMargin,
    required this.circleRightMargin,
    required this.circleBottomMargin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSize,
      height: circleSize,
      margin: EdgeInsets.only(left: circleLeftMargin,top: circleTopMargin,right: circleRightMargin,bottom: circleBottomMargin),
      decoration: BoxDecoration(
        color: circleColor,
        border: Border.all(),
        borderRadius: BorderRadius.circular(circleSize/2)
      ),
    );
  }
}