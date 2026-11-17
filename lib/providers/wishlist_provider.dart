import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<String> _ids = {};
  bool has(String id) => _ids.contains(id);

  Future<void> load() async {
    _ids.addAll((await SharedPreferences.getInstance()).getStringList('wishlist') ?? []);
  }

  Future<void> toggle(String id) async {
    _ids.contains(id) ? _ids.remove(id) : _ids.add(id);
    notifyListeners();
    (await SharedPreferences.getInstance()).setStringList('wishlist', _ids.toList());
  }
}
