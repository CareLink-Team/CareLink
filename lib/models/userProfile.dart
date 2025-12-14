class UserProfile {
  final String userId;
  final String fullName;
  final String email;

  UserProfile({
    required this.userId,
    required this.fullName,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'],
      fullName: json['full_name'],
      email: json['email'] ?? '',
    );
  }
}
