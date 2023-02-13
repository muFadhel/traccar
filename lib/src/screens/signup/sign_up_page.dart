import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mfadhel/src/constants/custom_colors.dart';
import 'package:mfadhel/src/models/sign_up_model.dart';
import 'package:mfadhel/src/providers/sign_up_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/navigation.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_message.dart';
import '../../widgets/custom_widgets.dart';

late SignUpProvider provider;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  /// form controller
  final signUpFormKey = GlobalKey<FormState>();

  /// terms and conditions
  bool checked = false;

  /// inputs config
  bool passwordVisible = false;
  bool repeatPasswordVisible = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  /// password input icon
  void setPasswordVisible() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  /// password input icon
  void setRepeatPasswordVisible() {
    setState(() {
      repeatPasswordVisible = !repeatPasswordVisible;
    });
  }

  /// rounded button
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  /// submit
  void submit(RoundedLoadingButtonController controller) async {
    if (signUpFormKey.currentState!.validate()) {
      /// sign up provider
      SignUpModel signUpModel = SignUpModel(
          name: usernameController.text,
          email: usernameController.text,
          phone: phoneController.text,
          password: passwordController.text);
      provider = Provider.of<SignUpProvider>(context, listen: false);
      await provider.postData(signUpModel);
      var data = provider.data;
      print(data);

      /// if there is an error
      if (data['error'] != null) {
        _btnController.error();
        Timer(const Duration(milliseconds: 800), () {
          _btnController.reset();
        });
        if (!mounted) return;
        CustomMessage.snackMessage(data['message'], "error", context);
      } else {
        /// hide keyboard
        FocusManager.instance.primaryFocus?.unfocus();

        _btnController.success();

        Timer(const Duration(milliseconds: 800), () {
          CustomNavigation.navigateTo("/sign_in");
        });
        if (!mounted) return;
        CustomMessage.snackMessage(
            "You have successfully registered", "success", context);
      }
    } else {
      _btnController.error();
      CustomMessage.snackMessage(
          "please verify the data entered and try again", "error", context);
      Timer(const Duration(seconds: 1), () {
        _btnController.reset();
      });
    }
  }

  /// reset inputs
  void resetInputs() {
    usernameController.clear();
    phoneController.clear();
    passwordController.clear();
    repeatPasswordController.clear();
  }

  @override
  void dispose() {
    usernameController.clear();
    phoneController.clear();
    passwordController.clear();
    repeatPasswordController.clear();
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(context, "Create Account", true),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// hi section message
                    CustomWidgets.hiSection("Welcome",
                        'simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry.'),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Form(
                        key: signUpFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// username input
                            CustomWidgets.inputTitle("Username"),
                            TextFormField(
                              controller: usernameController,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp('[ ]'))
                              ],
                              decoration: CustomWidgets.inputStyle(
                                  "Type your username"),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),

                            /// phone input
                            CustomWidgets.inputTitle("Phone Number"),
                            IntlPhoneField(
                              controller: phoneController,
                              flagsButtonPadding:
                                  const EdgeInsets.only(left: 10),
                              dropdownIcon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 20.0,
                              ),
                              decoration:
                                  CustomWidgets.inputStyle("Type your phone"),
                              initialCountryCode: 'SA',
                              dropdownIconPosition: IconPosition.trailing,
                              showCountryFlag: false,
                              onChanged: (phone) {
                                debugPrint(phone.completeNumber);
                              },
                              onCountryChanged: (country) {
                                debugPrint(
                                    'Country changed to: ${country.name}');
                              },
                            ),

                            /// password input
                            CustomWidgets.inputTitle("Password"),
                            TextFormField(
                              controller: passwordController,
                              obscureText: !passwordVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: CustomWidgets.passwordInputStyle(
                                  "Enter your password",
                                  passwordVisible,
                                  context,
                                  setPasswordVisible),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                RegExp regex = RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                } else if (passwordController.value !=
                                    repeatPasswordController.value) {
                                  return 'Your passwords do not match';
                                } else if (!regex.hasMatch(value)) {
                                  return 'Password must be at least 8 characters and should contain at least one uppercase, one lowercase, one digit and one special character.';
                                } else {
                                  return null;
                                }
                              },
                            ),

                            /// repeat password input
                            CustomWidgets.inputTitle("Repeat Password"),
                            TextFormField(
                              controller: repeatPasswordController,
                              obscureText: !repeatPasswordVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: CustomWidgets.passwordInputStyle(
                                  "Repeat your password",
                                  repeatPasswordVisible,
                                  context,
                                  setRepeatPasswordVisible),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                RegExp regex = RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                } else if (passwordController.value !=
                                    repeatPasswordController.value) {
                                  return 'Your passwords do not match';
                                } else if (!regex.hasMatch(value)) {
                                  return 'Password must be at least 8 characters and should contain at least one uppercase, one lowercase, one digit and one special character.';
                                } else {
                                  return null;
                                }
                              },
                            ),

                            /// checkbox
                            Row(
                              children: [
                                SizedBox(
                                  height: 60.0,
                                  width: 24.0,
                                  child: Checkbox(
                                      activeColor: CustomColors.mainColor,
                                      hoverColor: CustomColors.mainColor,
                                      value: checked,
                                      onChanged: (value) {
                                        setState(() {
                                          checked = value!;
                                        });
                                        debugPrint(value.toString());
                                      }),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text('Agree the Terms & Conditions')
                              ],
                            ),

                            /// submit button
                            RoundedLoadingButton(
                              width: MediaQuery.of(context).size.width,
                              color: CustomColors.mainColor,
                              successColor: Colors.green,
                              controller: _btnController,
                              onPressed: () => submit(_btnController),
                              valueColor: Colors.white,
                              borderRadius: 8,
                              child: const Text('Register',
                                  style: TextStyle(color: Colors.white)),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            /// navigator to other auth page text
                            CustomWidgets.otherAuthPageText(
                                "Have an account ? please",
                                "Sign In",
                                "/sign_in"),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
