// // ignore_for_file: avoid_print, use_build_context_synchronously
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../blocs/authentication/authentication_bloc.dart';
// import 'package:local_auth/local_auth.dart';
//
// import '../../../core/locator.dart';
// import '../../../main.dart';
// import '../../../services/authentication_service.dart';
// import '../../common_widgets/snack_bar.dart';
// import '../../../utilities/constants.dart';
//
// class ManualLoginWidget extends StatefulWidget {
//   const ManualLoginWidget({Key? key}) : super(key: key);
//
//   @override
//   State<ManualLoginWidget> createState() => _ManualLoginWidgetState();
// }
//
// class _ManualLoginWidgetState extends State<ManualLoginWidget> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//   final _auth = LocalAuthentication();
//   bool _canCheckBiometric = false;
//   bool _isLocalAuthEnabled = false;
//   Map<String, String> _credentials = {};
//
//   ///checking biometric or local auth [password,pattern]
//   Future<void> _checkBiometric() async {
//     try {
//       _canCheckBiometric =
//           await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
//
//       print("_canCheckBiometric:$_canCheckBiometric");
//       if (mounted) {
//         setState(() {});
//       }
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }
//
//   //checking whether the cred is already stored to local
//   Future<void> _checkLocalAuth() async {
//     _credentials = await Locator.instance
//         .get<AuthenticationService>()
//         .getUserCredFromLocal();
//     if (mounted) {
//       setState(() {
//         _isLocalAuthEnabled =
//             _credentials[Constants.isLocalAuth] == null ? false : true;
//       });
//     }
//   }
//
// //biometric authentication
//   Future<void> _authenticate(BuildContext context) async {
//     bool authenticated = false;
//     try {
//       authenticated = await _auth.authenticate(
//         localizedReason: "Please authenticate",
//         options: const AuthenticationOptions(stickyAuth: true),
//       );
//     } on PlatformException catch (e) {
//     } finally {
//     }
//
//     if (authenticated &&
//         _credentials[Constants.email] != null &&
//         _credentials[Constants.password] != null) {
//       BlocProvider.of<AuthenticationBloc>(context).add(
//         SignInWithPhoneAndPasswordEvent(
//             phoneNumber: _credentials[Constants.phone] ?? '',
//             password: _credentials[Constants.password] ?? ''),
//       );
//     } else {
//       showSnackBar(
//         message: "Authentication failed",
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       BlocProvider.of<AuthenticationBloc>(context).add(LoginInitialEvent());
//       _checkLocalAuth();
//       _checkBiometric();
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         // children: [
//         //   CustomTextFormField(
//         //     validator: (email) => Validation.emailValidation(email),
//         //     bottomLeftRadius: 20.r,
//         //     topLeftRadius: 20.r,
//         //     topRightRadius: 20.r,
//         //     bottomRightRadius: 20.r,
//         //     controller: emailController,
//         //     hint: TitleString.email,
//         //     prefixIcon: const Icon(
//         //       Icons.email,
//         //       color: Colors.grey,
//         //     ),
//         //   ),
//         //   SizedBox(
//         //     height: 20.h,
//         //   ),
//         //   CustomTextFormField(
//         //     validator: (password) => Validation.passwordValidation(password),
//         //     obscureText: true,
//         //     bottomLeftRadius: 20.r,
//         //     topLeftRadius: 20.r,
//         //     topRightRadius: 20.r,
//         //     bottomRightRadius: 20.r,
//         //     controller: passwordController,
//         //     hint: TitleString.password,
//         //     prefixIcon: const Icon(
//         //       Icons.lock,
//         //       color: Colors.grey,
//         //     ),
//         //   ),
//         //   SizedBox(
//         //     height: 10.h,
//         //   ),
//         //   TextButton(
//         //     onPressed: () {
//         //       Navigator.pushNamed(
//         //         context,
//         //         ForgotPasswordScreen.routeName,
//         //       );
//         //     },
//         //     child: Text(
//         //       TitleString.forgotPassword,
//         //       style: forgotStyle,
//         //     ),
//         //   ),
//         //   CustomElevatedButton(
//         //     title: TitleString.login,
//         //     height: 60.h,
//         //     onTap: () {
//         //       if (_formKey.currentState!.validate()) {
//         //         BlocProvider.of<AuthenticationBloc>(context).add(
//         //           SignInWithEmailAndPasswordEvent(
//         //             email: emailController.text,
//         //             password: passwordController.text,
//         //           ),
//         //         );
//         //       }
//         //     },
//         //   ),
//         //   if (_canCheckBiometric && _isLocalAuthEnabled)
//         //     Padding(
//         //       padding: const EdgeInsets.all(8.0),
//         //       child: CustomElevatedButton(
//         //         title: "Authenticate",
//         //         height: 60.h,
//         //         onTap: () {
//         //           _authenticate(context);
//         //         },
//         //       ),
//         //     ),
//         // ],
//       ),
//     );
//   }
// }
