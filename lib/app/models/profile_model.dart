class ProfileModel {
  int id;
  String name;
  String personalEmail;
  String companyEmail;
  String phone;
  String maritalStatus;
  String role;
  String image;

  ProfileModel({
    required this.id,
    required this.name,
    required this.personalEmail,
    required this.companyEmail,
    required this.phone,
    required this.maritalStatus,
    required this.role,
    required this.image,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["data"]["id"],
      name: json["data"]["name"],
      personalEmail: json["data"]["personal_email"],
      companyEmail: json["data"]["company_email"],
      phone: json["data"]["phone"],
      maritalStatus: json["data"]["marital_status"],
      role: json["data"]["role"],
      image: json["data"]["image"],
    );
  }
}
