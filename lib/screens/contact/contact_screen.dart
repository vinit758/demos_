import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../services/contact_service.dart';
import '../../widgets/common/common.dart';
import '../../widgets/navbar/shell.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController(), phone = TextEditingController(), msg = TextEditingController();

  @override
  void dispose() {
    for (final c in [name, email, phone, msg]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _f(TextEditingController c, String label, String? Function(String?) v, {TextInputType? k, int lines = 1}) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: c,
          keyboardType: k,
          maxLines: lines,
          validator: v,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: C.gold)),
          ),
        ),
      );

  Future<void> _send() async {
    if (!_form.currentState!.validate()) return;
    try {
      await ContactService.send(name: name.text, email: email.text, phone: phone.text, message: msg.text);
    } on UnimplementedError {
      if (mounted) notConnected(context, 'The contact form');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;
    final form = Form(
      key: _form,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _f(name, 'Name', req),
        _f(email, 'Email', (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch((v ?? '').trim()) ? null : 'Enter a valid email', k: TextInputType.emailAddress),
        _f(phone, 'Phone', (v) => RegExp(r'^[6-9]\d{9}$').hasMatch((v ?? '').trim()) ? null : 'Enter a 10-digit mobile number', k: TextInputType.phone),
        _f(msg, 'Message', req, lines: 5),
        Align(alignment: Alignment.centerLeft, child: Btn('Send message', _send)),
      ]),
    );
    final info = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Visit us', style: serif(30, w: FontWeight.w600)),
      const SizedBox(height: 8),
      Text('Reej – Styled for You\n$address', style: sans(16)),
      const SizedBox(height: 12),
      InkWell(onTap: () => openUrl(instaUrl), child: Text('@reej.styledforyou on Instagram', style: sans(15, c: C.gold, w: FontWeight.w500))),
      const SizedBox(height: 24),
      Container(
        height: 220,
        width: double.infinity,
        color: C.champagne,
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.map_outlined, color: C.gold, size: 36),
          const SizedBox(height: 8),
          Text('Google Maps embed placeholder', style: sans(13)),
          const SizedBox(height: 12),
          Btn('Open in Google Maps', () => openUrl(mapsUrl), filled: false),
        ]),
      ),
    ]);
    return Shell(
      title: 'Contact',
      child: Sec(child: Column(children: [const SectionTitle('Get in Touch', sub: 'We would love to hear from you.'), twoCol(context, form, info, align: CrossAxisAlignment.start)])),
    );
  }
}
