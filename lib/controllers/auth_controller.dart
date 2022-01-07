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
import 'package:path/path.dart' as Path;
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

  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(()=> const UzitLogin());
    } else {
      Get.offAll(()=> const UzitHome());
      userName = user.email;
    }
  }

  void register() async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(), password: passwordController.text.trim()
      );
      disposeTextField();
    } catch (error) {
      snackBar(error,title: "Account Creation failed");
    }
  }

  void userLogin() async {
    try {
      debugPrint("Email in Controller is ${emailController.text}");
      debugPrint("Password in Controller is ${passwordController.text}");
      await firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(), password: passwordController.text.trim());
      disposeTextField();
    } catch (error) {
      snackBar(error,title: "Login Failed");
    }
  }
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    disposeTextField();
  }

  snackBar(error,{title}){
    return Get.snackbar(
      "",
      "",
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      messageText: Text(
        error.toString(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }


  // FireStore Section

  final fireStoreDb = FirebaseFirestore.instance;
  TextEditingController studentName = TextEditingController();
  TextEditingController mark = TextEditingController();
  TextEditingController className = TextEditingController();
  TextEditingController registerNumber = TextEditingController();
  addStudentDetails() async {
    final docUser = fireStoreDb.collection(userName??'errorCollections').doc();
    final studentData = StudentData(id: docUser.id,name: studentName.text,mark: mark.text,rollNumber: registerNumber.text,className: className.text);
    final dataToUpload = studentData.toJson();
    await docUser.set(dataToUpload);
    disposeTextField();
  }


  Stream<List<StudentData>> readUsers() {
    return fireStoreDb.collection(userName!).snapshots().map((snapShot) => snapShot.docs.map((doc) => StudentData.fromJson(doc.data())).toList());
  }




  // Image Picker Integration
  File? imageFilePath;
  String? currentProfilePicture = "".obs();
  String? pUrl = "".obs();
  updateProfile(){
    currentProfilePicture = pUrl;
    update(["profileArea"]);
  }

  late final k;
  Future getProfilePic() async{
    final storage = FirebaseStorage.instance.ref("profile_picture");
    await storage.listAll().then((value) {
      // k = value.items.toList();
      // debugPrint(k['fullPath'].toString());
      value.items.last.getDownloadURL().then((value) => currentProfilePicture = value.toString());
    });
  }

  Future chooseFile() async {
    await ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      imageFilePath = File(image!.path);
    }).whenComplete(() => uploadFile());
    updateProfile();
  }
  
  Future uploadFile() async {
    var storageReference = FirebaseStorage.instance.ref().child('profile_picture/$userName');
    var uploadTask = storageReference.putFile(imageFilePath!);
    await uploadTask.whenComplete(() => storageReference.getDownloadURL().then((fileUrl) {
      pUrl = fileUrl;
    }));
  }
  




















  disposeTextField(){
    emailController.clear();
    passwordController.clear();
    studentName.clear();
    mark.clear();
    registerNumber.clear();
    className.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    studentName.dispose();
    mark.dispose();
    registerNumber.dispose();
    className.dispose();
    super.dispose();
  }


}
