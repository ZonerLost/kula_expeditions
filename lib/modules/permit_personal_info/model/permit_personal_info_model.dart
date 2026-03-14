// permit_personal_info_model.dart

class PermitPersonalInfoModel {
  final String fullName;
  final String passportNumber;
  final String dateOfBirth;
  final String nationality;
  final String placeOfBirth;

  const PermitPersonalInfoModel({
    required this.fullName,
    required this.passportNumber,
    required this.dateOfBirth,
    required this.nationality,
    required this.placeOfBirth,
  });
}