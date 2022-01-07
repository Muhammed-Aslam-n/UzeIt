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

  Map<String,dynamic> toJson() =>{
    'id': id,
    'name': name,
    'mark': mark,
    'rollnumber': rollNumber,
    'classname': className
  };

  static StudentData fromJson(Map<String,dynamic>json) => StudentData(name: json['name'], mark: json['mark'],id: json['id'],className: json['classname'],rollNumber: json['rollnumber']);

}
