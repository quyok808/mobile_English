class CustomUser {
  final String uid;
  final String email;
  final String? dateOfBirth;
  final String? sex;

  CustomUser({
    required this.uid,
    required this.email,
    this.dateOfBirth,
    this.sex,
  });

  factory CustomUser.fromMap(Map<String, dynamic> data, String uid) {
    return CustomUser(
      uid: uid,
      email: data['email'] ?? 'Email not found',
      sex: data['sex'] ?? 'Not specified',
      dateOfBirth: data['dateOfBirth'] ?? 'Not specified',
    );
  }
}
