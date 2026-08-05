import 'dart:io';

import 'package:finonex_task/deps/_deps.dart';
import 'package:finonex_task/models/_models.dart';
import 'package:http/http.dart';

class ModelDepsFactory {
  static ModelDeps live() {
    return ModelDeps(
      authModel: AuthModelImpl(
        authStorage: AuthStorageInMemory(),
        authService: AuthService(
          Client(),
          // http://localhost:8080
          baseUrl: Platform.isAndroid ? 'http://10.0.2.2:8080' : throw UnsupportedError('wrong platform'),
        ),
      ),
      instrumentModel: InstrumentModelImpl(
        service: InstrumentServiceFake(),
      ),
      tickerModel: TickerModelImpl(),
    );
  }
}
