import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uzit/model/studentmodel.dart';
import 'package:uzit/screens/home_uzit.dart';
import 'package:uzit/screens/login_uzit.dart';
import 'package:uzit/widgets/widgets.dart';

class AuthController extends GetxController {
  static AuthController authController = Get.find();

  // User class is from Firebase which includes Email,password,name ....
  late Rx<User?> _user;
  TextEditingController emailController = TextEditingController().obs();
  TextEditingController passwordController = TextEditingController().obs();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? userName;

  @override
  void onReady() {
    _user = Rx<User?>(firebaseAuth.currentUser);
    // our user will be notified
    _user.bindStream(firebaseAuth.userChanges());
    ever(_user, _initialScreen);
    super.onReady();
  }

  String? domainName;

  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const UzitLogin());
    } else {
      Get.offAll(() => const UzitHome());
      userName = user.email;
      domainName = userName!.substring(0, userName?.lastIndexOf("@"));
      getProfilePic();
    }
  }

  void register() async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      disposeTextField();
    } catch (error) {
      snackBar(error, title: "Account Creation failed");
    }
  }

  void userLogin() async {
    try {
      debugPrint("Email in Controller is ${emailController.text}");
      debugPrint("Password in Controller is ${passwordController.text}");
      await firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      disposeTextField();
    } catch (error) {
      snackBar(error, title: "Login Failed");
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    disposeTextField();
    currentProfilePicture = null;
    disposeTextField();
  }

  Future<void> resetPasswordUsingEmail() async {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(color: HexColor("#3b4254"),strokeWidth: 0.3,),
      )
    );
    try {
      await firebaseAuth.sendPasswordResetEmail(email: emailController.text.trim());
      snackBar("Reset link has been sent to your email",title: "Reset Password",duration: 3);
      disposeTextField();
      Get.offAll(const UzitLogin());
    } on FirebaseAuthException catch (exception) {
      debugPrint(exception.toString());
      disposeTextField();
    }
  }

  // Profile Picture integration
  File? imageFilePath;
  String? currentProfilePicture;
  String? pUrl = "".obs();

  updateProfile() {
    currentProfilePicture = pUrl;
    update(["profileArea", "homeProfileArea"]);
  }

  Future getProfilePic() async {
    final storage =
        FirebaseStorage.instance.ref("profile_picture/$domainName/$domainName");

    try {
      await storage.getDownloadURL().then((value) =>
          {value.isEmpty ? pUrl = null : pUrl = value, updateProfile()});
    } catch (error) {
      debugPrint("Object don't Exists");
    }
    debugPrint("Getting Link is $currentProfilePicture");
  }

  Future chooseFile() async {
    await ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      imageFilePath = File(image!.path);
    }).whenComplete(() => uploadFile());
    updateProfile();
  }

  Future uploadFile() async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_picture/$domainName/$domainName');
    var uploadTask = storageReference.putFile(imageFilePath!);
    await uploadTask.whenComplete(
      () => storageReference.getDownloadURL().then(
        (fileUrl) {
          pUrl = fileUrl;
        },
      ),
    );
  }

  // FireStore Section

  final fireStoreDb = FirebaseFirestore.instance;

  TextEditingController studentName = TextEditingController(),
      mark = TextEditingController(),
      className = TextEditingController(),
      registerNumber = TextEditingController(),
      userNameToRegister = TextEditingController(),
      userQualification = TextEditingController(),
      userSubject = TextEditingController(),
      userPhoneNumber = TextEditingController();

  setTextEditingControllers({name, mark, className, regNum}) {
    studentName.text = name;
    this.mark.text = mark;
    this.className.text = className;
    registerNumber.text = regNum;
  }

  addUserDetails() async {
    final userDocument = fireStoreDb
        .collection("UzeIt")
        .doc(userName ?? 'errorCollections')
        .collection("userDetails")
        .doc(userName ?? 'errorData');
    final userData = UserData(
        id: userDocument.id,
        userName: userNameToRegister.text,
        userSubject: userSubject.text,
        userQualification: userQualification.text,
        userPhoneNumber: userPhoneNumber.text);
    final userDataToUpload = userData.toJson();
    await userDocument.set(userDataToUpload);
    disposeTextField();
  }

  bool isUpdating = false.obs();
  BuildContext? context;

  addStudentDetails() async {
    final userDocument = fireStoreDb
        .collection("UzeIt")
        .doc(userName ?? 'errorCollections')
        .collection("studentDetails")
        .doc(studentName.text);
    final studentData = StudentData(
        id: userDocument.id,
        name: studentName.text,
        mark: mark.text,
        rollNumber: registerNumber.text,
        className: className.text);
    final dataToUpload = studentData.toJson();
    await userDocument.set(dataToUpload);
    disposeTextField();
  }

  updateStudent(dynamic id) {
    final userDocument = fireStoreDb
        .collection("UzeIt")
        .doc(userName ?? 'errorCollections')
        .collection("studentDetails")
        .doc(id);
    final studentData = StudentData(
        id: userDocument.id,
        name: studentName.text,
        mark: mark.text,
        rollNumber: registerNumber.text,
        className: className.text);
    final dataToUpload = studentData.toJson();
    userDocument.update(dataToUpload);
    disposeTextField();
  }

  deleteStudent({required dynamic studentId}) {
    final userDocument = fireStoreDb
        .collection("UzeIt")
        .doc(userName ?? 'errorCollections')
        .collection("studentDetails")
        .doc(studentId);
    userDocument.delete();
  }

  Stream<List<StudentData>> readStudents() {
    return fireStoreDb
        .collection("UzeIt")
        .doc(userName ?? 'errorCollections')
        .collection("studentDetails")
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => StudentData.fromJson(doc.data()))
            .toList());
  }

  readUsers() async {
    var userDocument = await fireStoreDb
        .collection("UzeIt")
        .doc(userName ?? 'errorCollections')
        .collection("userDetails")
        .get();
    try {
      var result = userDocument.docs.last.data();
      userNameToRegister.text = result['userName'];
      userQualification.text = result['userQualification'];
      userSubject.text = result['userSubject'];
      userPhoneNumber.text = result['userPhoneNumber'];
    } catch (error) {
      disposeTextField();
      debugPrint("No Details Found");
    }
  }

  snackBar(error, {title, color,duration}) {
    Get.snackbar(
      "",
      "",
      backgroundColor: color ?? Colors.redAccent,
      duration: Duration(seconds: duration??1),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(
        title ?? '',
        style: const TextStyle(color: Colors.white),
      ),
      messageText: Text(
        error.toString(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  disposeTextField() {
    emailController.clear();
    passwordController.clear();
    studentName.clear();
    mark.clear();
    registerNumber.clear();
    className.clear();
    userNameToRegister.clear();
    userQualification.clear();
    userSubject.clear();
    userPhoneNumber.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    studentName.dispose();
    mark.dispose();
    registerNumber.dispose();
    className.dispose();
    userNameToRegister.dispose();
    userQualification.dispose();
    userSubject.dispose();
    userPhoneNumber.dispose();
    super.dispose();
  }
}
