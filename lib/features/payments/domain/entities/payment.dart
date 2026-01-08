import 'package:equatable/equatable.dart';

enum PaymentStatus { pending, paid, overdue }

enum PaymentType { monthly, oneTime }

class Payment extends Equatable {
  final String id;
  final String description;
  final double amount;
  final DateTime dueDate;
  final PaymentStatus status;
  final PaymentType type;
  final String? barcode;
  final String? pixKey;

  const Payment({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.type,
    this.barcode,
    this.pixKey,
  });

  Payment copyWith({
    String? id,
    String? description,
    double? amount,
    DateTime? dueDate,
    PaymentStatus? status,
    PaymentType? type,
    String? barcode,
    String? pixKey,
  }) {
    return Payment(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      type: type ?? this.type,
      barcode: barcode ?? this.barcode,
      pixKey: pixKey ?? this.pixKey,
    );
  }

  @override
  List<Object?> get props =>
      [id, description, amount, dueDate, status, type, barcode, pixKey];
}
