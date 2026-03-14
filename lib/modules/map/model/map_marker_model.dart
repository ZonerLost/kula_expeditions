class MapMarkerModel {
  final String title;
  final String subtitle;
  final String imagePath;
  final double top;
  final double left;
  final String checkpointImage;
  final String distance;
  final String estimatedTime;
  final bool isLocked;
  final bool isSelected;

  MapMarkerModel({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.top,
    required this.left,
    required this.checkpointImage,
    required this.distance,
    required this.estimatedTime,
    this.isLocked = false,
    this.isSelected = false,
  });

  MapMarkerModel copyWith({
    String? title,
    String? subtitle,
    String? imagePath,
    double? top,
    double? left,
    String? checkpointImage,
    String? distance,
    String? estimatedTime,
    bool? isLocked,
    bool? isSelected,
  }) {
    return MapMarkerModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imagePath: imagePath ?? this.imagePath,
      top: top ?? this.top,
      left: left ?? this.left,
      checkpointImage: checkpointImage ?? this.checkpointImage,
      distance: distance ?? this.distance,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      isLocked: isLocked ?? this.isLocked,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}