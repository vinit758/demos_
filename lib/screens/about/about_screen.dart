import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../widgets/common/common.dart';
import '../../widgets/navbar/shell.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    Widget pillar(String h, String b) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(h, style: serif(28, w: FontWeight.w600)), const SizedBox(height: 6), Text(b, style: sans(15))]),
        );
    return Shell(
      title: 'About Us',
      child: Column(children: [
        Sec(
          color: C.cream,
          child: twoCol(
            context,
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Our story', style: script(m ? 40 : 52, c: C.gold)),
              Text('More Than Fashion.\nIt’s Your Expression.', style: serif(m ? 40 : 60, h: 1.05)),
              const SizedBox(height: 20),
              Text('Reej is a fashion studio and boutique in Savedi, Ahilyanagar, created to help every customer express an individual sense of style through thoughtfully curated fashion and accessories.', style: sans(16)),
            ]),
            ImgBox(tone: C.champagne, aspect: 1),
          ),
        ),
        Sec(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            pillar('Passion for styling', 'We love helping you find pieces that feel like you, from everyday looks to festive occasions.'),
            pillar('Attention to detail', 'Every piece is chosen for its finish, its fit and how well it works with the rest of your wardrobe.'),
            pillar('Your style, your way', 'We are here to guide, never to dictate. Your style is yours to define.'),
            Btn('Visit the shop', () => context.go('/shop')),
          ]),
        ),
      ]),
    );
  }
}
