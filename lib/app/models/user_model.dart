class UserModel {
  int id;
  String firstName;
  String middleName;
  String lastName;
  String personalEmail;
  String companyEmail;
  String phone;
  String maritalStatus;
  String address;
  String roleId;
  String receivesEmails;
  String emailFrequencyHours;
  String image;

  // Constructor with nullable fields
  UserModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.personalEmail,
    required this.companyEmail,
    required this.phone,
    required this.maritalStatus,
    required this.address,
    required this.roleId,
    required this.receivesEmails,
    required this.emailFrequencyHours,
    required this.image,
  });

  // Factory method to create a User instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,  // Default value if null
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      personalEmail: json['personal_email'] ?? '',
      companyEmail: json['company_email'] ?? '',
      phone: json['phone'] ?? '',
      maritalStatus: json['marital_status'] ?? '',
      address: json['address'] ?? '',
      roleId: json['role_id'] ?? '',
      receivesEmails: json['receives_emails'] ?? '',
      emailFrequencyHours: json['email_frequency_hours'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // Method to convert a User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'personal_email': personalEmail,
      'company_email': companyEmail,
      'phone': phone,
      'marital_status': maritalStatus,
      'address': address,
      'role_id': roleId,
      'receives_emails': receivesEmails,
      'email_frequency_hours': emailFrequencyHours,
      'image': image,
    };
  }
}
