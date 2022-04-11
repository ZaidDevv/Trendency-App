import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:trendency/consts/app_colors.dart';

class TrendencySnackbar {
  TrendencySnackbar._();

  static show({title, content, isError}) {
    Get.snackbar(title, content,
        duration: const Duration(milliseconds: 3000),
        icon: Icon(
          isError
              ? FontAwesomeIcons.exclamationTriangle
              : FontAwesomeIcons.checkCircle,
          color: AppColor.primary,
        ),
        messageText: Text(
          content,
          style: TextStyle(fontSize: 14, color: AppColor.primary),
        ),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP,
        shouldIconPulse: isError,
        colorText: AppColor.primary,
        backgroundColor: isError
            ? AppColor.failureColor.withOpacity(.75)
            : AppColor.successColor.withOpacity(.75));
  }
}
