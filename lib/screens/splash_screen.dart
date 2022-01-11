import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(child: CircularProgressIndicator(color: Colors.redAccent,strokeWidth: 0.5,),),
    );
  }
}
