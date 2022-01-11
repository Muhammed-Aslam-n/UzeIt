import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
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
  @override
  void initState() {
    AuthController.authController.readUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor("#252942"),
      body: SingleChildScrollView(
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
            GetBuilder<AuthController>(
              id: "profileArea",
              builder: (controller) => Stack(
                children: [
                  controller.currentProfilePicture != null
                      ? ClipOval(
                          child: Image.network(
                            "${controller.currentProfilePicture}",
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: Image.asset(
                                  "assets/giphy/loadingGiphy.gif",
                                  height: 150,
                                  width: 150,
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox(
                          height: 150,
                          width: 150,
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                                "assets/images/profile/noProfilePictureImage.png"),
                          ),
                        ),
                  Positioned(
                    bottom: 8,
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
            const SizedBox(
              height: 10,
            ),
            CommonTextField(
              controller: AuthController.authController.userNameToRegister,
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white.withOpacity(0.5),
              ),
              bgColor: HexColor("#252942"),
              blurRadius: 0,
              spreadRadius: 0,
              label: "Name",
            ),
            sizedh2,
            CommonTextField(
              controller: AuthController.authController.userSubject,
              prefixIcon: Icon(
                Icons.subject,
                color: Colors.white.withOpacity(0.5),
              ),
              bgColor: HexColor("#252942"),
              blurRadius: 0,
              spreadRadius: 0,
              label: "Subject",
            ),
            sizedh2,
            CommonTextField(
              controller: AuthController.authController.userQualification,
              prefixIcon: Icon(
                LineariconsFree.graduation_hat,
                color: Colors.white.withOpacity(0.5),
              ),
              bgColor: HexColor("#252942"),
              blurRadius: 0,
              spreadRadius: 0,
              label: "Qualification",
            ),
            sizedh2,
            CommonTextField(
              controller: AuthController.authController.userPhoneNumber,
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.white.withOpacity(0.5),
              ),
              bgColor: HexColor("#252942"),
              blurRadius: 0,
              spreadRadius: 0,
              label: "Phone number",
            ),
            sizedh2,
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await AuthController.authController.addUserDetails();
                  await AuthController.authController
                      .snackBar("Updated Successfully", color: Colors.green);
                  Future.delayed(const Duration(seconds: 3))
                      .whenComplete(() => Get.back());
                  AuthController.authController.disposeTextField();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(height * 0.1, width * 0.11),
                  primary: HexColor("#252942").withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
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
