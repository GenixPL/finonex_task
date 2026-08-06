import 'dart:io';

import 'package:finonex_task/deps/_deps.dart';
import 'package:finonex_task/models/auth/_auth.dart';
import 'package:finonex_task/models/instrument/_instrument.dart';
import 'package:finonex_task/models/ticker/_ticker.dart';
import 'package:finonex_task/services/connectivity/_connectivity.dart';
import 'package:finonex_task/services/secure_storage/_secure_storage.dart';
import 'package:http/http.dart';

class ModelDepsFactory {
  static ModelDeps live() {
    final String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:8080' : 'http://localhost:8080';
    final Client httpClient = Client();

    final SecureStorage secureStorage = SecureStorageLocal();
    final ConnectivityService connectivityService = ConnectivityServiceLocal();

    final authModel = AuthModelImpl(
      // authStorage: AuthStorageInMemory(),
      authStorage: AuthStorageSecure(
        secureStorage: secureStorage,
      ),
      authService: AuthService(
        httpClient,
        baseUrl: baseUrl,
      ),
    );

    final tickerModel = TickerModelImpl(
      authModel: authModel,
      connectivityService: connectivityService,
      tickerService: TickerService(
        client: httpClient,
        baseUrl: baseUrl,
        authModel: authModel,
      ),
    );

    return ModelDeps(
      authModel: authModel,
      instrumentModel: InstrumentModelImpl(
        service: InstrumentServiceFake(),
      ),
      tickerModel: tickerModel,
    );
  }

  static ModelDeps test() {
    // TODO(genix): build for integration tests
    throw UnimplementedError();
  }
}
