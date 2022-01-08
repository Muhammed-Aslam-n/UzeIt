class StudentData {
  String id;
  final String name;
  final String mark;
  final String rollNumber;
  final String className;

  StudentData({
    this.id = '',
    required this.name,
    required this.mark,
    required this.rollNumber,
    required this.className,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mark': mark,
        'rollnumber': rollNumber,
        'classname': className
      };

  static StudentData fromJson(Map<String, dynamic> json) => StudentData(
      name: json['name'],
      mark: json['mark'],
      id: json['id'],
      className: json['classname'],
      rollNumber: json['rollnumber']);
}

class UserData {
  String id;
  final String? userName;
  final String? userSubject;
  final String? userQualification;
  final String? userPhoneNumber;

  UserData(
      {this.id = '',
      this.userName,
      this.userSubject,
      this.userQualification,
      this.userPhoneNumber});

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'userSubject': userSubject,
        'userQualification': userQualification,
        'userPhoneNumber': userPhoneNumber
      };

  static UserData fromJson(Map<String, dynamic> json) => UserData(
      userName: json['userName'],
      userSubject: json['userSubject'],
      id: json['id'],
      userQualification: json['userQualification'],
      userPhoneNumber: json['userPhoneNumber']);
}
