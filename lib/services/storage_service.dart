import 'package:shared_preferences/shared_preferences.dart';

import '../models/counter.dart';

class StorageService {
  static const _key = 'simplycounter:counters:v1';

  Future<List<CounterItem>> loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return <CounterItem>[];
    try {
      return CounterItem.listFromJson(raw);
    } catch (_) {
      // if parsing fails, reset storage to empty list
      await prefs.remove(_key);
      return <CounterItem>[];
    }
  }

  Future<void> saveCounters(List<CounterItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = CounterItem.listToJson(items);
    await prefs.setString(_key, raw);
  }
}
