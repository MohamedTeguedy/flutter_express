// lib/models/user.dart
class User {
  final String id;
  final String username;
  final String
      password; // Note: Ne stockez jamais le mot de passe en clair dans une application réelle

  User({required this.id, required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      password: json['password'],
    );
  }
  factory User.toJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      password: json['password'],
    );
  }
}
