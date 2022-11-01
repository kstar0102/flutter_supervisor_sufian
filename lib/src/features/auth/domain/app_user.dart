class AppToken {
  const AppToken({required this.token});

  final String token;

  @override
  String toString() => 'AppToken(token: $token)';
}

class AppUser {
  const AppUser({required this.uid, required this.username});

  final String uid;
  final String username;

  @override
  String toString() => 'AppUser(uid: $uid, email: $username)';
}
