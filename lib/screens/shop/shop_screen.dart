import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../data/products_data.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/common/common.dart';
import '../../widgets/navbar/shell.dart';
import '../../widgets/product_card/product_card.dart';

class ShopScreen extends StatefulWidget {
  final String? cat;
  const ShopScreen({super.key, this.cat});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String? cat;
  double maxP = 2000;
  String sort = 'Newest', q = '';
  bool wishOnly = false;
  @override
  void initState() {
    super.initState();
    cat = widget.cat;
  }

  @override
  void didUpdateWidget(ShopScreen old) {
    super.didUpdateWidget(old);
    if (old.cat != widget.cat) cat = widget.cat;
  }

  @override
  Widget build(BuildContext context) {
    final wl = context.watch<WishlistProvider>();
    final m = isMobile(context);
    final list = products
        .where((p) => (cat == null || p.category == cat) && p.price <= maxP && p.name.toLowerCase().contains(q.toLowerCase()) && (!wishOnly || wl.has(p.id)))
        .toList();
    if (sort == 'Newest') {
      list.sort((a, b) => a.order.compareTo(b.order));
    } else if (sort == 'Price: Low to High') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else {
      list.sort((a, b) => b.price.compareTo(a.price));
    }
    return Shell(
      title: 'Shop',
      child: Sec(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionTitle('Shop', sub: 'Sample products and prices shown for demonstration only.'),
          Wrap(spacing: 16, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: [
            SizedBox(
              width: m ? double.infinity : 300,
              child: TextField(
                onChanged: (v) => setState(() => q = v),
                decoration: const InputDecoration(hintText: 'Search products', prefixIcon: Icon(Icons.search), isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
              ),
            ),
            DropdownButton<String>(
              value: sort,
              underline: const SizedBox(),
              items: [for (final s in ['Newest', 'Price: Low to High', 'Price: High to Low']) DropdownMenuItem(value: s, child: Text(s, style: sans(14)))],
              onChanged: (v) => setState(() => sort = v!),
            ),
            FilterChip(label: const Text('Wishlist only'), selected: wishOnly, onSelected: (v) => setState(() => wishOnly = v)),
          ]),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ChoiceChip(label: const Text('All'), selected: cat == null, onSelected: (_) => setState(() => cat = null)),
            for (final k in categories) ChoiceChip(label: Text(k.name), selected: cat == k.name, onSelected: (_) => setState(() => cat = k.name)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Text('Up to ₹${maxP.round()}', style: sans(14)),
            SizedBox(width: 260, child: Slider(value: maxP, min: 0, max: 2000, divisions: 20, activeColor: C.gold, onChanged: (v) => setState(() => maxP = v))),
          ]),
          const SizedBox(height: 16),
          if (list.isEmpty)
            Center(
              child: Column(children: [
                Text('No products match your filters.', style: serif(26)),
                const SizedBox(height: 16),
                Btn('Clear filters', () => setState(() {
                      cat = null;
                      maxP = 2000;
                      q = '';
                      wishOnly = false;
                    }), filled: false),
              ]),
            )
          else
            ProductGrid(list),
        ]),
      ),
    );
  }
}
