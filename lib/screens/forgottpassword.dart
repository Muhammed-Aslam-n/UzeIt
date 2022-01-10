import 'package:flutter/material.dart';
import 'package:uzit/constants/constants.dart';
import 'package:uzit/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:uzit/widgets/widgets.dart';
class ForgottPassword extends StatelessWidget {
  const ForgottPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          height: height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage("assets/images/bgImages/bg5.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.25,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CommonHeaders(
                        text: "\t\t   Reset",
                        size: 38.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CommonHeaders(
                        text: "      Password",
                        size: 38.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    CommonTextField(
                      controller: controller.emailController,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.deepOrangeAccent,
                      ),
                      label: "Email",
                    ),
                    sizedh1,
                    const CommonText(text: "\t\t\t\t\t\t\t\t\t\t* Reset link will be sent to your email",color: Colors.white,),
                    sizedh2,
                    sizedh2,
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: (){
                          debugPrint("Reset Button Clicked");
                          AuthController.authController.resetPasswordUsingEmail();
                        },
                        child: Container(
                          height: height * 0.06,
                          width: width * 0.35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: tfRadius,
                          ),
                          child: const Center(
                            child: CommonText(
                              text: "\t\tReset Password",
                              color: Colors.white,
                              size: 32.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
