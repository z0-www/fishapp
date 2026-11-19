import 'package:material_ui/material_ui.dart';

abstract final class FishTheme {
  static const blue = Color(0xFF3176C6),
      ink = Color(0xFF202124),
      muted = Color(0xFF858A93),
      soft = Color(0xFFF6F7F9);
  // Optional test font: no bundled font or override in normal Android/iOS builds.
  static const previewFont = String.fromEnvironment('FISH_PREVIEW_FONT');
  static ThemeData get light => ThemeData(
    fontFamily: previewFont == '' ? null : previewFont,
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    fontFamilyFallback: const [
      'Noto Sans SC',
      'Noto Sans CJK SC',
      'Microsoft YaHei',
      'sans-serif',
    ],
    colorScheme: ColorScheme.fromSeed(
      seedColor: blue,
      primary: blue,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: ink,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, height: 1.75, color: ink),
      bodyMedium: TextStyle(fontSize: 15, height: 1.65, color: ink),
      bodySmall: TextStyle(fontSize: 12, height: 1.5, color: muted),
      titleLarge: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: ink,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: ink,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: previewFont == '' ? null : previewFont,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: ink,
      ),
    ),
    dividerColor: soft,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: soft,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: blue, width: 1),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    cardTheme: const CardThemeData(
      color: soft,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        side: BorderSide.none,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
  );
}
