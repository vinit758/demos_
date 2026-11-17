// screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../data/products_data.dart';
import '../../services/contact_service.dart';
import '../../widgets/collection_card/collections_grid.dart';
import '../../widgets/common/common.dart';
import '../../widgets/navbar/shell.dart';
import '../../widgets/product_card/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    final text =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Reej', style: script(m ? 56 : 80, c: C.gold)),
      Text('Elegance That Speaks Your Style.',
          style: serif(m ? 44 : 70, h: 1.05)),
      const SizedBox(height: 18),
      ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
              'Discover beautiful women'
              's clothing, thoughtfully styled for you.',
              style: sans(m ? 16 : 19))),
      const SizedBox(height: 30),
      Wrap(spacing: 14, runSpacing: 14, children: [
        Btn('Shop collection', () => context.go('/shop')),
        Btn('Explore our story', () => context.go('/about'), filled: false),
      ]),
    ]);
    final hero = Container(
      width: double.infinity,
      color: C.cream,
      child: Frame(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: m ? 36 : 72),
          child: FadeIn(
            child: twoCol(
              context,
              text,
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: m ? 400 : 440),
                  child: ImgBox(
                      tone: C.champagne,
                      aspect: m ? 1.1 : .9,
                      imageUrl: reejPhotos[0]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return Shell(
      title: 'Home',
      child: Column(children: [
        hero,
        const Sec(
            child: Column(children: [
          SectionTitle('Featured Collections',
              sub: 'Curated outfits for every moment.'),
          CollectionsGrid()
        ])),
        Sec(
            color: C.cream,
            child: Column(children: [
              const SectionTitle('Best Sellers',
                  sub:
                      'Sample products and prices shown for demonstration only.'),
              ProductGrid([
                for (final p in products)
                  if (p.best) p
              ].take(4).toList()),
              const SizedBox(height: 36),
              Btn('View all', () => context.go('/shop'), filled: false),
            ])),
        Sec(
            child: twoCol(
          context,
          ImgBox(tone: C.nude, aspect: 1.1, imageUrl: reejPhotos[4]),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Styled With Love.\nMade For You.',
                style: serif(m ? 38 : 54, h: 1.05)),
            const SizedBox(height: 20),
            Text(
                "At Reej, we believe clothing is more than what you wear. It's how you express yourself. Discover thoughtfully curated women's fashion that brings confidence and elegance to every moment.",
                style: sans(16)),
            const SizedBox(height: 28),
            Btn('Read our story', () => context.go('/about'), filled: false),
          ]),
        )),
        Sec(
            color: C.cream,
            child: Column(children: [
              const SectionTitle('Follow Our Style',
                  sub: 'Outfit inspiration. Everyday style. Be uniquely you.'),
              GridView.count(
                crossAxisCount: m ? 3 : 6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  for (var i = 0; i < 6; i++)
                    ImgBox(
                        tone: i.isEven ? C.champagne : C.nude,
                        icon: Icons.camera_alt_outlined,
                        imageUrl: reejPhotos[i])
                ],
              ),
              const SizedBox(height: 32),
              Btn('Follow on Instagram', () => openUrl(instaUrl)),
            ])),
        const Sec(child: _Reviews()),
        const Sec(color: C.champagne, child: _Newsletter()),
      ]),
    );
  }
}

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Shell(
      title: 'Collections',
      child: Sec(
          child: Column(children: [
        SectionTitle('Collections',
            sub: 'Choose a collection to start exploring.'),
        CollectionsGrid()
      ])));
}

class _Reviews extends StatelessWidget {
  const _Reviews();
  @override
  Widget build(BuildContext context) {
    Widget card() => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(border: Border.all(color: C.champagne)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              for (var i = 0; i < 5; i++)
                Icon(Icons.star, size: 16, color: C.gold)
            ]),
            const SizedBox(height: 12),
            Text(
                'Sample review text. Replace with a real customer testimonial.',
                style: serif(22)),
            const SizedBox(height: 12),
            Text('Customer name (sample)', style: sans(13, c: C.gold)),
          ]),
        );
    final m = isMobile(context);
    return Column(children: [
      const SectionTitle('What Our Customers Say',
          sub: 'Placeholder reviews. Replace with real customer feedback.'),
      m
          ? Column(children: [
              card(),
              const SizedBox(height: 16),
              card(),
              const SizedBox(height: 16),
              card()
            ])
          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: card()),
              const SizedBox(width: 20),
              Expanded(child: card()),
              const SizedBox(width: 20),
              Expanded(child: card())
            ]),
    ]);
  }
}

class _Newsletter extends StatefulWidget {
  const _Newsletter();
  @override
  State<_Newsletter> createState() => _NewsletterState();
}

class _NewsletterState extends State<_Newsletter> {
  final c = TextEditingController();
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  Future<void> _go() async {
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(c.text.trim());
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter a valid email address.')));
      return;
    }
    try {
      await ContactService.subscribe(c.text.trim());
    } on UnimplementedError {
      if (mounted) notConnected(context, 'Newsletter signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: c,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          hintText: 'Your email address',
          filled: true,
          fillColor: C.ivory,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.zero, borderSide: BorderSide.none)),
    );
    return Column(children: [
      Text('A Little More Style in Your Inbox',
          textAlign: TextAlign.center,
          style: serif(isMobile(context) ? 32 : 42)),
      const SizedBox(height: 24),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: isMobile(context)
            ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                field,
                const SizedBox(height: 12),
                Btn('Subscribe', _go)
              ])
            : Row(children: [
                Expanded(child: field),
                const SizedBox(width: 12),
                Btn('Subscribe', _go)
              ]),
      ),
    ]);
  }
}
