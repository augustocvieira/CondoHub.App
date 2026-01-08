import 'package:condo_hub_app/features/payments/presentation/cubit/payments_cubit.dart';
import 'package:condo_hub_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentDetailsSheet extends StatelessWidget {
  const PaymentDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsCubit, PaymentsState>(
      builder: (context, state) {
        if (state is PaymentsBankSlipGenerated) {
          return _buildBankSlipSheet(context, state.barcode);
        }

        if (state is PaymentsPixGenerated) {
          return _buildPixSheet(context, state.pixKey, state.qrData);
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildBankSlipSheet(BuildContext context, String barcode) {
    return Container(
      padding: AppSpacing.paddingLg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Boleto Gerado',
            style: context.textStyles.titleLarge?.bold,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Copie o código de barras abaixo para efetuar o pagamento',
            style: context.textStyles.bodyMedium?.withColor(
              Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: SelectableText(
              barcode,
              style: context.textStyles.bodyMedium
                  ?.copyWith(fontFamily: 'monospace'),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: barcode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código de barras copiado')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<PaymentsCubit>().backToPayments();
                  },
                  child: const Text('Concluir'),
                ),
              ),
            ],
          ),
          SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildPixSheet(BuildContext context, String pixKey, String qrData) {
    return Container(
      padding: AppSpacing.paddingLg,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Pagamento PIX',
              style: context.textStyles.titleLarge?.bold,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Escaneie o QR code ou copie a chave PIX',
              style: context.textStyles.bodyMedium?.withColor(
                Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chave PIX',
                    style: context.textStyles.labelSmall?.withColor(
                      Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SelectableText(
                    pixKey,
                    style: context.textStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: pixKey));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chave PIX copiada')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copiar Chave'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<PaymentsCubit>().backToPayments();
                    },
                    child: const Text('Concluir'),
                  ),
                ),
              ],
            ),
            SizedBox(
                height:
                    MediaQuery.of(context).viewInsets.bottom + AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
