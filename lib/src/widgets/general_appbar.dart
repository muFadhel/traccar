import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/custom_colors.dart';
import '../utils/navigation.dart';

class GeneralAppbar extends StatelessWidget {
  final String appBarTitle;

  const GeneralAppbar({
    Key? key,
    required this.appBarTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RotationTransition(
            turns: const AlwaysStoppedAnimation(90 / 360),
            child: GestureDetector(
              onTap: () {
                CustomNavigation.goBack();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColors.fieldBG,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 15),
                child: SvgPicture.asset(
                  "assets/icons/arrow_down.svg",
                  color: CustomColors.iconColor,
                  width: 14,
                ),
              ),
            )),
         Text(
          appBarTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: CustomColors.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
        Container(),
      ],
    );
  }
}
