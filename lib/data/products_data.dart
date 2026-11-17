import '../core/theme.dart';
import '../models/product.dart';

/// SAMPLE DATA ONLY. Replace with real Reej women's clothing inventory, prices and photos.
const sampleDesc = 'Sample description. Replace with the real garment details, fabric, fit and care instructions from Reej.';

const categories = [
  Category('Everyday Wear', 'Effortless styles for your everyday wardrobe.', C.champagne),
  Category('Dresses & Gowns', 'Elegant silhouettes for every occasion.', C.nude),
  Category('Ethnic Wear', 'Timeless traditional looks with a modern touch.', C.cream),
  Category('Party Wear', 'Statement outfits for special evenings.', C.nude),
  Category('Minimal Essentials', 'Versatile staples, easy to style.', C.champagne),
  Category('Trending Styles', 'Fresh looks we are loving right now.', C.cream),
];

const products = [
  Product('p1', 'Floral Midi Dress', 'Everyday Wear', 1499, 1899, 1, ['S', 'M', 'L', 'XL'], true, C.champagne),
  Product('p2', 'Elegant Satin Gown', 'Dresses & Gowns', 2499, null, 2, ['S', 'M', 'L'], true, C.cream),
  Product('p3', 'Embroidered Kurta Set', 'Ethnic Wear', 1999, 2499, 3, ['S', 'M', 'L', 'XL'], true, C.nude),
  Product('p4', 'Statement Party Dress', 'Party Wear', 2199, null, 4, ['S', 'M', 'L'], false, C.champagne),
  Product('p5', 'Classic Linen Shirt', 'Minimal Essentials', 999, null, 5, ['S', 'M', 'L', 'XL'], true, C.cream),
  Product('p6', 'Chic Co-ord Set', 'Trending Styles', 1799, 2199, 6, ['S', 'M', 'L'], false, C.nude),
  Product('p7', 'Pleated Evening Skirt', 'Party Wear', 1299, null, 7, ['S', 'M', 'L', 'XL'], false, C.champagne),
  Product('p8', 'Soft Knit Cardigan', 'Everyday Wear', 1199, null, 8, ['S', 'M', 'L'], false, C.cream),
];
Product? productById(String id) {
  for (final p in products) {
    if (p.id == id) return p;
  }
  return null;
}
