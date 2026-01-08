part of 'payments_cubit.dart';

abstract class PaymentsState extends Equatable {
  const PaymentsState();

  @override
  List<Object> get props => [];
}

class PaymentsInitial extends PaymentsState {}

class PaymentsLoading extends PaymentsState {}

class PaymentsGenerating extends PaymentsState {}

class PaymentsLoaded extends PaymentsState {
  final List<Payment> payments;

  const PaymentsLoaded(this.payments);

  @override
  List<Object> get props => [payments];
}

class PaymentsBankSlipGenerated extends PaymentsState {
  final String barcode;

  const PaymentsBankSlipGenerated(this.barcode);

  @override
  List<Object> get props => [barcode];
}

class PaymentsPixGenerated extends PaymentsState {
  final String pixKey;
  final String qrData;

  const PaymentsPixGenerated(this.pixKey, this.qrData);

  @override
  List<Object> get props => [pixKey, qrData];
}

class PaymentsError extends PaymentsState {
  final String message;

  const PaymentsError(this.message);

  @override
  List<Object> get props => [message];
}
