import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/cart_provider.dart';
import '../../services/payment_service.dart';
import '../../widgets/common/common.dart';
import '../../widgets/navbar/shell.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _form = GlobalKey<FormState>();
  final _c = {for (final k in ['name', 'phone', 'email', 'address', 'city', 'state', 'pin']) k: TextEditingController()};

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;
  String? _re(String? v, String pattern, String msg) => RegExp(pattern).hasMatch((v ?? '').trim()) ? null : msg;

  Widget _f(String key, String label, {String? Function(String?)? v, TextInputType? k, int lines = 1}) => SizedBox(
        width: isMobile(context) ? double.infinity : 380,
        child: TextFormField(
          controller: _c[key],
          keyboardType: k,
          maxLines: lines,
          validator: v ?? _req,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: C.gold)),
          ),
        ),
      );

  Future<void> _place() async {
    if (!_form.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    try {
      await PaymentService.startPayment(amountInRupees: cart.subtotal, customer: {for (final e in _c.entries) e.key: e.value.text.trim()});
    } on UnimplementedError {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (d) => AlertDialog(
          title: const Text('Payment not connected yet'),
          content: const Text('Your details look good, but no payment gateway is configured. See lib/services/payment_service.dart to connect Razorpay.'),
          actions: [TextButton(onPressed: () => Navigator.pop(d), child: const Text('OK'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final m = isMobile(context);
    if (cart.items.isEmpty) {
      return Shell(
        title: 'Checkout',
        child: Sec(child: SizedBox(width: double.infinity, child: Column(children: [Text('Your bag is empty', style: serif(36)), const SizedBox(height: 20), Btn('Continue shopping', () => context.go('/shop'))]))),
      );
    }
    final form = Form(
      key: _form,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Checkout', style: serif(m ? 36 : 46)),
        const SizedBox(height: 20),
        Wrap(spacing: 20, runSpacing: 20, children: [
          _f('name', 'Full name'),
          _f('phone', 'Mobile number', k: TextInputType.phone, v: (v) => _re(v, r'^[6-9]\d{9}$', 'Enter a 10-digit mobile number')),
          _f('email', 'Email', k: TextInputType.emailAddress, v: (v) => _re(v, r'^[^@\s]+@[^@\s]+\.[^@\s]+$', 'Enter a valid email')),
          _f('address', 'Delivery address', lines: 2),
          _f('city', 'City'),
          _f('state', 'State'),
          _f('pin', 'PIN code', k: TextInputType.number, v: (v) => _re(v, r'^\d{6}$', 'Enter a 6-digit PIN code')),
        ]),
        const SizedBox(height: 28),
        Text('Payment method', style: serif(26)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: C.gold)),
          child: Row(children: [
            const Icon(Icons.radio_button_checked, color: C.gold),
            const SizedBox(width: 12),
            Expanded(child: Text('Online payment via Razorpay (gateway to be connected)', style: sans(14))),
          ]),
        ),
      ]),
    );
    final summary = Container(
      color: C.cream,
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Order summary', style: serif(28)),
        const SizedBox(height: 12),
        for (final i in cart.items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text('${i.product.name} × ${i.qty}', style: sans(14))),
              Text('₹${i.total}', style: sans(14)),
            ]),
          ),
        const Divider(height: 28),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Subtotal', style: sans(16, w: FontWeight.w500)), Text('₹${cart.subtotal}', style: sans(16, w: FontWeight.w500))]),
        const SizedBox(height: 20),
        Btn('Place order', _place),
      ]),
    );
    return Shell(
      title: 'Checkout',
      child: Sec(
        child: m
            ? Column(children: [form, const SizedBox(height: 32), summary])
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: form), const SizedBox(width: 48), Expanded(flex: 2, child: summary)]),
      ),
    );
  }
}
