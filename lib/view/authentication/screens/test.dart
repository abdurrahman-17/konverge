import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import '../../../services/amplify/amplify_service.dart';

import '../../../utilities/enums.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = "test_screen";

  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Screen")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Amplify.Auth.signOut();
              },
              child: const Text("Signout"),
            ),
            ElevatedButton(
              onPressed: () {
                AmplifyService().signInWithSocialLogin(LoginType.apple);
              },
              child: const Text("social login"),
            ),
            ElevatedButton(
              onPressed: () {
                AmplifyService().getCognitoUserData();
              },
              child: const Text("getCognitoUserData"),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await AmplifyService().getTokens();
                log("idToken:${result?.idToken.raw}");
              },
              child: const Text("getTokens"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AmplifyService().getCurrentUserAttributes();
              },
              child: const Text("getUserAtt"),
            ),
          ],
        ),
      ),
    );
  }
}
