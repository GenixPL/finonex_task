import 'dart:io';

import 'package:finonex_task/deps/_deps.dart';
import 'package:finonex_task/models/_models.dart';
import 'package:finonex_task/services/_services.dart';
import 'package:http/http.dart';

class ModelDepsFactory {
  static ModelDeps live() {
    final String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:8080' : 'http://localhost:8080';
    final Client httpClient = Client();

    final authModel = AuthModelImpl(
      authStorage: AuthStorageInMemory(),
      authService: AuthService(
        httpClient,
        baseUrl: baseUrl,
      ),
    );

    final tickerModel = TickerModelImpl(
      service: TickerService(
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
      connectivityModel: ConnectivityModel(
        service: ConnectivityServiceLocal(),
      ),
    );
  }
}
