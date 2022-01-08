import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uzit/constants/constants.dart';
import 'package:uzit/controllers/auth_controller.dart';
import 'package:uzit/model/studentmodel.dart';
import 'package:uzit/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class UzitHome extends StatelessWidget {
  const UzitHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#3b4254"),
        floatingActionButton: floatingAB(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15,top: 20),
                child: Stack(
                  children: [
                    Positioned(right: -20, top: 20, child: popupButton()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GetBuilder<AuthController>(
                          id: "homeProfileArea",
                          builder: (controller) => controller
                                      .currentProfilePicture !=
                                  null
                              ? Container(
                                  height: height * 0.15,
                                  width: width * 0.6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          controller.currentProfilePicture!),fit: BoxFit.fitWidth,
                                    ),
                                    ),
                                )
                              // SizedBox(
                              //         height: height * 0.18,
                              //         width: width * 0.18,
                              //         child: CircleAvatar(
                              //           backgroundImage: NetworkImage(
                              //               controller.currentProfilePicture!),
                              //         ),
                              //       )
                              //
                              : SizedBox(
                                  height: height * 0.18,
                                  width: width * 0.18,
                                  child: const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/profile/noProfilePictureImage.png"),
                                  ),
                                ),
                        ),
                        sizedh2,
                        CommonHeaders(
                          text:
                              "Welcome , ${AuthController.authController.userName}",
                          color: Colors.white.withOpacity(0.5),
                        ),
                        sizedh2,
                        CommonText(
                          text:
                              "Create, Edit and Update all your Student Records",
                          color: Colors.grey.shade600,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              sizedh2,
              Flexible(
                  child: StreamBuilder<List<StudentData>>(
                stream: AuthController.authController.readStudents(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong!"));
                  } else if (snapshot.hasData) {
                    final students = snapshot.data;
                    return ListView(
                      shrinkWrap: true,
                      children: students!.map(buildStudents).toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.redAccent,
                        strokeWidth: 0.3,
                      ),
                    );
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }

  popupButton() {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey.shade600,
      ),
      color: Colors.red,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              Get.back();
              Get.toNamed('/updateProfile');
            },
            child: const Text(
              "Update Profile",
              style: TextStyle(color: Colors.white),
            ),
          ),
          value: 1,
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () async {
              Get.back();
              await AuthController.authController.signOut();
            },
            child: const Text(
              "Sign Out",
              style: TextStyle(color: Colors.white),
            ),
          ),
          value: 1,
        ),
      ],
    );
  }

  floatingAB(context) {
    return FloatingActionButton(
      onPressed: () {
        debugPrint("Add Button Clicked");
        showDialogueBox(context);
      },
      tooltip: "Add Student",
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      backgroundColor: Colors.redAccent,
    );
  }

  Widget buildStudents(StudentData student) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          tileColor: HexColor("#424b5e"),
          leading: Container(
            height: double.maxFinite,
            width: 60,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: HexColor("#6D788D"),
                ),
              ),
            ),
            child: Center(
                child:
                    CommonText(text: student.mark, color: HexColor("#94A3C1"))),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: CommonText(
              text: student.name,
              color: HexColor("#b0b6be"),
              size: 14,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: CommonText(
              text: student.className,
              color: HexColor("#94A3C1"),
              size: 11,
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CommonText(
              text: student.rollNumber,
              color: HexColor("#94A3C1"),
              size: 11,
            ),
          ),
        ),
      );

  showDialogueBox(context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      builder: (context) => Form(
        key: formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                sizedh2,
                Icon(
                  Icons.person_add_alt_1,
                  color: HexColor("#252942"),
                  size: 43,
                ),
                sizedh2,
                DataTextFields(
                  controller: AuthController.authController.studentName,
                  labelText: "Name",
                  errorText: "Name required",
                  icon: const Icon(Icons.accessibility),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-z.A-Z ]'))
                  ],
                  minLength: 3,
                ),
                sizedh2,
                DataTextFields(
                  controller: AuthController.authController.mark,
                  labelText: "Mark",
                  errorText: "Mark required",
                  icon: const Icon(Icons.margin),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9 ]'))
                  ],
                  textInputType: TextInputType.phone,
                  ismaxLength: true,
                ),
                sizedh2,
                DataTextFields(
                  controller: AuthController.authController.registerNumber,
                  labelText: "Register number",
                  errorText: "Register Number required",
                  icon: const Icon(Icons.padding),
                  maxLength: 5,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9 ]'))
                  ],
                  ismaxLength: true,
                  textInputType: TextInputType.phone,
                ),
                sizedh2,
                DataTextFields(
                  controller: AuthController.authController.className,
                  labelText: "Class name",
                  errorText: "Class name required",
                  icon: const Icon(Icons.class_),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-z.A-Z ]'))
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    validateAndSave(formKey);
                  },
                  child: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    primary: HexColor("#252942"),
                    fixedSize: const Size(80, 40),
                  ),
                ),
                sizedh1,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateAndSave(formKey) async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      await AuthController.authController.addStudentDetails();
      Get.back();
    }
  }
}
