import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';

class TrendencyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color color;
  final Widget? title;
  final bool isDismissable;
  const TrendencyAppBar(
      {Key? key,
      required this.height,
      required this.isDismissable,
      required this.color,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: color,
        statusBarColor: color,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      title: title,
      elevation: 0,
      backgroundColor: color,
      foregroundColor: color,
      leading: isDismissable
          ? IconButton(
              onPressed: () => Routemaster.of(context).history.back()
                  ? null
                  : Routemaster.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColor.secondaryColor,
              ))
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
