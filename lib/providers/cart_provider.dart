// providers/cart_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/products_data.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  List<CartItem> get items => _items.values.toList();
  int get count => _items.values.fold(0, (a, b) => a + b.qty);
  int get subtotal => _items.values.fold(0, (a, b) => a + b.total);

  Future<void> load() async {
    final raw = (await SharedPreferences.getInstance()).getString('cart');
    if (raw == null) return;
    try {
      for (final e in jsonDecode(raw) as List) {
        final p = productById(e['id'] as String);
        if (p != null) {
          final i = CartItem(p, e['v'] as String, e['q'] as int);
          _items[i.key] = i;
        }
      }
    } catch (_) {
      _items.clear();
    }
  }

  void add(Product p, String variant, int qty) {
    final k = '${p.id}|$variant';
    final ex = _items[k];
    if (ex != null) {
      ex.qty += qty;
    } else {
      _items[k] = CartItem(p, variant, qty);
    }
    _save();
  }

  void setQty(String key, int qty) {
    if (qty <= 0) {
      _items.remove(key);
    } else {
      _items[key]?.qty = qty;
    }
    _save();
  }

  void clear() {
    _items.clear();
    _save();
  }

  Future<void> _save() async {
    notifyListeners();
    final data = [for (final i in _items.values) {'id': i.product.id, 'v': i.variant, 'q': i.qty}];
    (await SharedPreferences.getInstance()).setString('cart', jsonEncode(data));
  }
}
