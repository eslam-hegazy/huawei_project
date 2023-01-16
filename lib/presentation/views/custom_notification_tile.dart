import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../styles/colors.dart';

class CustomNotificationTile extends StatelessWidget {
  const CustomNotificationTile(
      {required this.title,
      this.firstIcon = const Icon(Icons.chat),
      Key? key,
      this.onPressedNotification,
      required this.subTitle,
      required this.dateTime})
      : super(key: key);

  final String title;
  final String subTitle;
  final String dateTime;
  final Widget? firstIcon;
  final VoidCallback? onPressedNotification;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26.h,
      child: InkWell(
        onTap: onPressedNotification,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.sp))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '$dateTime ago',
                    style: Theme.of(context).textTheme.overline,
                    overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColor.white,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: onPressedNotification,
                            icon: firstIcon!,
                            color: Colors.green,
                            iconSize: 36.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text(
                          title ?? '',
                          style: Theme.of(context).textTheme.subtitle1,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Row(
                    children: [
                      const Spacer(flex: 2),
                      Expanded(
                        flex: 8,
                        child: Text(
                          subTitle,
                          style: Theme.of(context).textTheme.overline,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
