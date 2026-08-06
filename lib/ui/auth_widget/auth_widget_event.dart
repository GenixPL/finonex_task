part of 'auth_widget_bloc.dart';

sealed class AuthWidgetEvent extends Equatable {
  const AuthWidgetEvent();

  @override
  List<Object> get props => [];
}

class Init extends AuthWidgetEvent {}

class LoginRequested extends AuthWidgetEvent {}

class LogoutRequested extends AuthWidgetEvent {}
