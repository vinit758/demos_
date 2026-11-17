import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const instaUrl = 'https://www.instagram.com/reej.styledforyou/';
const mapsUrl = 'https://maps.app.goo.gl/fTT3WRbPkBd9uvmu9?g_st=aw';
const address = 'Professor Colony, Savedi, Ahilyanagar, Maharashtra 414003';

class C {
  static const champagne = Color(0xFFE9DCCB), ivory = Color(0xFFFAF7F2), cream = Color(0xFFF3EDE5);
  static const nude = Color(0xFFD8C2AE), gold = Color(0xFFB08D57), espresso = Color(0xFF49382D), charcoal = Color(0xFF252321);
}

TextStyle serif(double s, {Color c = C.espresso, FontWeight w = FontWeight.w500, double h = 1.15}) =>
    GoogleFonts.cormorantGaramond(fontSize: s, color: c, fontWeight: w, height: h);
TextStyle sans(double s, {Color c = C.espresso, FontWeight w = FontWeight.w400, double ls = 0, double h = 1.6}) =>
    GoogleFonts.jost(fontSize: s, color: c, fontWeight: w, letterSpacing: ls, height: h);
TextStyle script(double s, {Color c = C.espresso}) => GoogleFonts.greatVibes(fontSize: s, color: c);

bool isMobile(BuildContext c) => MediaQuery.sizeOf(c).width < 700;
int gridCols(BuildContext c) {
  final w = MediaQuery.sizeOf(c).width;
  return w >= 1100 ? 4 : (w >= 700 ? 3 : 2);
}
double gridRatio(int cols) => cols == 2 ? .46 : (cols == 3 ? .54 : .58);

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: C.ivory,
      colorScheme: ColorScheme.fromSeed(seedColor: C.gold, surface: C.ivory),
      textTheme: GoogleFonts.jostTextTheme(),
      snackBarTheme: const SnackBarThemeData(backgroundColor: C.espresso, behavior: SnackBarBehavior.floating),
    );
