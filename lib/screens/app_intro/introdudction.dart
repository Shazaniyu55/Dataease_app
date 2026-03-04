import 'package:flutter/material.dart';
import 'package:dataapp/constant/colors.dart';

class Introduction extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subTitle;
  final double? imageWidth;
  final double? imageHeight;
  final TextStyle titleTextStyle;
  final TextStyle subTitleTextStyle;

  const Introduction({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    this.titleTextStyle = const TextStyle(fontSize: 30),
    this.subTitleTextStyle = const TextStyle(fontSize: 20),
    this.imageWidth = 360,
    this.imageHeight = 360,
  });

  

  @override
  State<StatefulWidget> createState() {
    return IntroductionState();
  }
}

class IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          
          Expanded(
  child: Center(
    child: Builder(
      builder: (context) {

        double screenWidth = MediaQuery.of(context).size.width;

        double imageSize = screenWidth * 0.7;
        imageSize = imageSize.clamp(180, 350);

        return Image.asset(
          widget.imageUrl,
          height: imageSize,
          width: imageSize,
          fit: BoxFit.contain,
        );
      },
    ),
  ),
),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style:  TextStyle(
                    fontFamily: "sfpro",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 26.0,
                    letterSpacing: 0.36,
                    color: primaryColor.value),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            widget.subTitle,
            style:  TextStyle(
                fontSize: 16, fontFamily: "sfpro", color: primaryColor.value),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
