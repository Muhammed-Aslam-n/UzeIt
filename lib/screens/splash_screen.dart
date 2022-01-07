import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: const Center(child: CircularProgressIndicator(color: Colors.redAccent,strokeWidth: 0.5,),),
    );
  }
}
