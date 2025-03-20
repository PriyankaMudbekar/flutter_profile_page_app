class UserModel {
  int? id;
  String firstName;
  String lastName;
  String dob; // ✅ Ensures DOB is required
  String gender; // ✅ Ensures Gender is required
  String phone;
  String email;
  String password;
  String? profileImage;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.phone,
    required this.email,
    required this.password,
  });

  /// Convert UserModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?, // ✅ Ensure `id` is an int?
      firstName: json['firstName'] ?? "", // ✅ Ensures non-null values
      lastName: json['lastName'] ?? "",
      dob: json['dob'] ?? "",
      gender: json['gender'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",

    );
  }
}


/*
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
*/
