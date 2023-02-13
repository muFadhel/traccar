import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mfadhel/src/constants/custom_colors.dart';
import 'package:mfadhel/src/utils/navigation.dart';

class CustomWidgets {
  /// Auth Section
  static Widget hiSection(title, paragraph) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 35, bottom: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              const SizedBox(
                width: 6,
              ),
              SvgPicture.asset(
                'assets/images/hand.svg',
                semanticsLabel: 'Hand Logo',
                width: 25,
              )
            ],
          ),
        ),
        Text(
          paragraph,
          textAlign: TextAlign.center,
          style: const TextStyle(color: CustomColors.paragraphTextColor),
        ),
      ],
    );
  }

  static Widget otherAuthPageText(text, pageName, path) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
              onTap: () {
                CustomNavigation.navigateTo(path);
              },
              child: Text(
                pageName,
                style: const TextStyle(color: Colors.lightBlue),
              )),
        )
      ],
    );
  }

  /// Form Part
  static InputDecoration inputStyle(hint) {
    return InputDecoration(
      counterText: "",
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 15),
    );
  }

  /// Form Part
  static InputDecoration passwordInputStyle(
      hint, visible, context, setVisible) {
    return InputDecoration(
      errorMaxLines: 3,
      counterText: "",
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 15),
      suffixIcon: IconButton(
        icon: Icon(
          // Based on passwordVisible state choose the icon
          visible ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).primaryColorDark,
        ),
        onPressed: () {
          // Update the state i.e. toogle the state of passwordVisible variable
          setVisible();
        },
      ),
    );
  }

  static Widget inputTitle(title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8, top: 20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  static Widget generalButton(title, onPress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.0),
      child: SizedBox(
        width: 190, // <-- match_parent
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            onPress();
          },
          child: Text(
            title,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
