class PoiCategoryModel {
  final String id;
  final String key;
  final String label;
  final String icon;
  final String status;

  const PoiCategoryModel({
    required this.id,
    required this.key,
    required this.label,
    required this.icon,
    required this.status,
  });

  factory PoiCategoryModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PoiCategoryModel(
      id: id,
      key: (data['key'] ?? '').toString().trim(),
      label: (data['label'] ?? '').toString().trim(),
      icon: (data['icon'] ?? '').toString().trim(),
      status: (data['status'] ?? 'inactive').toString().trim(),
    );
  }
}
