import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uzit/controllers/auth_controller.dart';
import 'package:uzit/screens/home_uzit.dart';
import 'package:uzit/screens/login_uzit.dart';
import 'package:uzit/screens/signup_uzit.dart';
import 'package:uzit/screens/splash_screen.dart';
import 'package:uzit/screens/updateprofile.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  await getPic();
  runApp(const Uzit());
}

Future getPic() async{
  final controller = Get.find<AuthController>();
  await controller.getProfilePic();
}


class Uzit extends StatelessWidget {
  const Uzit({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      // initialRoute: '/',
      home: const SplashScreen(),
      getPages: [
        GetPage(name: '/', page: ()=>const UzitLogin()),
        GetPage(name: '/SignUpPage', page: ()=>const SignUp()),
        GetPage(name: '/home', page: ()=>const UzitHome()),
        GetPage(name: '/updateProfile', page: ()=>const UpdateProfile()),
      ],
    );
  }
}