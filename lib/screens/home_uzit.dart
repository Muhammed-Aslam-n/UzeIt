import 'package:flutter/material.dart';
import 'package:uzit/constants/constants.dart';
import 'package:uzit/controllers/auth_controller.dart';
import 'package:uzit/model/studentmodel.dart';
import 'package:uzit/widgets/widgets.dart';
import 'package:get/get.dart';

class UzitHome extends StatelessWidget {
  const UzitHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: floatingAB(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: width,
                height: height * 0.35,
                decoration: BoxDecoration(
                  color: HexColor("#252942"),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Stack(
                    children: [
                      Positioned(right: 0, top: 20, child: popupButton()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          controller.currentProfilePicture != "" ?
                      SizedBox(
                          height: height * 0.18,
                          width: width * 0.18,
                          child: CircleAvatar(backgroundImage: NetworkImage("${controller.currentProfilePicture}"),)
                      ) : SizedBox(
                              height: height * 0.18,
                              width: width * 0.18,
                              child: const CircleAvatar(backgroundImage: AssetImage("assets/images/profile/noProfilePictureImage.png"),)
                          ) ,
                          CommonHeaders(
                            text: "Welcome , ${controller.userName}",
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
              ),
              sizedh2,
              Flexible(
                  child: StreamBuilder<List<StudentData>>(
                stream: controller.readUsers(),
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

  Widget buildStudents(StudentData student) => ListTile(
        leading: CircleAvatar(
          child: Text(student.mark),
        ),
        title: Text(student.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4,),
            Text(student.rollNumber),
            const SizedBox(height: 4,),
            Text(student.className),
          ],
        ),
      );

  showDialogueBox(context) {
    final controller = Get.find<AuthController>();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      builder: (context) => Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                sizedh2,
                CommonHeaders(text: "New Student",color: Colors.grey.shade600,size: 23,),
                sizedh2,
                DataTextFields(
                  controller: controller.studentName,
                  labelText: "Name",
                  errorText: "Name required",
                  icon: const Icon(Icons.accessibility),
                ),
                sizedh2,
                DataTextFields(
                  controller: controller.mark,
                  labelText: "Mark",
                  errorText: "Mark required",
                  icon: const Icon(Icons.margin),
                ),
                sizedh2,
                DataTextFields(
                  controller: controller.registerNumber,
                  labelText: "Register number",
                  errorText: "Register Number required",
                  icon: const Icon(Icons.padding),
                ),
                sizedh2,
                DataTextFields(
                  controller: controller.className,
                  labelText: "Class name",
                  errorText: "Class name required",
                  icon: const Icon(Icons.class_),
                ),
                sizedh2,
                ElevatedButton(
                  onPressed: () async {
                    await controller.addStudentDetails();
                    Get.back();
                  },
                  child: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(60, 30),
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
}
