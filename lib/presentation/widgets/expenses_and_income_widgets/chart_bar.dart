import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:temp/data/repository/helper_class.dart';
import '../../styles/colors.dart';

class ChartBar extends StatefulWidget {
  const ChartBar({
    Key? key,
    required this.height,
    required this.percentage,
    required this.index,
    this.totalExp = 0.0,
  }) : super(key: key);

  final double? height;
  final double totalExp;
  final int index;
  final String percentage;

  @override
  State<ChartBar> createState() => _ChartBarState();
}

class _ChartBarState extends State<ChartBar> with HelperClass {
  double _height = 0;

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration.zero, () => setState(() => _height = widget.height!));
    });
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ChartBar oldWidget) {
    _height = widget.height!;
    super.didUpdateWidget(oldWidget);
  }

  String fixedTotalExp(String total) => translator.activeLanguageCode == 'en'
      ? widget.totalExp.toStringAsFixed(0)
      : engToArabNum(total);

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme.headline6?.copyWith(fontSize: 8.5.dp);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text('${fixedTotalExp(widget.totalExp.toStringAsFixed(0))}%',
                style: textTheme),
          ),
        ),
        Flexible(
          flex: 6,

          /// bar style
          child: AnimatedContainer(
            height: widget.totalExp == 0 ? 0 : _height,
            onEnd: () => _height = widget.height!,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(seconds: 3),
            constraints: BoxConstraints(
                minHeight: 3.h, maxHeight: widget.totalExp == 0 ? 3.h : 30.h),
            child: SizedBox(
              height: (widget.height! >= 10) ? widget.height : 3.h,
              width: 5.w,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(12.dp),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Expanded(
          flex: 2,

          /// weekly or monthly
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Transform(
              transform: Matrix4.rotationZ(-65 * pi / 180),
              child: Text('${widget.percentage} ${weekNum(widget.index + 1)}',
                  style: textTheme),
            ),
          ),
        )
      ],
    );
  }
}
