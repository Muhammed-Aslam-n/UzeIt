import 'package:flutter/material.dart';
import 'package:uzit/constants/constants.dart';
import 'package:uzit/controllers/auth_controller.dart';
import 'package:uzit/widgets/widgets.dart';
class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController.authController.disposeTextField();
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
                      alignment: Alignment.centerRight,
                      child: CommonHeaders(
                        text: "Sign Up\t",
                        size: 56.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    CommonTextField(
                      controller: AuthController.authController.emailController,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.deepOrangeAccent,
                      ),
                      label: "Email",
                    ),
                    sizedh2,
                    sizedh2,
                    CommonTextField(
                      controller: AuthController.authController.passwordController,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.deepOrangeAccent,
                      ),
                      label: "Password",
                      obscureText: true,
                    ),
                    sizedh2,
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: (){
                          debugPrint("SignUp Button Clicked");
                          AuthController.authController.register();
                        },
                        child: Container(
                          height: height * 0.065,
                          width: width * 0.35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: tfRadius,
                          ),
                          child: const Center(
                            child: CommonText(
                              text: "Sign In",
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
