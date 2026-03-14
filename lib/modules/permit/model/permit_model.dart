// lib/modules/permit/model/permit_model.dart

class PermitModel {
  final String title;
  final String description;
  final String buttonText;
  final String footerText;
  final String image;

  const PermitModel({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.footerText,
    required this.image,
  });
}