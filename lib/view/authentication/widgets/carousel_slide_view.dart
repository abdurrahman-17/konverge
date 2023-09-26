import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_style.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/title_string.dart';

class CarouselSlideView extends StatefulWidget {
  final double height;
  final List<Map<String, String>> sliderContent;

  CarouselSlideView({
    super.key,
    this.height = 110,
    required this.sliderContent,
  });

  @override
  State<CarouselSlideView> createState() => _CarouselSlideViewState();
}

class _CarouselSlideViewState extends State<CarouselSlideView> {
  int current = 0;
  CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: controller,
          options: CarouselOptions(
            height: getVerticalSize(widget.height),
            viewportFraction: 1,
            aspectRatio: 2.0,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                current = index;
              });
            },
          ),
          items: widget.sliderContent.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: getPadding(top: 47),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${i['title']}',
                              style: AppStyle.txtPoppinsLightItalic20,
                            ),
                            TextSpan(
                              text: '\n${i['sub_title']}',
                              style: AppStyle.txtPoppinsBoldItalic20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),
        ),
        Container(
          margin: getMargin(top: 21),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: TitleString.sliderContent.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => controller.animateToPage(entry.key),
                child: Container(
                  width: getHorizontalSize(9),
                  height: getHorizontalSize(9),
                  margin: getMarginOrPadding(left: 4, right: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                        .withOpacity(current == entry.key ? 0.9 : 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
