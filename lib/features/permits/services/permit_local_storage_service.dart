import 'package:shared_preferences/shared_preferences.dart';

class PermitLocalStorageService {
  static const String _permitIdsKey = 'my_permit_ids';

  Future<void> savePermitId(String permitId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentIds = prefs.getStringList(_permitIdsKey) ?? <String>[];
    if (!currentIds.contains(permitId)) {
      currentIds.add(permitId);
      await prefs.setStringList(_permitIdsKey, currentIds);
    }
  }

  Future<List<String>> getPermitIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_permitIdsKey) ?? <String>[];
  }

  Future<void> removePermitId(String permitId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentIds = prefs.getStringList(_permitIdsKey) ?? <String>[];
    currentIds.remove(permitId);
    await prefs.setStringList(_permitIdsKey, currentIds);
  }

  Future<void> clearPermitIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_permitIdsKey);
  }

  Future<void> saveQrLocalPath(String permitId, String localPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_qrPathKey(permitId), localPath);
  }

  Future<String?> getQrLocalPath(String permitId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_qrPathKey(permitId));
  }

  String _qrPathKey(String permitId) => 'permit_qr_path_$permitId';
}
