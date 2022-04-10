import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trendency/consts/app_colors.dart';

class InstagramIcon extends StatelessWidget {
  const InstagramIcon({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Color(0xFFFEDA75),
          Color(0xFFfa7e1e),
          Color(0xFFd62976),
          Color(0xFF962fbf),
          Color(0xFF4f5bd5)
        ],
      ).createShader(bounds),
      child: Icon(
        FontAwesomeIcons.instagram,
        color: AppColor.primary,
        size: size,
      ),
    );
  }
}
