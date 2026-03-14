class PermitPaymentModel {
  final String name;
  final String passportNumber;
  final String dates;
  final String entry;
  final String exit;

  final String permitFee;
  final String processingFee;
  final String gstTax;
  final String total;

  final String permitId;
  final String validity;
  final String deliveryAddress;
  final bool isPaid;

  PermitPaymentModel({
    required this.name,
    required this.passportNumber,
    required this.dates,
    required this.entry,
    required this.exit,
    required this.permitFee,
    required this.processingFee,
    required this.gstTax,
    required this.total,
    required this.permitId,
    required this.validity,
    required this.deliveryAddress,
    required this.isPaid,
  });
}