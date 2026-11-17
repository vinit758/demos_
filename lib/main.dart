// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cart = CartProvider(), wish = WishlistProvider();
  await Future.wait([cart.load(), wish.load()]);
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider.value(value: cart), ChangeNotifierProvider.value(value: wish)],
    child: const ReejApp(),
  ));
}
