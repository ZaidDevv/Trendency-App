import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';

class TrendencyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color color;
  final String? title;
  const TrendencyAppBar(
      {Key? key, required this.height, required this.color, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      elevation: 0,
      backgroundColor: color,
      leading: IconButton(
          onPressed: () => Routemaster.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColor.secondaryColor,
          )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
