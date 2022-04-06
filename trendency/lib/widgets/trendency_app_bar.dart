import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';

class TrendencyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double? height;

  const TrendencyAppBar({
    Key? key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColor.primary,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      elevation: 0,
      backgroundColor: AppColor.primary,
      leading: IconButton(
          onPressed: () => Routemaster.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColor.secondaryColor,
          )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height!);
}
