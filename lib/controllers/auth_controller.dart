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

  // TextEditing controllers which holds the data entered into respective TextForm Fields
  TextEditingController emailController = TextEditingController().obs();
  TextEditingController passwordController = TextEditingController().obs();

  // Firebase Authentication Instance used to access the Firebase console curresponding to this Project

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // String to hold the username temporarily
  String? userName;

  @override
  void onReady() {
    _user = Rx<User?>(firebaseAuth.currentUser);
    // our user will be notified whenever a change is made
    _user.bindStream(firebaseAuth.userChanges());
    ever(_user, _initialScreen);
    super.onReady();
  }

  String?
      domainName; // String to hold the username extracted from the email ( domain of email ), used to store profile pictures and collection using this value

  _initialScreen(User? user) {
    // function which listens changes to current state of user (logged or not ) and navigates to respective pages
    if (user == null) {
      Get.offAll(() => const SchoLogerLogin()); // login page of SchoLoger
    } else {
      Get.offAll(() => const SchoLoger()); // Home of SchoLoger
      userName = user.email;
      domainName = userName!.substring(
          0, userName?.lastIndexOf("@")); // converts domain name from email
      getProfilePic(); // Function  to show the User's Profile picture
    }
  }

  void register() async {
    // Function to Register to firebase using their email and Password as Credentials
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      disposeTextField();
    } catch (error) {
      snackBar(error,
          title: "Account Creation failed"); // snackbar to show error occurred
    }
  }

  void userLogin() async {
    // Function to Login to SchoLoger with already registered credentials
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      disposeTextField();
    } catch (error) {
      snackBar(error, title: "Login Failed"); // snackbar to show error occurred
    }
  }

  Future<void> signOut() async {
    // Method to Sign out user When they need to..
    await firebaseAuth.signOut();
    disposeTextField();
    currentProfilePicture =
        null; //  makes null to not to display previous user profile in any case
    disposeTextField();
  }

  // Method to reset the user's password as forgott password
  Future<void> resetPasswordUsingEmail() async {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(
          color: HexColor("#3b4254"),
          strokeWidth: 0.3,
        ),
      ),
    );
    try {
      await firebaseAuth.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      snackBar(
        "Reset link has been sent to your email",
        title: "Reset Password",
        duration: 3,
      );
      disposeTextField();
      Get.offAll(const SchoLogerLogin());
    } on FirebaseAuthException catch (exception) {
      debugPrint(exception.toString());
      disposeTextField();
    }
  }

  //
  // Future<void> updateEmailAndPassword() async {
  //   try {
  //     debugPrint("New Email is ${emailController.text}");
  //     debugPrint("New Password is ${passwordController.text}");
  //     // await firebaseAuth.currentUser!.updateEmail(emailController.text.trim());
  //     await firebaseAuth.currentUser!
  //         .updatePassword(passwordController.text.trim());
  //     disposeTextField();
  //     // Get.offAll(const UzitHome());
  //   } on FirebaseAuthException catch (exception) {
  //     debugPrint(exception.toString());
  //     disposeTextField();
  //   }
  // }

  /*
                                            Profile Picture integration
  ---------------------------------------------------------------------------------------------------------------------
  * This section is used for all the methods used to select, upload the New Profile Pictures and display updated profile
  * in realtime to UI.
  *
  * updateProfile () -> Used to notify currentProfilePicture whenever image path is changed
  *
  * getProfilePic() -> Used to Fetch Profile Picture path to club to UI
  *
  * chooseFile() -> Used to Select a profile picture from user's internal memory and saves path to
  *  imageFilePath variable and calls UpdateProfile fn to notify UI about the change
  *
  * uploadFile() -> Main objective of this method is to upload the selected file to respective firebase storage
  *                 ( putFile() method of firebase helps to upload the selected file , 'profile_picture/$domainName/$domainName'
  *                   is used to store the file in structured way like profile_picture/johnDoe/johnDoe.extension , getDownloadURL()
  *                   helps to get the network url to display in UI )
  *  */

  File? imageFilePath; // stores the file path of image from internal storage
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

  /*
  *                                        FireStore Section
  * ------------------------------------------------------------------------------------------
  * fireStoreDb is used to store and instance of Firebase Instance to access the firestore of the User
  *
  * TextEditing Controllers are used to store details of the students
  *
  * setTextEditingControllers() -> used to initialize values to Controllers
  *
  * addUserDetails() -> Method to add the Details of User to Firestore for that a Model class UserData is created and value are stored to firestore using UserData model's Named Constructor toJson
  *
  * addStudentDetails() -> Method to add the Details of Student to Firestore for that a Model class StudentData is created and value are stored to firestore using StudentData model's Named Constructor toJson
  *
  * updateStudent() -> Method to update records of students using their Id in firestore
  *
  * deleteStudent() -> Method to Delete the selected Student
  *
  * readStudents() -> Method used to get stream of students available to club to UI
  *
  * readUsers() -> Method used to Listen and get Details of logged user to UI
  *
  * snackbar() - Custom Widget to Use GetX snackBar
  *
  * disposeTextField() -> Method to easily clear all the values of Every Controller
  *
  * */

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

  snackBar(error, {title, color, duration}) {
    Get.snackbar(
      "",
      "",
      backgroundColor: color ?? Colors.redAccent,
      duration: Duration(seconds: duration ?? 1),
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
