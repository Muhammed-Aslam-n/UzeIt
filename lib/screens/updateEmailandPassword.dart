// import 'package:flutter/material.dart';
// import 'package:uzit/constants/constants.dart';
// import 'package:uzit/controllers/auth_controller.dart';
// import 'package:uzit/widgets/widgets.dart';
// import 'package:get/get.dart';
//
// class UpdateEmailAndPassword extends StatelessWidget {
//   const UpdateEmailAndPassword({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     AuthController.authController.disposeTextField();
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: HexColor("#252942"),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 100,
//             ),
//             ListTile(
//               horizontalTitleGap: -5,
//               minVerticalPadding: 12,
//               leading: Image.asset(
//                 "assets/icons/AppIcon2.png",
//                 height: 80,
//                 width: 60,
//               ),
//               isThreeLine: true,
//               title: Text(
//                 "SchoLoger",
//                 style: TextStyle(
//                   fontFamily: "font6",
//                   fontSize: 35,
//                   foreground: Paint()..shader = linearGradient,
//                 ),
//               ),
//               subtitle: Text(
//                 "\t\t\t\t\t\t\t\t\tImpression Matters",
//                 style: TextStyle(
//                   fontFamily: "font3",
//                   fontSize: 10,
//                   foreground: Paint()..shader = linearGradient,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 50,
//             ),
//             Center(
//               child: CommonHeaders(
//                 text: "Update Profile",
//                 color: Colors.white.withOpacity(0.7),
//                 size: 30,
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             CommonText(
//               text: "Change your Email and Password",
//               color: Colors.white.withOpacity(0.7),
//               size: 15,
//             ),
//             const SizedBox(
//               height: 50,
//             ),
//             CommonTextField(
//               controller: AuthController.authController.emailController,
//               prefixIcon: Icon(
//                 Icons.email,
//                 color: Colors.white.withOpacity(0.5),
//               ),
//               bgColor: HexColor("#252942"),
//               blurRadius: 0,
//               spreadRadius: 0,
//               label: "Name",
//             ),
//             sizedh2,
//             CommonTextField(
//               controller: AuthController.authController.passwordController,
//               prefixIcon: Icon(
//                 Icons.lock,
//                 color: Colors.white.withOpacity(0.5),
//               ),
//               bgColor: HexColor("#252942"),
//               blurRadius: 0,
//               spreadRadius: 0,
//               label: "Subject",
//             ),
//             const SizedBox(
//               height: 35,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await AuthController.authController.updateEmailAndPassword();
//                 await AuthController.authController
//                     .snackBar("Updated Successfully", color: Colors.green);
//                 // Future.delayed(const Duration(seconds: 3))
//                 //     .whenComplete(() => Get.back());
//                 AuthController.authController.disposeTextField();
//               },
//               style: ElevatedButton.styleFrom(
//                 fixedSize: Size(width * 0.32, height * 0.06),
//                 primary: HexColor("#252942").withOpacity(0.3),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12), // <-- Radius
//                 ),
//               ),
//               child: const Center(
//                 child: CommonText(
//                   text: "Update",
//                   color: Colors.white,
//                   size: 19.0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
