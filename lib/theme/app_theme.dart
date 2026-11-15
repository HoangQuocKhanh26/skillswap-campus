import 'package:flutter/material.dart';

/// Bảng màu cho một chế độ giao diện (sáng hoặc tối).
class AppPalette {
  final Color primary;
  final Color primaryDark;
  final Color primarySoft;
  final Color secondary;
  final Color secondarySoft;
  final Color accent;
  final Color accentSoft;
  final Color background;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color border;
  final Color success;
  final Color danger;
  final Color info;
  final Color slate;
  final List<Color> brandGradient;
  final List<Color> heroGradient;

  const AppPalette({
    required this.primary,
    required this.primaryDark,
    required this.primarySoft,
    required this.secondary,
    required this.secondarySoft,
    required this.accent,
    required this.accentSoft,
    required this.background,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.border,
    required this.success,
    required this.danger,
    required this.info,
    required this.slate,
    required this.brandGradient,
    required this.heroGradient,
  });

  static const AppPalette light = AppPalette(
    primary: Color(0xFF4F46E5),
    primaryDark: Color(0xFF3730A3),
    primarySoft: Color(0xFFEEF0FF),
    secondary: Color(0xFF0D9488),
    secondarySoft: Color(0xFFE7F8F5),
    accent: Color(0xFFF59E0B),
    accentSoft: Color(0xFFFFF5E6),
    background: Color(0xFFF6F6FB),
    surface: Colors.white,
    ink: Color(0xFF191833),
    muted: Color(0xFF6E6B86),
    border: Color(0xFFE9E7F3),
    success: Color(0xFF10B981),
    danger: Color(0xFFEF4444),
    info: Color(0xFF3B82F6),
    slate: Color(0xFF94A3B8),
    brandGradient: [
      Color(0xFF4F46E5),
      Color(0xFF7C3AED),
      Color(0xFF0D9488),
    ],
    heroGradient: [
      Color(0xFF4F46E5),
      Color(0xFF6D28D9),
    ],
  );

  static const AppPalette dark = AppPalette(
    primary: Color(0xFF9B8CFF),
    primaryDark: Color(0xFF7C6BFF),
    primarySoft: Color(0xFF2A2A4A),
    secondary: Color(0xFF2DD4BF),
    secondarySoft: Color(0xFF123B37),
    accent: Color(0xFFFBBF24),
    accentSoft: Color(0xFF3A2C12),
    background: Color(0xFF0F111A),
    surface: Color(0xFF181B2A),
    ink: Color(0xFFF3F1FB),
    muted: Color(0xFFA9A5C0),
    border: Color(0xFF2B2F45),
    success: Color(0xFF34D399),
    danger: Color(0xFFF87171),
    info: Color(0xFF60A5FA),
    slate: Color(0xFF8E93A8),
    brandGradient: [
      Color(0xFF6D5EF8),
      Color(0xFF8B5CF6),
      Color(0xFF14B8A6),
    ],
    heroGradient: [
      Color(0xFF5B4BE0),
      Color(0xFF7C3AED),
    ],
  );
}

/// Màu đang dùng. Đổi [palette] khi chuyển sáng/tối.
class AppColors {
  AppColors._();

  static AppPalette palette = AppPalette.light;

  static Color get primary => palette.primary;
  static Color get primaryDark => palette.primaryDark;
  static Color get primarySoft => palette.primarySoft;
  static Color get secondary => palette.secondary;
  static Color get secondarySoft => palette.secondarySoft;
  static Color get accent => palette.accent;
  static Color get accentSoft => palette.accentSoft;
  static Color get background => palette.background;
  static Color get surface => palette.surface;
  static Color get ink => palette.ink;
  static Color get muted => palette.muted;
  static Color get border => palette.border;
  static Color get success => palette.success;
  static Color get danger => palette.danger;
  static Color get info => palette.info;
  static Color get slate => palette.slate;

  static List<Color> get brandGradient => palette.brandGradient;
  static List<Color> get heroGradient => palette.heroGradient;
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => build(AppPalette.light, Brightness.light);

  static ThemeData dark() => build(AppPalette.dark, Brightness.dark);

  static ThemeData build(AppPalette p, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: p.primary,
      brightness: brightness,
    ).copyWith(
      primary: p.primary,
      secondary: p.secondary,
      tertiary: p.accent,
      surface: p.surface,
      onSurface: p.ink,
      onSurfaceVariant: p.muted,
      outline: p.border,
      error: p.danger,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
    );

    final snackBackground = brightness == Brightness.dark ? p.surface : p.ink;

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: p.ink,
        displayColor: p.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: p.ink),
        titleTextStyle: TextStyle(
          color: p.ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        elevation: 0,
        height: 68,
        indicatorColor: p.primarySoft,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? p.primary : p.muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 23,
            color: selected ? p.primary : p.muted,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: p.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: p.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: TextStyle(color: p.slate, fontSize: 14.5),
        labelStyle: TextStyle(color: p.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.danger),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.primary,
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          textStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
          side: BorderSide(color: p.border, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.primary,
          textStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: p.surface,
        selectedColor: p.primary,
        disabledColor: p.primarySoft,
        side: BorderSide(color: p.border),
        shape: const StadiumBorder(),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: p.ink,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: p.primary,
        unselectedLabelColor: p.muted,
        indicatorColor: p.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: p.border,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        unselectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: snackBackground,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: p.border,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          color: p.ink,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14.5,
          height: 1.5,
          color: p.muted,
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(p.surface),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
        constraints: const BoxConstraints(minHeight: 50),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: p.border),
          ),
        ),
        hintStyle: WidgetStateProperty.all(
          TextStyle(color: p.slate, fontSize: 14.5),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(color: p.ink, fontSize: 14.5),
        ),
      ),
    );
  }
}
