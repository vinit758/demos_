import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/common.dart';
import '../../widgets/navbar/shell.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final m = isMobile(context);
    if (cart.items.isEmpty) {
      return Shell(
        title: 'Shopping Bag',
        child: Sec(
          child: SizedBox(
            width: double.infinity,
            child: Column(children: [
              const Icon(Icons.shopping_bag_outlined, size: 48, color: C.gold),
              const SizedBox(height: 12),
              Text('Your bag is empty', style: serif(36)),
              const SizedBox(height: 8),
              Text('Find something you love in the shop.', style: sans(15)),
              const SizedBox(height: 24),
              Btn('Continue shopping', () => context.go('/shop')),
            ]),
          ),
        ),
      );
    }
    final rows = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Shopping bag', style: serif(m ? 36 : 46)),
      const SizedBox(height: 12),
      for (final i in cart.items)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.champagne))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: m ? 80 : 110, child: ImgBox(tone: i.product.tone, aspect: .85)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(i.product.name, style: serif(22, w: FontWeight.w600)),
                Text(i.variant, style: sans(13)),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(visualDensity: VisualDensity.compact, tooltip: 'Decrease quantity', icon: const Icon(Icons.remove), onPressed: () => cart.setQty(i.key, i.qty - 1)),
                  Text('${i.qty}', style: sans(16)),
                  IconButton(visualDensity: VisualDensity.compact, tooltip: 'Increase quantity', icon: const Icon(Icons.add), onPressed: () => cart.setQty(i.key, i.qty + 1)),
                ]),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('₹${i.total}', style: sans(16, w: FontWeight.w500)),
              IconButton(tooltip: 'Remove', icon: const Icon(Icons.delete_outline), onPressed: () => cart.setQty(i.key, 0)),
            ]),
          ]),
        ),
    ]);
    final summary = Container(
      color: C.cream,
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Order summary', style: serif(28)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Subtotal', style: sans(15)), Text('₹${cart.subtotal}', style: sans(15, w: FontWeight.w500))]),
        const SizedBox(height: 8),
        Text('Delivery charges are confirmed at checkout.', style: sans(13)),
        const SizedBox(height: 24),
        Btn('Proceed to checkout', () => context.go('/checkout')),
        const SizedBox(height: 12),
        Btn('Continue shopping', () => context.go('/shop'), filled: false),
      ]),
    );
    return Shell(
      title: 'Shopping Bag',
      child: Sec(
        child: m
            ? Column(children: [rows, const SizedBox(height: 32), summary])
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: rows), const SizedBox(width: 48), Expanded(flex: 2, child: summary)]),
      ),
    );
  }
}
