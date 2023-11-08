import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minggu_07/auth.dart';
import 'package:minggu_07/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthFirebase auth;

  @override
  void initState() {
    auth = AuthFirebase();
    auth.getUser().then((value) {
      MaterialPageRoute route;
      if (value != null) {
        route = MaterialPageRoute(builder: (context) => MyHome(wid: value.uid, email: value.email,));
        Navigator.pushReplacement(context, route);
      }
    }).catchError((err) => print(err));
    super.initState();
  }

  Future<String?> _loginUser(LoginData data) {
    return auth.login(data.name, data.password).then((value) {
      if (value != null) {
        MaterialPageRoute(builder: (context) => MyHome(wid: value, email: value,));
      } else {
        final snackBar = SnackBar(
          content: const Text('Login Failed, User Not Found'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {

            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }
  
  Future<String?> _onSignup(SignupData data) {
    return auth.signup(data.name!, data.password!).then((value) {
      if (value != null) {
        final snackBar = SnackBar(
          content: const Text('Sign up Successful'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {

            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Future<String?> _onLoginGoogle() async {
    String? uid = await auth.signInWithGoogle();
    if (uid != null) {
      MaterialPageRoute(builder: (context) => MyHome(wid: uid, email: "example@email.com"));
    }
  }

  // Future<String?> _onLoginGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser != null) {
  //       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //       final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //       return userCredential.user?.uid;
  //     }
  //   } catch (e) {
  //     print('Error signing in with Google: $e');
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _loginUser,
      onRecoverPassword: _recoverPassword,
      onSignup: _onSignup,
      passwordValidator: (value) {
        if (value != null) {
          if (value.length < 6) {
            return "Password Must Be 6 characters";
          }
        }
      },
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: _onLoginGoogle
        )
      ],
      onSubmitAnimationCompleted: () {
        auth.getUser().then((value) {
          MaterialPageRoute route;
          if (value != null) {
            route = MaterialPageRoute(builder: (context) => MyHome(wid: value.uid, email: value.email));
          } else {
            route = MaterialPageRoute(builder: (context) => const LoginScreen());
          }
        }).catchError((err) => print(err));
      },
    );
  }

  Future<String>? _recoverPassword(String name) {
    return null;
  }

  // Future<String?>? _onLoginGoogle() {
  //   return null;
  // }
}
