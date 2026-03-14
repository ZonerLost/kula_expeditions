class ContactDocumentsModel {
  final String email;
  final String emergencyContact;
  final bool needsVisa;
  final String? passportFileName;
  final String? visaFileName;

  ContactDocumentsModel({
    required this.email,
    required this.emergencyContact,
    required this.needsVisa,
    this.passportFileName,
    this.visaFileName,
  });
}