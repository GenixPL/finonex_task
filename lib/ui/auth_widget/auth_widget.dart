import 'package:finonex_task/main.dart';
import 'package:finonex_task/models/auth/model/auth_state.dart';
import 'package:finonex_task/ui/auth_widget/auth_widget_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthWidgetBloc(
        authModel: modelDeps.authModel,
      )..add(Init()),
      child: BlocBuilder<AuthWidgetBloc, AuthState>(
        builder: (context, state) {
          return Row(
            children: [
              switch (state) {
                AuthState.noUser => const Icon(
                  Icons.output_rounded,
                  color: Colors.redAccent,
                ),
                AuthState.user => const Icon(
                  Icons.input_rounded,
                  color: Colors.green,
                ),
              },
              IconButton(
                icon: const Icon(Icons.input_rounded),
                onPressed: () {
                  context.read<AuthWidgetBloc>().add(LoginRequested());
                },
              ),
              IconButton(
                icon: const Icon(Icons.output_rounded),
                onPressed: () {
                  context.read<AuthWidgetBloc>().add(LogoutRequested());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
