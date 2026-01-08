import 'package:condo_hub_app/features/auth/domain/entities/user.dart';
import 'package:condo_hub_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BiometricSetupDialog extends StatelessWidget {
  final User user;

  const BiometricSetupDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pop();
          context.go('/home');
        }
      },
      child: AlertDialog(
        icon: Icon(
          Icons.fingerprint,
          size: 56,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Ativar Login Biométrico'),
        content: const Text(
          'Deseja usar sua impressão digital ou reconhecimento facial para um login mais rápido no futuro?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(BiometricSetupSkipped(user));
            },
            child: const Text('Agora não'),
          ),
          FilledButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(BiometricSetupRequested(user.id));
            },
            icon: const Icon(Icons.fingerprint),
            label: const Text('Ativar'),
          ),
        ],
      ),
    );
  }
}
