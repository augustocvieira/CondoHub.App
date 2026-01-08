import 'package:condo_hub_app/core/utils/date_formatter.dart';
import 'package:condo_hub_app/features/payments/domain/entities/payment.dart';
import 'package:condo_hub_app/features/payments/presentation/cubit/payments_cubit.dart';
import 'package:condo_hub_app/features/payments/presentation/widgets/payments_details_sheet.dart';
import 'package:condo_hub_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentsCubit, PaymentsState>(
      listener: (context, state) {
        if (state is PaymentsBankSlipGenerated ||
            state is PaymentsPixGenerated) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: context.read<PaymentsCubit>(),
              child: const PaymentDetailsSheet(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is PaymentsLoading || state is PaymentsGenerating) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PaymentsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 64, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: AppSpacing.md),
                Text(state.message, style: context.textStyles.bodyLarge),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () => context.read<PaymentsCubit>().loadPayments(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        if (state is PaymentsLoaded) {
          if (state.payments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: AppSpacing.md),
                  Text('Nenhum pagamento disponível',
                      style: context.textStyles.bodyLarge),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<PaymentsCubit>().loadPayments(),
            child: ListView.separated(
              padding: AppSpacing.paddingMd,
              itemCount: state.payments.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final payment = state.payments[index];
                return PaymentCard(payment: payment);
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class PaymentCard extends StatelessWidget {
  final Payment payment;

  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final isPending = payment.status == PaymentStatus.pending;
    final isPaid = payment.status == PaymentStatus.paid;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    payment.description,
                    style: context.textStyles.titleMedium?.semiBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(context).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    _getStatusLabel(),
                    style: context.textStyles.labelSmall?.copyWith(
                      color: _getStatusColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Vencimento: ${DateFormatter.formatDate(payment.dueDate)}',
                  style: context.textStyles.bodySmall?.withColor(
                    Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormatter.formatCurrency(payment.amount),
                  style: context.textStyles.headlineSmall?.bold.withColor(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (isPending)
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () {
                          context
                              .read<PaymentsCubit>()
                              .generateBankSlipForPayment(payment.id);
                        },
                        icon: const Icon(Icons.receipt_long, size: 18),
                        label: const Text('Boleto'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          context
                              .read<PaymentsCubit>()
                              .generatePixForPayment(payment.id);
                        },
                        icon: const Icon(Icons.qr_code, size: 18),
                        label: const Text('PIX'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  )
                else if (isPaid)
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    switch (payment.status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.paid:
        return Colors.green;
      case PaymentStatus.overdue:
        return Theme.of(context).colorScheme.error;
    }
  }

  String _getStatusLabel() {
    switch (payment.status) {
      case PaymentStatus.pending:
        return 'PENDENTE';
      case PaymentStatus.paid:
        return 'PAGO';
      case PaymentStatus.overdue:
        return 'VENCIDO';
    }
  }
}
