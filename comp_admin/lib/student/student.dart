class Student {
  String id;
  String name;
  String registrationNumber;
  String email;
  // Add other properties as needed

  Student({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.email,
  });

  // A method to create a Student from JSON (Firestore data)
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      registrationNumber: json['registrationNumber'],
      email: json['email'],
    );
  }

  // A method to convert Student object to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'registrationNumber': registrationNumber,
      'email': email,
    };
  }
}
