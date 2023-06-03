import 'dart:convert';

extension SupabaseExt on Future<dynamic> {
  Future<List<dynamic>> toSelect() async {
    final encoded = jsonEncode(await this);
    return await jsonDecode(encoded);
  }
}
