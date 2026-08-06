import 'package:finonex_task/models/auth/_auth.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthModel {
  ValueStream<AuthState> get stateStream;

  /// Logs user in.
  ///
  /// Returns `null` if everything is fine.
  /// Returns error String if something goes wrong.
  Future<String?> login();

  Future<void> logout();

  /// Attempts to return a valid token.
  ///
  /// TODO(genix): split not logged it from wrong
  /// Returns `null` if user is not logged in or something went wrong.
  /// Returns valid token String if everything is fine.
  Future<String?> getToken();
}
