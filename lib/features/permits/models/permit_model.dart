import 'package:cloud_firestore/cloud_firestore.dart';

class PermitModel {
  final num amountPaid;
  final String borderPoint;
  final DateTime? createdAt;
  final String crossingDate;
  final String email;
  final String emergencyContact;
  final String endDate;
  final String fromCountry;
  final String fullName;
  final bool hasDiscount;
  final String nationality;
  final bool needsVisa;
  final String passportNumber;
  final String passportUrl;
  final String paymentStatus;
  final String permitId;
  final String startDate;
  final String status;
  final DateTime? submittedAt;
  final String toCountry;
  final DateTime? updatedAt;
  final String userId;
  final String visaUrl;
  final String? qrLocalPath;

  const PermitModel({
    required this.amountPaid,
    required this.borderPoint,
    required this.createdAt,
    required this.crossingDate,
    required this.email,
    required this.emergencyContact,
    required this.endDate,
    required this.fromCountry,
    required this.fullName,
    required this.hasDiscount,
    required this.nationality,
    required this.needsVisa,
    required this.passportNumber,
    required this.passportUrl,
    required this.paymentStatus,
    required this.permitId,
    required this.startDate,
    required this.status,
    required this.submittedAt,
    required this.toCountry,
    required this.updatedAt,
    required this.userId,
    required this.visaUrl,
    this.qrLocalPath,
  });

  factory PermitModel.fromMap(Map<String, dynamic> map) {
    return PermitModel(
      amountPaid: map['amountPaid'] ?? 0,
      borderPoint: (map['borderPoint'] ?? '') as String,
      createdAt: _toDateTime(map['createdAt']),
      crossingDate: (map['crossingDate'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      emergencyContact: (map['emergencyContact'] ?? '') as String,
      endDate: (map['endDate'] ?? '') as String,
      fromCountry: (map['fromCountry'] ?? '') as String,
      fullName: (map['fullName'] ?? '') as String,
      hasDiscount: (map['hasDiscount'] ?? false) as bool,
      nationality: (map['nationality'] ?? '') as String,
      needsVisa: (map['needsVisa'] ?? false) as bool,
      passportNumber: (map['passportNumber'] ?? '') as String,
      passportUrl: (map['passportUrl'] ?? '') as String,
      paymentStatus: (map['paymentStatus'] ?? 'unpaid') as String,
      permitId: (map['permitId'] ?? '') as String,
      startDate: (map['startDate'] ?? '') as String,
      status: (map['status'] ?? 'pending') as String,
      submittedAt: _toDateTime(map['submittedAt']),
      toCountry: (map['toCountry'] ?? '') as String,
      updatedAt: _toDateTime(map['updatedAt']),
      userId: (map['userId'] ?? '') as String,
      visaUrl: (map['visaUrl'] ?? '') as String,
      qrLocalPath: map['qrLocalPath'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amountPaid': amountPaid,
      'borderPoint': borderPoint,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'crossingDate': crossingDate,
      'email': email,
      'emergencyContact': emergencyContact,
      'endDate': endDate,
      'fromCountry': fromCountry,
      'fullName': fullName,
      'hasDiscount': hasDiscount,
      'nationality': nationality,
      'needsVisa': needsVisa,
      'passportNumber': passportNumber,
      'passportUrl': passportUrl,
      'paymentStatus': paymentStatus,
      'permitId': permitId,
      'startDate': startDate,
      'status': status,
      'submittedAt': submittedAt == null
          ? null
          : Timestamp.fromDate(submittedAt!),
      'toCountry': toCountry,
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'userId': userId,
      'visaUrl': visaUrl,
    };
  }

  PermitModel copyWith({
    num? amountPaid,
    String? borderPoint,
    DateTime? createdAt,
    String? crossingDate,
    String? email,
    String? emergencyContact,
    String? endDate,
    String? fromCountry,
    String? fullName,
    bool? hasDiscount,
    String? nationality,
    bool? needsVisa,
    String? passportNumber,
    String? passportUrl,
    String? paymentStatus,
    String? permitId,
    String? startDate,
    String? status,
    DateTime? submittedAt,
    String? toCountry,
    DateTime? updatedAt,
    String? userId,
    String? visaUrl,
    String? qrLocalPath,
  }) {
    return PermitModel(
      amountPaid: amountPaid ?? this.amountPaid,
      borderPoint: borderPoint ?? this.borderPoint,
      createdAt: createdAt ?? this.createdAt,
      crossingDate: crossingDate ?? this.crossingDate,
      email: email ?? this.email,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      endDate: endDate ?? this.endDate,
      fromCountry: fromCountry ?? this.fromCountry,
      fullName: fullName ?? this.fullName,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      nationality: nationality ?? this.nationality,
      needsVisa: needsVisa ?? this.needsVisa,
      passportNumber: passportNumber ?? this.passportNumber,
      passportUrl: passportUrl ?? this.passportUrl,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      permitId: permitId ?? this.permitId,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      toCountry: toCountry ?? this.toCountry,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      visaUrl: visaUrl ?? this.visaUrl,
      qrLocalPath: qrLocalPath ?? this.qrLocalPath,
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }
}
