class PermitRequestModel {
  final String fullName;
  final String passportNumber;
  final String nationality;
  final String startDate;
  final String endDate;
  final String crossingDate;
  final String fromCountry;
  final String toCountry;
  final String borderPoint;
  final String email;
  final String emergencyContact;
  final bool needsVisa;
  final bool hasDiscount;
  final num amountPaid;
  final String paymentStatus;
  final String passportUrl;
  final String visaUrl;
  final String userId;
  final String status;

  const PermitRequestModel({
    required this.fullName,
    required this.passportNumber,
    required this.nationality,
    required this.startDate,
    required this.endDate,
    required this.crossingDate,
    required this.fromCountry,
    required this.toCountry,
    required this.borderPoint,
    required this.email,
    required this.emergencyContact,
    required this.needsVisa,
    required this.hasDiscount,
    required this.amountPaid,
    required this.paymentStatus,
    required this.passportUrl,
    required this.visaUrl,
    required this.userId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'passportNumber': passportNumber,
      'nationality': nationality,
      'startDate': startDate,
      'endDate': endDate,
      'crossingDate': crossingDate,
      'fromCountry': fromCountry,
      'toCountry': toCountry,
      'borderPoint': borderPoint,
      'email': email,
      'emergencyContact': emergencyContact,
      'needsVisa': needsVisa,
      'hasDiscount': hasDiscount,
      'amountPaid': amountPaid,
      'paymentStatus': paymentStatus,
      'passportUrl': passportUrl,
      'visaUrl': visaUrl,
      'userId': userId,
      'status': status,
    };
  }
}
