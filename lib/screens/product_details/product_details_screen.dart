// screens/product_details/product_details_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../data/products_data.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/common/common.dart';
import '../../widgets/navbar/shell.dart';
import '../../widgets/product_card/product_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String id;
  const ProductDetailsScreen({super.key, required this.id});
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int img = 0, qty = 1;
  String? variant;

  Widget _info(String h, String b) => Padding(
        padding: const EdgeInsets.only(top: 22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(h, style: serif(24, w: FontWeight.w600)), const SizedBox(height: 4), Text(b, style: sans(14))]),
      );

  @override
  Widget build(BuildContext context) {
    final p = productById(widget.id);
    if (p == null) {
      return Shell(
        title: 'Product not found',
        child: Sec(child: Column(children: [Text("We couldn't find that product.", style: serif(32)), const SizedBox(height: 20), Btn('Back to shop', () => context.go('/shop'))])),
      );
    }
    final v = variant ?? p.variants.first;
    final m = isMobile(context);
    final wl = context.watch<WishlistProvider>();
    Color tone(int i) => Color.lerp(p.tone, Colors.white, i * .25)!;
    final gallery = Column(children: [
      ImgBox(tone: tone(img), aspect: .9, imageUrl: reejPhotos[((int.tryParse(p.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1) + img) % reejPhotos.length]),
      const SizedBox(height: 10),
      Row(children: [
        for (var i = 0; i < 3; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 2 ? 10 : 0),
              child: GestureDetector(
                onTap: () => setState(() => img = i),
                child: Container(decoration: BoxDecoration(border: Border.all(color: img == i ? C.gold : Colors.transparent, width: 2)), child: ImgBox(tone: tone(i), imageUrl: reejPhotos[((int.tryParse(p.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1) + i) % reejPhotos.length])),
              ),
            ),
          ),
      ]),
    ]);
    final info = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(p.category.toUpperCase(), style: sans(11, c: C.gold, ls: 2, w: FontWeight.w500)),
      Text(p.name, style: serif(m ? 36 : 52)),
      const SizedBox(height: 8),
      PriceText(p, size: 22),
      const SizedBox(height: 16),
      Text(sampleDesc, style: sans(15)),
      const SizedBox(height: 22),
      Text('Variant', style: sans(13, w: FontWeight.w500)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: [for (final x in p.variants) ChoiceChip(label: Text(x), selected: v == x, onSelected: (_) => setState(() => variant = x))]),
      const SizedBox(height: 18),
      Row(children: [
        IconButton(tooltip: 'Decrease quantity', icon: const Icon(Icons.remove), onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1)),
        Text('$qty', style: sans(18)),
        IconButton(tooltip: 'Increase quantity', icon: const Icon(Icons.add), onPressed: () => setState(() => qty++)),
      ]),
      const SizedBox(height: 12),
      Wrap(spacing: 12, runSpacing: 12, children: [
        Btn('Add to cart', () => addToCart(context, p, variant: v, qty: qty)),
        Btn(wl.has(p.id) ? 'Wishlisted' : 'Add to wishlist', () => wl.toggle(p.id), filled: false),
      ]),
      _info('Product details', 'Sample details. Add materials, dimensions and care instructions here.'),
      _info('Delivery', 'Delivery timelines and charges will be confirmed by Reej before launch.'),
    ]);
    final related = [...products.where((x) => x.id != p.id && x.category == p.category), ...products.where((x) => x.id != p.id && x.category != p.category)].take(4).toList();
    return Shell(
      title: p.name,
      child: Column(children: [
        Sec(child: twoCol(context, gallery, info, align: CrossAxisAlignment.start)),
        Sec(color: C.cream, child: Column(children: [const SectionTitle('You May Also Like'), ProductGrid(related)])),
      ]),
    );
  }
}
