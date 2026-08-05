import 'package:finonex_task/deps/_deps.dart';
import 'package:finonex_task/models/_models.dart';

class ModelDepsFactory {
  static ModelDeps live() {
    return ModelDeps(
      authModel: AuthModelImpl(
        authStorage: AuthStorageInMemory(),
        authService: AuthService(
          _httpClient,
          baseUrl: baseUrl,
        ),
      ),
    );
  }
}
