class OnboardingModel {
  final String title;
  final String description;
  final String buttonText;
  final String? secondaryButtonText;
  final bool showProgress;
  final bool showFooterText;
  final bool showOpenMapButton;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.buttonText,
    this.secondaryButtonText,
    this.showProgress = false,
    this.showFooterText = false,
    this.showOpenMapButton = false,
  });
}
