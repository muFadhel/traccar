import 'dart:async';
import 'dart:convert';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mfadhel/src/constants/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../constants/perferences.dart';
import '../../models/create_device_model.dart';
import '../../models/sign_in_model.dart';
import '../../providers/create_device_provider.dart';
import '../../providers/sign_in_provider.dart';
import '../../utils/navigation.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_message.dart';
import '../../widgets/custom_widgets.dart';

late CreateDeviceProvider createDeviceProvider;
late SignInProvider provider;

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /// device info
  late String deviceName;
  late String deviceId;

  /// form controller
  final signInFormKey = GlobalKey<FormState>();

  /// terms and conditions
  bool checked = false;

  /// inputs config
  bool passwordVisible = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    /// get device Name
    _getDeviceName().then((androidDeviceName) => {
          setState(() {
            deviceName = androidDeviceName!;
          })
        });

    /// get device id
    _getDeviceId().then((androidDeviceId) => {
          setState(() {
            deviceId = androidDeviceId!;
          })
        });
    super.initState();
  }

  Future<String?> _getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model;
  }

  Future<String?> _getDeviceId() async {
    const androidIdPlugin = AndroidId();

    return await androidIdPlugin.getId();
  }

  /// password input icon
  void setPasswordVisible() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  /// rounded button
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  /// create device to Traccar
  createDevice(userToken) async {
    print(userToken);
    /// create device
    CreateDeviceModel createDeviceModel = CreateDeviceModel(
        deviceName: deviceName, deviceId: deviceId, token: userToken);
    createDeviceProvider =
        Provider.of<CreateDeviceProvider>(context, listen: false);
    await createDeviceProvider.postData(createDeviceModel);

    var deviceData = createDeviceProvider.data;

    print(deviceData);

    if (deviceData['error'] != null) {
      Timer(const Duration(milliseconds: 800), () {
        CustomNavigation.navigateTo("/home");
      });

      if (!mounted) return;
      CustomMessage.snackMessage(
          "You have successfully logged in", "success", context);
    } else {
      CustomNavigation.navigateTo("/home");
      if (!mounted) return;
      CustomMessage.snackMessage(
          "You have successfully logged in", "success", context);
    }
  }

  /// submit
  void submit(RoundedLoadingButtonController controller) async {
    if (signInFormKey.currentState!.validate()) {
      /// sign in provider
      SignInModel signInModel = SignInModel(
        username: usernameController.text,
        password: passwordController.text,
      );
      provider = Provider.of<SignInProvider>(context, listen: false);
      await provider.postData(signInModel);
      var data = provider.data;

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

        /// generate token from username and password
        var generateToken =
            'Basic ${base64.encode(utf8.encode('${usernameController.text}:${passwordController.text}'))}';

        /// user data as object
        Map userData = {
          "token": generateToken,
          ...data,
        };

        /// to navigate to home screen in second luanch
        Prefs.setInitPage(1);

        /// save user data to cache
        Prefs.setUserData(userData);

        /// create device to TracCar
        createDevice(generateToken);
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

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    // provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(context, "Sign In", true),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// hi section message
                    CustomWidgets.hiSection("Welcome Back",
                        'simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry.'),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Form(
                        key: signInFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// phone input
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
                                RegExp regex = RegExp(r'^.{8,}$');
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                } else if (!regex.hasMatch(value)) {
                                  return 'Password must be at least 8 characters.';
                                } else {
                                  return null;
                                }
                              },
                            ),

                            const SizedBox(
                              height: 24,
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
                              child: const Text('Sign In',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            /// navigator to other auth page text
                            CustomWidgets.otherAuthPageText(
                                "Don't have an account ?",
                                "Register now",
                                "/sign_up")
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
