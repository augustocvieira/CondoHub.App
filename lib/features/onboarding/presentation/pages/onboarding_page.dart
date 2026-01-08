import 'package:condo_hub_app/core/di/injection_container.dart';
import 'package:condo_hub_app/core/utils/validators.dart';
import 'package:condo_hub_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:condo_hub_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ServiceLocator.createOnboardingCubit()..checkExistingCondominium(),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  bool _showManualEntry = false;

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingSuccess) {
          context.go('/login');
        } else if (state is OnboardingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Icon(
                  Icons.apartment,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Bem-vindo ao condo_hub_app',
                  style: context.textStyles.headlineMedium?.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Identifique seu condomínio para começar',
                  style: context.textStyles.bodyLarge?.withColor(
                    Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    if (state is OnboardingLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (_showManualEntry) {
                      return _buildManualEntryForm(context);
                    }

                    return _buildQRScanButton(context);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                if (!_showManualEntry)
                  TextButton(
                    onPressed: () => setState(() => _showManualEntry = true),
                    child: const Text('Digitar chave manualmente'),
                  )
                else
                  TextButton(
                    onPressed: () => setState(() => _showManualEntry = false),
                    child: const Text('Escanear QR Code'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQRScanButton(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: () {
            context.read<OnboardingCubit>().identifyByQRCode('condo-1');
          },
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Escanear QR Code'),
          style: FilledButton.styleFrom(
            padding: AppSpacing.verticalMd + AppSpacing.horizontalLg,
          ),
        ),
      ],
    );
  }

  Widget _buildManualEntryForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _keyController,
            decoration: InputDecoration(
              labelText: 'Chave do Condomínio',
              hintText: 'Digite a chave de acesso do seu condomínio',
              prefixIcon: const Icon(Icons.key),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            textCapitalization: TextCapitalization.characters,
            validator: Validators.validateCondominiumKey,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context
                    .read<OnboardingCubit>()
                    .identifyByKey(_keyController.text);
              }
            },
            icon: const Icon(Icons.login),
            label: const Text('Continuar'),
            style: FilledButton.styleFrom(
              padding: AppSpacing.verticalMd + AppSpacing.horizontalLg,
            ),
          ),
        ],
      ),
    );
  }
}
