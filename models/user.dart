class User {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final int role; // 0: User, 1: Admin

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      role: int.tryParse(json['role'].toString()) ?? 0,
    );
  }
}
