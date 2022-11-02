class Profile {
  const Profile({
    required this.profileImage,
    required this.nameEN,
    required this.phone,
    required this.birthday,
    required this.address,
  });

  final String profileImage;
  final String nameEN;
  final String phone;
  final String birthday;
  final String address;

  @override
  String toString() =>
      '$profileImage - $nameEN - $phone - $birthday - $address';
}

class AppUser {
  const AppUser({
    required this.token,
    this.uid = '',
    this.username = '',
    this.profile,
  });

  final String token;
  final String uid;
  final String username; // email
  final Profile? profile;

  bool isLogined() => token.isNotEmpty && uid.isNotEmpty;

  AppUser copyWith({
    String? token,
    String? uid,
    String? username,
    Profile? profile,
  }) {
    return AppUser(
      token: token ?? this.token,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      profile: profile ?? this.profile,
    );
  }

  @override
  String toString() => 'AppUser(token: $token, uid: $uid, email: $username)';
}
