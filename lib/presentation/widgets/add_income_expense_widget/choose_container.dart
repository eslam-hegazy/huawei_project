import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:temp/business_logic/cubit/add_exp_inc/add_exp_or_inc_cubit.dart';

import '../../../constants/app_icons.dart';

class DateChooseContainer extends StatelessWidget {
  const DateChooseContainer({
    Key? key,
    required this.dateTime,
    required this.onTap,
  }) : super(key: key);
  final DateTime? dateTime;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.bodyText2!;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(.2),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: ListTile(
            title: dateTime == null
                ? Text(
                    'Choose Date',
                    style: theme.copyWith(fontWeight: FontWeight.w300, fontSize: 13),
                  )
                : Text(
                    '${dateTime?.day} \\ ${dateTime?.month} \\ ${dateTime?.year}',
                    style: theme.copyWith(fontWeight: FontWeight.w300, fontSize: 13),
                  ),
            leading: SvgPicture.asset(AppIcons.dateIcon),
          ),
        ),
      ),
    );
  }
}
