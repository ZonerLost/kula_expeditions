class UnlockAccessModel {
  final String code;
  final String couponCode;
  final String exitCountry;
  final bool trailsUnlocked;
  final bool poisAvailable;
  final String permitDiscount;

  UnlockAccessModel({
    required this.code,
    required this.couponCode,
    required this.exitCountry,
    required this.trailsUnlocked,
    required this.poisAvailable,
    required this.permitDiscount,
  });
}