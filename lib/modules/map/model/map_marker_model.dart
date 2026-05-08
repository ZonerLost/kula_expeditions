class MapMarkerModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String categoryId;
  final double latitude;
  final double longitude;
  final String imagePath;
  final String imageUrl;
  final double top;
  final double left;
  final String checkpointImage;
  final String distance;
  final String estimatedTime;
  final bool isLocked;
  final bool isSelected;

  MapMarkerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.categoryId,
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    this.imageUrl = '',
    required this.top,
    required this.left,
    required this.checkpointImage,
    required this.distance,
    required this.estimatedTime,
    this.isLocked = false,
    this.isSelected = false,
  });

  MapMarkerModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? categoryId,
    double? latitude,
    double? longitude,
    String? imagePath,
    String? imageUrl,
    double? top,
    double? left,
    String? checkpointImage,
    String? distance,
    String? estimatedTime,
    bool? isLocked,
    bool? isSelected,
  }) {
    return MapMarkerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
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
