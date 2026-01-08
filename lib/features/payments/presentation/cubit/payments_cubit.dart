import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/features/payments/domain/entities/payment.dart';
import 'package:condo_hub_app/features/payments/domain/repositories/payment_repository.dart';
import 'package:condo_hub_app/features/payments/domain/usecases/generate_pix.dart';
import 'package:condo_hub_app/features/payments/domain/usecases/get_payments.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  final GetPayments getPayments;
  final GeneratePixKey generatePixKey;
  final GeneratePixQRCode generatePixQRCode;
  final PaymentRepository repository;

  PaymentsCubit({
    required this.getPayments,
    required this.generatePixKey,
    required this.generatePixQRCode,
    required this.repository,
  }) : super(PaymentsInitial());

  Future<void> loadPayments() async {
    emit(PaymentsLoading());

    final result = await getPayments(NoParams());

    result.fold(
      (failure) => emit(PaymentsError(failure.message)),
      (payments) => emit(PaymentsLoaded(payments)),
    );
  }

  Future<void> generateBankSlipForPayment(String paymentId) async {
    emit(PaymentsGenerating());

    final result = await repository.generateBankSlip(paymentId);

    result.fold(
      (failure) => emit(PaymentsError(failure.message)),
      (barcode) => emit(PaymentsBankSlipGenerated(barcode)),
    );
  }

  Future<void> generatePixForPayment(String paymentId) async {
    emit(PaymentsGenerating());

    final keyResult = await generatePixKey(GeneratePixParams(paymentId));
    final qrResult = await generatePixQRCode(GeneratePixParams(paymentId));

    keyResult.fold(
      (failure) => emit(PaymentsError(failure.message)),
      (pixKey) {
        qrResult.fold(
          (failure) => emit(PaymentsError(failure.message)),
          (qrData) => emit(PaymentsPixGenerated(pixKey, qrData)),
        );
      },
    );
  }

  void backToPayments() async {
    await loadPayments();
  }
}
