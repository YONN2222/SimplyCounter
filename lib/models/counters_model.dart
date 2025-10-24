import 'package:flutter/foundation.dart';
import '../models/counter.dart';
import '../services/storage_service.dart';

class CountersModel extends ChangeNotifier {
  final StorageService storage;
  final List<CounterItem> _items = [];
  // simple id generator (timestamp + counter)
  int _idCounter = 0;

  CountersModel({required this.storage, List<CounterItem>? counters}) {
    if (counters != null) {
      _items.addAll(counters);
    }
  }

  List<CounterItem> get items => List.unmodifiable(_items);

  Future<void> _persist() async {
    await storage.saveCounters(_items);
  }

  Future<void> addCounter({required String name, int initial = 0}) async {
    final id = '${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';
    final newItem = CounterItem(id: id, name: name.trim(), value: initial);
    _items.insert(0, newItem);
    notifyListeners();
    await _persist();
  }

  Future<void> removeCounter(String id) async {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> increment(String id) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _items[i].value += 1;
    notifyListeners();
    await _persist();
  }

  Future<void> decrement(String id) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _items[i].value -= 1;
    notifyListeners();
    await _persist();
  }

  Future<void> adjustBy(String id, int delta) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _items[i].value += delta;
    notifyListeners();
    await _persist();
  }

  Future<void> reset(String id) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _items[i].value = 0;
    notifyListeners();
    await _persist();
  }

  Future<void> rename(String id, String newName) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _items[i].name = newName.trim();
    notifyListeners();
    await _persist();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    notifyListeners();
    await _persist();
  }
}
