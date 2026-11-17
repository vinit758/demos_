// widgets/collection_card/collections_grid.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../data/products_data.dart';
import '../../widgets/common/common.dart';

class CollectionsGrid extends StatelessWidget {
  const CollectionsGrid({super.key});
  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    return GridView.count(
      crossAxisCount: m ? 2 : 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 24,
      crossAxisSpacing: 18,
      childAspectRatio: m ? .6 : .78,
      children: [
        for (final (idx, k) in categories.indexed)
          InkWell(
            onTap: () => context.go('/shop?cat=${Uri.encodeComponent(k.name)}'),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: SizedBox.expand(
                  child: ImgBox(
                    tone: k.tone,
                    icon: Icons.auto_awesome_outlined,
                    imageUrl: collectionPhotos[idx % collectionPhotos.length],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(k.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: serif(m ? 20 : 26, w: FontWeight.w600)),
              Text(k.blurb,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sans(m ? 12 : 14)),
              const SizedBox(height: 6),
              Text('EXPLORE COLLECTION',
                  style: sans(10, c: C.gold, ls: 1.5, w: FontWeight.w500)),
            ]),
          ),
      ],
    );
  }
}
