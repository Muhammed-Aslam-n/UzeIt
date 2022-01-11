import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uzit/constants/constants.dart';
import 'package:uzit/controllers/auth_controller.dart';
import 'package:uzit/model/studentmodel.dart';
import 'package:uzit/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

dynamic height, width;

class SchoLoger extends StatelessWidget {
  const SchoLoger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
                padding: const EdgeInsets.only(left: 15, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),

                    ListTile(
                      horizontalTitleGap: -5,
                      minVerticalPadding: 12,
                      leading: Image.asset(
                        "assets/icons/AppIcon2.png",
                        height: 80,
                        width: 60,
                      ),
                      isThreeLine: true,
                      title: Text(
                        "SchoLoger",
                        style: TextStyle(
                          fontFamily: "font6",
                          fontSize: 35,
                          foreground: Paint()..shader = linearGradient,
                        ),
                      ),
                      subtitle: Text(
                        "\t\t\t\t\t\t\t\t\tImpression Matters",
                        style: TextStyle(
                          fontFamily: "font3",
                          fontSize: 10,
                          foreground: Paint()..shader = linearGradient,
                        ),
                      ),
                      trailing: popupButton(),
                    ),
                    // Row(
                    //   children: [
                    //     Image.asset(
                    //       "assets/icons/AppIcon2.png",
                    //       height: 50,
                    //       width: 50,
                    //     ),
                    //     Text(
                    //       "SchoLoger",
                    //       style: TextStyle(
                    //         fontFamily: "font6",
                    //         fontSize: 40,
                    //         foreground: Paint()..shader = linearGradient,
                    //       ),
                    //     ),
                    //     const Spacer(),
                    //     popupButton(),
                    //     sizedw2,
                    //   ],
                    // ),
                    sizedh2,
                    const SizedBox(
                      height: 30,
                    ),
                    CommonHeaders(
                      text:
                          "Welcome , ${AuthController.authController.userName}",
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonText(
                      text: "Create, Edit and Update all your Student Records",
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
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
      offset: const Offset(-20, 50),
      iconSize: 50,
      icon: GetBuilder<AuthController>(
        id: "homeProfileArea",
        builder: (controller) => controller.currentProfilePicture != null
            ? Container(
                height: 80,
                width: 40,
                decoration:
                    const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                child: ClipOval(
                  child: Image.network(
                    "${controller.currentProfilePicture}",
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: Image.asset(
                          "assets/giphy/loadingGiphy.gif",
                          height: height * 0.09,
                          width: width * 0.09,
                        ),
                      );
                    },
                  ),
                ),
              )
            : SizedBox(
                height: height * 0.09,
                width: width * 0.09,
                child: const CircleAvatar(
                  backgroundImage: AssetImage(
                      "assets/images/profile/noProfilePictureImage.png"),
                ),
              ),
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
        // PopupMenuItem(
        //   child: TextButton(
        //     onPressed: () {
        //       Get.back();
        //       Get.to(()=>const UpdateEmailAndPassword());
        //     },
        //     child: const Text(
        //       "Update Password",
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        //   value: 2,
        // ),
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
          value: 3,
        ),
      ],
    );
  }

  floatingAB(context) {
    return FloatingActionButton(
      onPressed: () {
        debugPrint("Add Button Clicked");
        AuthController.authController.isUpdating = false;
        showStudentFormSheet();
      },
      tooltip: "Add Student",
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      backgroundColor: Colors.redAccent,
    );
  }

  Widget buildStudents(StudentData student) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GestureDetector(
        onTap: () {
          showDeleteConfirmation();
        },
        child: Slidable(
          closeOnScroll: true,
          key: UniqueKey(),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (f) {
                  confirmDeletion(studentId: student.name);
                },
                backgroundColor: HexColor("#424b5e"),
                foregroundColor: Colors.redAccent,
                icon: Icons.delete,
              ),
              SlidableAction(
                onPressed: (f) {
                  AuthController.authController.setTextEditingControllers(
                      name: student.name,
                      mark: student.mark,
                      className: student.className,
                      regNum: student.rollNumber);
                  showStudentFormSheet(updateId: student.name);
                  AuthController.authController.isUpdating = true;
                },
                backgroundColor: HexColor("#424b5e"),
                foregroundColor: Colors.green,
                icon: Icons.edit,
              ),
            ],
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
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
                  child: CommonText(
                      text: student.mark, color: HexColor("#94A3C1"))),
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
        ),
      ),
    );
  }

  confirmDeletion({required studentId}) async {
    await Get.defaultDialog(
      title: "Delete",
      middleText: "Do you really want to delete ?",
      radius: 15,
      textCancel: "No",
      textConfirm: "Yes",
      onCancel: () {},
      onConfirm: () {
        AuthController.authController.deleteStudent(studentId: studentId);
        Future.delayed(const Duration(seconds: 1))
            .whenComplete(() => showDeleteConfirmation());
        Get.back();
      },
      barrierDismissible: true,
    );
  }

  showDeleteConfirmation() {
    Get.snackbar(
      "Delete",
      "Deleted Successfully ✓",
      snackPosition: SnackPosition.BOTTOM,
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.all(18),
      colorText: Colors.green,
    );
  }

  showStudentFormSheet({updateId}) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Get.bottomSheet(
      Form(
        key: formKey,
        child: SizedBox(
          height: height * 0.65,
          width: width,
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
                sizedh2,
                ElevatedButton(
                  onPressed: () async {
                    validateAndSave(formKey, updateId: updateId);
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
      backgroundColor: HexColor("#3b4254"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
    );
  }

  void validateAndSave(formKey, {updateId}) async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      AuthController.authController.isUpdating
          ? await AuthController.authController.updateStudent(updateId)
          : await AuthController.authController.addStudentDetails();
      Get.back();
    }
  }
}
