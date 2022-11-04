class Profile {
  Profile({
    required this.username,
    required this.profileImage,
    required this.nameEN,
    required this.phone,
    required this.birthday,
    required this.address,
    required this.workingHours,
    required this.totalDistance,
    required this.totalTrips,
  });

  final String username; // email
  final String profileImage;
  final String nameEN;
  final String phone;
  final String birthday;
  final String address;
  final double workingHours;
  final double totalDistance;
  final double totalTrips;

  Profile copyWith(
    String nameVal,
    String phoneVal,
    String birthdayVal,
    String addressVal,
  ) {
    return Profile(
        username: username,
        profileImage: profileImage,
        nameEN: nameVal,
        phone: phoneVal,
        birthday: birthdayVal,
        address: addressVal,
        workingHours: workingHours,
        totalDistance: totalDistance,
        totalTrips: totalTrips);
  }

  @override
  String toString() => 'Profile(username: $username, profile: $profileImage, '
      'nameEN: $nameEN, phone: $phone, birthday: $birthday, address: $address)';
}
