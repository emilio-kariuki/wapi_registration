import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';

class LottieBox extends StatelessWidget {
  final String assetUrl;
  const LottieBox({Key? key, required this.assetUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.04,
        width: size.width * 0.04,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Lottie.asset(
          assetUrl,
        ));
  }
}
