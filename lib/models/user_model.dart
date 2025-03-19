class UserModel {
  int? id;
  String firstName;
  String lastName;
  String dob; // ✅ Add this
  String gender; // ✅ Add this
  String phone;
  String email;
  String password;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.dob, // ✅ Add this
    required this.gender, // ✅ Add this
    required this.phone,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob, // ✅ Add this
      'gender': gender, // ✅ Add this
      'phone': phone,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dob: json['dob'] ?? "", // ✅ Add this
      gender: json['gender'] ?? "", // ✅ Add this
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
    );
  }
}
