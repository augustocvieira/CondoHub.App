import 'package:condo_hub_app/core/di/injection_container.dart';
import 'package:condo_hub_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:condo_hub_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:condo_hub_app/features/dashboard/presentation/pages/dashboard_tab.dart';
import 'package:condo_hub_app/features/messages/presentation/cubit/messages_cubit.dart';
import 'package:condo_hub_app/features/messages/presentation/pages/messages_tab.dart';
import 'package:condo_hub_app/features/payments/presentation/cubit/payments_cubit.dart';
import 'package:condo_hub_app/features/payments/presentation/pages/payments_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                ServiceLocator.createAuthBloc()..add(const CheckAuthStatus())),
        BlocProvider(
            create: (_) =>
                ServiceLocator.createDashboardCubit()..loadAnnouncements()),
        BlocProvider(
            create: (_) =>
                ServiceLocator.createPaymentsCubit()..loadPayments()),
        BlocProvider(
            create: (_) =>
                ServiceLocator.createMessagesCubit()..loadMessages()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            context.go('/');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(_getTitle()),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(const LogoutRequested());
                },
              ),
            ],
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: const [
              DashboardTab(),
              PaymentsTab(),
              MessagesTab(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Início',
              ),
              NavigationDestination(
                icon: Icon(Icons.payment_outlined),
                selectedIcon: Icon(Icons.payment),
                label: 'Pagamentos',
              ),
              NavigationDestination(
                icon: Icon(Icons.message_outlined),
                selectedIcon: Icon(Icons.message),
                label: 'Mensagens',
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Início';
      case 1:
        return 'Pagamentos';
      case 2:
        return 'Mensagens';
      default:
        return 'condo_hub_app';
    }
  }
}
