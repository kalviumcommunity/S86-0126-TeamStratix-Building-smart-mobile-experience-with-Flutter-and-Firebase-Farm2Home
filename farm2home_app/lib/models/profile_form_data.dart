/// Profile Form Data Model
/// Represents the data structure for the Profile Details Form
class ProfileFormData {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  ProfileFormData({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  /// Convert to JSON for storage/transmission
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }

  /// Create from JSON
  factory ProfileFormData.fromJson(Map<String, dynamic> json) {
    return ProfileFormData(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
    );
  }

  /// Copy with method for updates
  ProfileFormData copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
  }) {
    return ProfileFormData(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  String toString() =>
      'ProfileFormData(fullName: $fullName, email: $email, phoneNumber: $phoneNumber)';
}
