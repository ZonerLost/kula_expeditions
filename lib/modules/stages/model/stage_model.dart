class StageModel {
  final String title;
  final String distance;
  final String estimatedTime;
  final String elevation;
  final String image;
  final bool isLocked;

  const StageModel({
    required this.title,
    required this.distance,
    required this.estimatedTime,
    required this.elevation,
    required this.image,
    required this.isLocked,
  });
}