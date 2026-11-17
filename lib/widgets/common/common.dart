// widgets/common/common.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme.dart';

Future<void> openUrl(String u) =>
    launchUrl(Uri.parse(u), mode: LaunchMode.externalApplication);

void notConnected(BuildContext c, String what) =>
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(
      content: Text(
          "$what isn't connected to a backend yet. Message us on Instagram for now."),
      action: SnackBarAction(
          label: 'OPEN INSTAGRAM', onPressed: () => openUrl(instaUrl)),
    ));

Widget twoCol(BuildContext c, Widget a, Widget b,
        {CrossAxisAlignment align = CrossAxisAlignment.center,
        double gap = 56}) =>
    isMobile(c)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [a, SizedBox(height: gap / 2), b])
        : Row(crossAxisAlignment: align, children: [
            Expanded(child: a),
            SizedBox(width: gap),
            Expanded(child: b)
          ]);

class Frame extends StatelessWidget {
  final Widget child;
  const Frame({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: isMobile(context) ? 20 : 48),
              child: child),
        ),
      );
}

class Sec extends StatelessWidget {
  final Widget child;
  final Color? color;
  const Sec({super.key, required this.child, this.color});
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      color: color,
      padding: EdgeInsets.symmetric(vertical: isMobile(context) ? 48 : 84),
      child: Frame(child: child));
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? sub;
  const SectionTitle(this.title, {super.key, this.sub});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 36),
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            Text(title,
                textAlign: TextAlign.center,
                style: serif(isMobile(context) ? 34 : 46)),
            const SizedBox(height: 12),
            Container(width: 48, height: 1, color: C.gold),
            if (sub != null) ...[
              const SizedBox(height: 12),
              Text(sub!, textAlign: TextAlign.center, style: sans(15))
            ],
          ]),
        ),
      );
}

class Btn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;
  const Btn(this.label, this.onTap, {super.key, this.filled = true});
  @override
  Widget build(BuildContext context) {
    const pad = EdgeInsets.symmetric(horizontal: 30, vertical: 20);
    const shape = RoundedRectangleBorder();
    final t = Text(label.toUpperCase(),
        textAlign: TextAlign.center,
        style: sans(12,
            c: filled ? C.ivory : C.espresso, w: FontWeight.w500, ls: 2));
    return filled
        ? FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: C.espresso, shape: shape, padding: pad),
            onPressed: onTap,
            child: t)
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: C.espresso),
                shape: shape,
                padding: pad),
            onPressed: onTap,
            child: t);
  }
}

/// Curated editorial photography for Reej's women's clothing collections.
const reejPhotos = <String>[
  'assets/images/image1.jpeg',
  'assets/images/image2.jpeg',
  'assets/images/image3.jpeg',
  'assets/images/image4.jpeg',
  'assets/images/image5.jpeg',
  'assets/images/image6.jpeg',
  'assets/images/image7.jpeg',
  'assets/images/image8.jpeg',

];

const collectionPhotos = <String>[
  'assets/images/collection1.jpeg',
  'assets/images/collection2.jpeg',
  'assets/images/collection3.jpeg',
  'assets/images/collection4.jpeg',
  'assets/images/collection5.jpeg',
  'assets/images/collection6.jpeg',
];

String productPhoto(String id) {
  final index = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
  return reejPhotos[(index - 1) % reejPhotos.length];
}

class ImgBox extends StatelessWidget {
  final Color tone;
  final double aspect;
  final IconData icon;
  final String? imageUrl;
  const ImgBox(
      {super.key,
      required this.tone,
      this.aspect = 1,
      this.icon = Icons.diamond_outlined,
      this.imageUrl});

  @override
  Widget build(BuildContext context) {
    Widget fallback() => Container(
        color: tone,
        alignment: Alignment.center,
        child: Icon(icon, size: 34, color: C.gold));
    final src = imageUrl ??
        (icon == Icons.camera_alt_outlined ? reejPhotos[6] : reejPhotos[0]);
    return AspectRatio(
      aspectRatio: aspect,
      child: src.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: src,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              placeholder: (_, __) => fallback(),
              errorWidget: (_, __, ___) => fallback())
          : Image.asset(src,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => fallback()),
    );
  }
}

class FadeIn extends StatelessWidget {
  final Widget child;
  const FadeIn({super.key, required this.child});
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOut,
        builder: (_, t, c) => Opacity(
            opacity: t,
            child:
                Transform.translate(offset: Offset(0, (1 - t) * 18), child: c)),
        child: child,
      );
}

/// Temporary typographic logo. Swap the body for Image.asset('assets/images/logo.png') when the real file is added.
class Logo extends StatelessWidget {
  final double size;
  final Color color;
  const Logo({super.key, this.size = 40, this.color = C.espresso});
  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Reej, Styled for You',
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Reej', style: script(size, c: color)),
          Text('STYLED FOR YOU',
              style: sans(size * .22, c: C.gold, ls: 3, h: 1)),
        ]),
      );
}
