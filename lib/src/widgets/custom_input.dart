import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/custom_colors.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController inputController;
  final int maxLength;
  final TextInputType keyboardType;
  final List<TextInputFormatter> listTextFormatter;
  final String iconPath;
  final String hint;
  final String? Function(String?)? validator;

  const CustomInput({
    Key? key,
    required this.inputController,
    required this.maxLength,
    required this.keyboardType,
    required this.listTextFormatter,
    required this.iconPath,
    required this.hint,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: inputController,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: listTextFormatter,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        prefixIcon: SvgPicture.asset(iconPath,
            color: CustomColors.fieldHintBG, fit: BoxFit.scaleDown),
        filled: true,
        fillColor: CustomColors.fieldBG,
        hintStyle:
            const TextStyle(color: CustomColors.fieldHintBG, fontSize: 15),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        border: InputBorder.none,
        // errorText: validatorError,

        counterText: "",
        hintText: hint,
      ),
      // validator: validator,
      validator: validator,
    );
  }
}
