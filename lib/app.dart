import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme.dart';
import 'screens/about/about_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/contact/contact_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/product_details/product_details_screen.dart';
import 'screens/shop/shop_screen.dart';

Page<void> _pg(GoRouterState s, Widget w) =>
    CustomTransitionPage<void>(key: s.pageKey, child: w, transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c));

final _router = GoRouter(routes: [
  GoRoute(path: '/', pageBuilder: (c, s) => _pg(s, const HomeScreen())),
  GoRoute(path: '/shop', pageBuilder: (c, s) => _pg(s, ShopScreen(cat: s.uri.queryParameters['cat']))),
  GoRoute(path: '/collections', pageBuilder: (c, s) => _pg(s, const CollectionsScreen())),
  GoRoute(path: '/product/:id', pageBuilder: (c, s) => _pg(s, ProductDetailsScreen(key: ValueKey(s.pathParameters['id']), id: s.pathParameters['id']!))),
  GoRoute(path: '/cart', pageBuilder: (c, s) => _pg(s, const CartScreen())),
  GoRoute(path: '/checkout', pageBuilder: (c, s) => _pg(s, const CheckoutScreen())),
  GoRoute(path: '/about', pageBuilder: (c, s) => _pg(s, const AboutScreen())),
  GoRoute(path: '/contact', pageBuilder: (c, s) => _pg(s, const ContactScreen())),
]);

class ReejApp extends StatelessWidget {
  const ReejApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Reej – Styled for You',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        routerConfig: _router,
      );
}
