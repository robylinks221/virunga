import 'package:flutter/material.dart';

/// Small compatibility layer for the NEW Virunga pages.
///
/// This does NOT replace AppTheme and does NOT change the approved Home page.
/// It simply gives new pages one consistent set of visual tokens.
abstract final class VirungaPageTokens {
  static const primary = Color(0xFF032329);
  static const secondary = Color(0xFFF58020);
  static const background = Color(0xFFFAFBF8);
  static const text = Color(0xFF14231D);
  static const muted = Color(0xFF6F7A75);
  static const border = Color(0xFFE5EAE7);
  static const soft = Color(0xFFF1EEE8);

  static const pagePadding = EdgeInsets.fromLTRB(20, 20, 20, 90);

  static BorderRadius cardRadius = BorderRadius.circular(17);
  static BorderRadius heroRadius = BorderRadius.circular(20);

  static BoxDecoration whiteCard() => BoxDecoration(
        color: Colors.white,
        borderRadius: cardRadius,
        border: Border.all(color: border),
      );

  static BoxDecoration darkHero() => BoxDecoration(
        color: primary,
        borderRadius: heroRadius,
      );

  const VirungaPageTokens._();
}
