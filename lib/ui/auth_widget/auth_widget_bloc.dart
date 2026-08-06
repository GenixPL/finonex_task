import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finonex_task/models/auth/_auth.dart';

part 'auth_widget_event.dart';

class AuthWidgetBloc extends Bloc<AuthWidgetEvent, AuthState> {
  AuthWidgetBloc({
    required AuthModel authModel,
  }) : _authModel = authModel,
       super(authModel.stateStream.value) {
    on<Init>(_init);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthModel _authModel;

  Future<void> _init(
    Init event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach(
      _authModel.stateStream,
      onData: (state) => emit(state),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authModel.login();
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authModel.logout();
  }
}
