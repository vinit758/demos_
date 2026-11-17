import 'package:flutter/material.dart';

class Product {
  final String id, name, category;
  final int price, order;
  final int? mrp;
  final List<String> variants;
  final bool best;
  final Color tone;
  const Product(this.id, this.name, this.category, this.price, this.mrp, this.order, this.variants, this.best, this.tone);
  int? get discount => mrp == null ? null : (((mrp! - price) / mrp!) * 100).round();
}

class Category {
  final String name, blurb;
  final Color tone;
  const Category(this.name, this.blurb, this.tone);
}

class CartItem {
  final Product product;
  final String variant;
  int qty;
  CartItem(this.product, this.variant, this.qty);
  String get key => '${product.id}|$variant';
  int get total => product.price * qty;
}
