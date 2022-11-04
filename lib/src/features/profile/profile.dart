class Profile {
  const Profile({
    required this.username,
    required this.profileImage,
    required this.nameEN,
    required this.phone,
    required this.birthday,
    required this.address,
  });

  final String username; // email
  final String profileImage;
  final String nameEN;
  final String phone;
  final String birthday;
  final String address;

  @override
  String toString() => 'Profile(username: $username, profile: $profileImage, '
      'nameEN: $nameEN, phone: $phone, birthday: $birthday, address: $address)';
}
