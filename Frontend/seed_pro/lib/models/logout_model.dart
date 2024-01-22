class LogoutRequest {
  final String username;
  final String password;

  LogoutRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    };
  }
}
