import 'package:alnabali_driver/src/features/auth/domain/app_user.dart';
import 'package:alnabali_driver/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final _tokenState = InMemoryStore<AppToken?>(null);
  final _userState = InMemoryStore<AppUser?>(null);

  Stream<AppToken?> tokenStateChanges() => _tokenState.stream;
  AppToken? get currentToken => _tokenState.value;

  Stream<AppUser?> userStateChanges() => _userState.stream;
  AppUser? get currentUser => _userState.value;

  Future<void> fetchToken() async {
    await Future.delayed(const Duration(seconds: 2));

    _tokenState.value = const AppToken(token: 'fake-token');
  }

  Future<void> logIn(String username, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    _userState.value = const AppUser(uid: '0', username: 'fake-user');
  }

  Future<void> resetPassword(String newPassword) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  void dispose() {
    _tokenState.close();
    _userState.close();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = AuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});
