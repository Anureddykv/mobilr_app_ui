class AuthRequestModel {
  String username;
  String password;
  int appversion;
  AuthRequestModel({
    required this.username,
    required this.password,
    this.appversion = 0,
  });
  factory AuthRequestModel.fromJson(Map<String, dynamic> json) {
    return AuthRequestModel(
      username: json['username'],
      password: json['password'],
      appversion: json['app_version'],
    );
  }
  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'app_version': appversion,
  };
}
