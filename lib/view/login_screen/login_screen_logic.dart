import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pause_and_scroll/backend/helper/appRoute.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../utils/constants.dart';
import '../../utils/toasts.dart';
import 'login_screen_state.dart';

class LoginScreenLogic extends GetxController {
  final LoginScreenState state;

  LoginScreenLogic({required this.state});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool mainLoader = false.obs;
  RxBool googleLoader = false.obs;
  RxBool appleLoader = false.obs;
  RxBool passwordVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.initFirebase();
    });
  }

  loginWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        debugPrint('googleSignInAccount $googleSignInAccount');
        googleLoader.value = false;
        return;
      }
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      debugPrint('googleSignInAuthentication $googleSignInAuthentication');
      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      final idToken = await user?.getIdToken(true);

      debugPrint("Google user: $user");
      debugPrint("Google idToken: $idToken");
      googleLoader.value = false;
      if (user != null) {
        if (context.mounted) socialLoginApi(token: idToken ?? '');
      } else {
        errorToast('Error signing in with Google'.tr);
      }
    } catch (error) {
      errorToast('${'Error signing in with Google'.tr}$error');
      googleLoader.value = false;
    }
  }

  loginWithApply(BuildContext context) async {
    try {
      final rawNonce = generateNonce();
      final hashedNonce = state.sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: hashedNonce,
      );
      final oauthCredential = OAuthProvider(
        "apple.com",
      ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce, accessToken: appleCredential.authorizationCode);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      debugPrint("Apple Sign-In Successful: ${userCredential.user}");
      final user = userCredential.user;
      final idToken = await user?.getIdToken(true) ?? '';
      appleLoader.value = false;
      if (user != null) {
        if (context.mounted) socialLoginApi(token: idToken );
      } else {
        errorToast('Error signing in with Apple'.tr);
      }
    } catch (e) {
      debugPrint("Apple Sign-In Failed:".tr + e.toString());
      appleLoader.value = false;
    }
  }

  Future<void> emailLoginApi() async {
    String? token;

    if (state.sharedPreferencesManager.sharedPreferences.getString(Constants.saveToken) != null) {
      token = state.sharedPreferencesManager.sharedPreferences.getString(Constants.saveToken);
    } else {
      state.initFirebase();
      token = state.sharedPreferencesManager.sharedPreferences.getString(Constants.saveToken);
    }

    try {
      Map<String, dynamic> data = {
        "type": "email",
        "email": emailController.text.trim().toString(),
        "password": passwordController.text.trim().toString(),
        "fcmToken": token,
      };

      state
          .emailLoginState(data)
          .then((response) {
            if (response != null && response.statusCode == 200) {
              Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
              debugPrint("Login Response :: $myMap");
              state.saveData(myMap["data"]["accessToken"]);
              Get.offAllNamed(AppRouter.dashboardScreen);
              mainLoader.value = false;
            }else {
              mainLoader.value = false;
            }
          }).catchError((e) {
        mainLoader.value = false;
            debugPrint("Error: $e");
          });
    } catch (error) {
      errorToast('${'Error signing in with Google'.tr}$error');
    }
  }

  Future<void> socialLoginApi({required String token}) async {
    try {
      Map<String, dynamic> data = {
        "type": "social",
        "token": token,
        "fcmToken": state.sharedPreferencesManager.sharedPreferences.getString(Constants.saveToken),
      };

      state
          .socialLoginState(data)
          .then((response) {
            if (response != null && response.statusCode == 200) {
              Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
              debugPrint("Register Response :: $myMap");
              state.saveData(myMap["data"]["accessToken"]);
              Get.offAllNamed(AppRouter.dashboardScreen);
              googleLoader.value = false;
              appleLoader.value = false;
            }
          })
          .catchError((e) {
            debugPrint("Error: $e");
            appleLoader.value = false;
          });
    } catch (error) {
      errorToast('${'Error signing in with Google'.tr}$error');
      appleLoader.value = false;
    }
  }


}
