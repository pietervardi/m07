import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minggu_07/login_screen.dart';

class MyHome extends StatefulWidget {
  final String wid;
  final String? email;
  const MyHome({super.key, required this.wid, required this.email});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }
              } catch (e) {
                print("Error signing out: $e");
              }
            },
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_sharp)
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome ${widget.email}'),
            Text('ID ${widget.wid}')
          ],
        ),
      ),
    );
  }
}
