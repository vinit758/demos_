// widgets/navbar/shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/cart_provider.dart';
import '../common/common.dart';

const _links = [('Home', '/'), ('Shop', '/shop'), ('Collections', '/collections'), ('About Us', '/about'), ('Contact', '/contact')];

class Shell extends StatelessWidget {
  final String title;
  final Widget child;
  const Shell({super.key, required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Title(
        title: '$title | Reej – Styled for You',
        color: C.espresso,
        child: Scaffold(
          endDrawer: isMobile(context) ? const _Drawer() : null,
          body: Column(children: [
            Container(
              width: double.infinity,
              color: C.espresso,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('Discover Your Style  |  Elegance in Every Detail', textAlign: TextAlign.center, style: sans(11, c: C.champagne, ls: 2)),
            ),
            const _Nav(),
            Expanded(child: SingleChildScrollView(child: Column(children: [child, const _Footer()]))),
          ]),
        ),
      );
}

class _Nav extends StatelessWidget {
  const _Nav();
  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    final cart = context.watch<CartProvider>();
    final bag = IconButton(
      tooltip: 'Shopping bag',
      onPressed: () => context.go('/cart'),
      icon: Badge(label: Text('${cart.count}'), isLabelVisible: cart.count > 0, backgroundColor: C.gold, child: const Icon(Icons.shopping_bag_outlined, color: C.espresso)),
    );
    return Container(
      decoration: const BoxDecoration(color: C.ivory, border: Border(bottom: BorderSide(color: C.champagne))),
      padding: EdgeInsets.symmetric(horizontal: m ? 8 : 40, vertical: 6),
      child: m
          ? Row(children: [
              IconButton(tooltip: 'Menu', icon: const Icon(Icons.menu, color: C.espresso), onPressed: () => Scaffold.of(context).openEndDrawer()),
              Expanded(child: GestureDetector(onTap: () => context.go('/'), child: const Logo(size: 34))),
              bag,
            ])
          : Row(children: [
              GestureDetector(onTap: () => context.go('/'), child: const MouseRegion(cursor: SystemMouseCursors.click, child: Logo(size: 40))),
              const Spacer(),
              for (final l in _links) _NavLink(l.$1, l.$2),
              const Spacer(),
              IconButton(tooltip: 'Instagram', icon: const Icon(Icons.camera_alt_outlined, color: C.espresso), onPressed: () => openUrl(instaUrl)),
              bag,
            ]),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label, path;
  const _NavLink(this.label, this.path);
  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    final active = GoRouterState.of(context).uri.path == widget.path;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () => context.go(widget.path),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(widget.label.toUpperCase(), style: sans(12, ls: 2, w: FontWeight.w500)),
            const SizedBox(height: 4),
            AnimatedContainer(duration: const Duration(milliseconds: 250), height: 1, width: hover || active ? 28 : 0, color: C.gold),
          ]),
        ),
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer();
  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: C.ivory,
        child: ListView(padding: const EdgeInsets.all(24), children: [
          const Center(child: Logo(size: 44)),
          const SizedBox(height: 24),
          for (final l in _links)
            ListTile(
              title: Text(l.$1.toUpperCase(), style: sans(13, ls: 2, w: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
                context.go(l.$2);
              },
            ),
          ListTile(title: Text('INSTAGRAM', style: sans(13, ls: 2, w: FontWeight.w500)), onTap: () => openUrl(instaUrl)),
        ]),
      );
}

class _Footer extends StatelessWidget {
  const _Footer();
  Widget _col(BuildContext c, String h, List<Widget> kids) => SizedBox(
        width: isMobile(c) ? double.infinity : 220,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(h.toUpperCase(), style: sans(12, c: C.gold, ls: 2, w: FontWeight.w500)),
          const SizedBox(height: 12),
          ...kids,
        ]),
      );
  Widget _l(BuildContext c, String t, String path) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(onTap: () => c.go(path), child: Text(t, style: sans(14, c: C.champagne))),
      );
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: C.charcoal,
        padding: const EdgeInsets.symmetric(vertical: 56),
        child: Frame(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 48, runSpacing: 32, children: [
              SizedBox(
                width: 260,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Logo(size: 44, color: C.champagne),
                  const SizedBox(height: 12),
                  Text('Elegance in every detail. Styled for you.', style: sans(14, c: C.champagne)),
                ]),
              ),
              _col(context, 'Quick links', [_l(context, 'Home', '/'), _l(context, 'About Us', '/about'), _l(context, 'Contact', '/contact')]),
              _col(context, 'Shopping', [_l(context, 'Shop', '/shop'), _l(context, 'Collections', '/collections'), _l(context, 'Shopping bag', '/cart')]),
              _col(context, 'Visit us', [
                Text(address, style: sans(14, c: C.champagne)),
                const SizedBox(height: 8),
                InkWell(onTap: () => openUrl(instaUrl), child: Text('@reej.styledforyou', style: sans(14, c: C.gold))),
              ]),
            ]),
            const SizedBox(height: 40),
            Text('© 2026 Reej – Styled for You. All rights reserved.', style: sans(12, c: C.nude)),
          ]),
        ),
      );
}
