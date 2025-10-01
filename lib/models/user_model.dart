class User {
  final String id;
  final String name;
  final String email;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'USER',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  bool get isAdmin => role == 'ADMIN';
  bool get isUser => role == 'USER';
}

class AuthResponse {
  final String token;
  final User? user;

  AuthResponse({
    required this.token,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      // CORREÇÃO: Use o operador de coalescência nula corretamente
      token: json['token']?.toString() ?? '',
      // A resposta do login não tem "user", então deixamos como null
      user: null,
    );
  }
}