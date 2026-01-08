import 'package:condo_hub_app/features/payments/domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.description,
    required super.amount,
    required super.dueDate,
    required super.status,
    required super.type,
    super.barcode,
    super.pixKey,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${json['status']}',
        orElse: () => PaymentStatus.pending,
      ),
      type: PaymentType.values.firstWhere(
        (e) => e.toString() == 'PaymentType.${json['type']}',
        orElse: () => PaymentType.monthly,
      ),
      barcode: json['barcode'] as String?,
      pixKey: json['pixKey'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'type': type.toString().split('.').last,
      'barcode': barcode,
      'pixKey': pixKey,
    };
  }

  factory PaymentModel.fromEntity(Payment entity) {
    return PaymentModel(
      id: entity.id,
      description: entity.description,
      amount: entity.amount,
      dueDate: entity.dueDate,
      status: entity.status,
      type: entity.type,
      barcode: entity.barcode,
      pixKey: entity.pixKey,
    );
  }
}
