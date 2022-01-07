import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uzit/constants/constants.dart';
import 'package:uzit/controllers/auth_controller.dart';
import 'package:uzit/widgets/widgets.dart';
import 'package:get/get.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor("#252942"),
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            CommonHeaders(
              text: "Update Profile",
              color: Colors.white.withOpacity(0.7),
              size: 30,
            ),
            sizedh2,
            SizedBox(
              height: height * 0.28,
              width: width * 0.28,
              child: GetBuilder<AuthController>(
                id: "profileArea",
                builder: (controller) => Stack(
                  children: [
                    controller.currentProfilePicture != ""
                        ? SizedBox(
                            height: height * 0.28,
                            width: width * 0.28,
                            child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "${controller.currentProfilePicture}")),
                          )
                        : SizedBox(
                            height: height * 0.18,
                            width: width * 0.18,
                            child: const CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/profile/noProfilePictureImage.png"),
                            ),
                          ),
                    Positioned(
                      bottom: 38,
                      right: 1,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Center(
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              debugPrint("Edit Icon Pressed");
                              controller.chooseFile();
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CommonTextField(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white.withOpacity(0.5),
              ),
              bgColor: HexColor("#252942"),
              blurRadius: 0,
              spreadRadius: 0,
            ),
            sizedh2,
            CommonTextField(
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white.withOpacity(0.5),
              ),
              bgColor: HexColor("#252942"),
              blurRadius: 0,
              spreadRadius: 0,
              obscureText: true,
            ),
            sizedh2,
            sizedh2,
            Align(
              alignment: Alignment.center,
              child: Container(
                height: height * 0.055,
                width: width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: tfRadius,
                ),
                child: const Center(
                  child: CommonText(
                    text: "Save",
                    color: Colors.white,
                    size: 19.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
