class Authentication {
  final String userId;
  final String email;
  final String password;
  final String role;
  final String linkedId;

  Authentication({
    required this.userId,
    required this.email,
    required this.password,
    required this.role,
    required this.linkedId,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) {
    return Authentication(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      linkedId: json['linked_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'email': email,
    'password': password,
    'role': role,
    'linked_id': linkedId,
  };

  @override
  String toString() => 'Auth(User: $email, Role: $role)';
}
