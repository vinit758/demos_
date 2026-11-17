// widgets/product_card/product_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../data/products_data.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../common/common.dart';

void addToCart(BuildContext c, Product p, {String? variant, int qty = 1}) {
  c.read<CartProvider>().add(p, variant ?? p.variants.first, qty);
  ScaffoldMessenger.of(c).showSnackBar(SnackBar(
    content: Text('${p.name} added to your bag'),
    action: SnackBarAction(label: 'VIEW BAG', onPressed: () => c.go('/cart')),
  ));
}

class PriceText extends StatelessWidget {
  final Product p;
  final double size;
  const PriceText(this.p, {super.key, this.size = 16});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Text('₹${p.price}', style: sans(size, w: FontWeight.w500)),
        if (p.mrp != null) ...[
          const SizedBox(width: 8),
          Text('₹${p.mrp}', style: sans(size - 2, c: C.nude).copyWith(decoration: TextDecoration.lineThrough)),
        ],
      ]);
}

void quickView(BuildContext c, Product p) => showDialog(
      context: c,
      builder: (d) => Dialog(
        backgroundColor: C.ivory,
        shape: const RoundedRectangleBorder(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              ImgBox(tone: p.tone, aspect: 1.6, imageUrl: productPhoto(p.id)),
              const SizedBox(height: 16),
              Text(p.name, style: serif(30)),
              PriceText(p),
              const SizedBox(height: 10),
              Text(sampleDesc, style: sans(14)),
              const SizedBox(height: 20),
              Wrap(spacing: 12, runSpacing: 12, children: [
                Btn('Add to cart', () {
                  addToCart(c, p);
                  Navigator.pop(d);
                }),
                Btn('View details', () {
                  Navigator.pop(d);
                  c.go('/product/${p.id}');
                }, filled: false),
              ]),
            ]),
          ),
        ),
      ),
    );

class ProductCard extends StatefulWidget {
  final Product p;
  const ProductCard(this.p, {super.key});
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final wl = context.watch<WishlistProvider>();
    final liked = wl.has(p.id);
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          GestureDetector(
            onTap: () => context.go('/product/${p.id}'),
            child: ClipRect(
              child: AnimatedScale(scale: hover ? 1.06 : 1, duration: const Duration(milliseconds: 350), child: ImgBox(tone: p.tone, aspect: .8, imageUrl: productPhoto(p.id))),
            ),
          ),
          if (p.discount != null)
            Positioned(
              top: 10,
              left: 10,
              child: Container(color: C.gold, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), child: Text('-${p.discount}%', style: sans(11, c: C.ivory))),
            ),
          Positioned(
            top: 2,
            right: 2,
            child: IconButton(
              tooltip: liked ? 'Remove from wishlist' : 'Add to wishlist',
              icon: Icon(liked ? Icons.favorite : Icons.favorite_border, color: C.espresso),
              onPressed: () => wl.toggle(p.id),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: IconButton(tooltip: 'Quick view', icon: const Icon(Icons.visibility_outlined, color: C.espresso), onPressed: () => quickView(context, p)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: serif(20, w: FontWeight.w600)),
        const SizedBox(height: 2),
        PriceText(p, size: 15),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: C.espresso), shape: const RoundedRectangleBorder(), padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: () => addToCart(context, p),
            child: Text('ADD TO CART', style: sans(11, w: FontWeight.w500, ls: 1.5)),
          ),
        ),
      ]),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final List<Product> list;
  const ProductGrid(this.list, {super.key});
  @override
  Widget build(BuildContext context) {
    final cols = gridCols(context);
    return GridView.count(
      crossAxisCount: cols,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 28,
      crossAxisSpacing: 18,
      childAspectRatio: gridRatio(cols),
      children: [for (final p in list) ProductCard(p)],
    );
  }
}
