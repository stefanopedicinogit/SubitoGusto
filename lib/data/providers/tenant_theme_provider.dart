import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import 'repository_providers.dart';

/// Tenant theme colors
class TenantColors {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color background;
  final Color backgroundLight;

  const TenantColors({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.background,
    required this.backgroundLight,
  });

  /// Default colors (SubitoGusto)
  factory TenantColors.defaults() {
    return const TenantColors(
      primary: AppColors.burgundy,
      primaryLight: AppColors.burgundyLight,
      primaryDark: AppColors.burgundyDark,
      secondary: AppColors.gold,
      background: AppColors.cream,
      backgroundLight: AppColors.creamLight,
    );
  }

  /// Create from hex color strings
  factory TenantColors.fromHex({
    String? primaryHex,
    String? secondaryHex,
    String? backgroundHex,
  }) {
    final primary = _parseColor(primaryHex) ?? AppColors.burgundy;
    final secondary = _parseColor(secondaryHex) ?? AppColors.gold;
    final background = _parseColor(backgroundHex) ?? AppColors.cream;

    return TenantColors(
      primary: primary,
      primaryLight: _lighten(primary, 0.1),
      primaryDark: _darken(primary, 0.1),
      secondary: secondary,
      background: background,
      backgroundLight: _lighten(background, 0.3),
    );
  }

  static Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final hexCode = hex.replaceAll('#', '');
      if (hexCode.length == 6) {
        return Color(int.parse('FF$hexCode', radix: 16));
      } else if (hexCode.length == 8) {
        return Color(int.parse(hexCode, radix: 16));
      }
    } catch (_) {}
    return null;
  }

  static Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}

/// Provider for tenant colors
final tenantColorsProvider = Provider<TenantColors>((ref) {
  final tenantAsync = ref.watch(tenantProvider);

  return tenantAsync.when(
    data: (tenant) {
      if (tenant == null) return TenantColors.defaults();
      return TenantColors.fromHex(
        primaryHex: tenant.primaryColor,
        secondaryHex: tenant.secondaryColor,
        backgroundHex: tenant.backgroundColor,
      );
    },
    loading: () => TenantColors.defaults(),
    error: (_, __) => TenantColors.defaults(),
  );
});

/// Dynamic theme generator
class TenantTheme {
  final TenantColors colors;

  const TenantTheme(this.colors);

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        primaryContainer: colors.primaryLight,
        secondary: colors.secondary,
        secondaryContainer: _lighten(colors.secondary, 0.2),
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: AppColors.charcoal,
        onSurface: AppColors.charcoal,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: colors.background,
      textTheme: _textTheme(AppColors.charcoal, AppColors.textSecondary),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.charcoal,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.backgroundLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colors.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.secondary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: colors.secondary,
        textColor: Colors.white,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.secondary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary.withValues(alpha: 0.5);
          }
          return Colors.grey.shade300;
        }),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors.primaryLight,
        primaryContainer: colors.primary,
        secondary: colors.secondary,
        secondaryContainer: _darken(colors.secondary, 0.2),
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: AppColors.darkText,
        onSurface: AppColors.darkText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: _textTheme(AppColors.darkText, AppColors.darkTextSecondary),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.darkSurfaceLight),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primaryLight,
          side: BorderSide(color: colors.primaryLight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryLight,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colors.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkSurfaceLight,
        thickness: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: colors.primaryLight,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.secondary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: colors.secondary,
        textColor: Colors.white,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.secondary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryLight;
          }
          return AppColors.darkTextSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryLight.withValues(alpha: 0.5);
          }
          return AppColors.darkSurfaceLight;
        }),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.darkText,
        iconColor: AppColors.darkTextSecondary,
      ),
    );
  }

  TextTheme _textTheme(Color textColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleSmall: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodySmall: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      labelLarge: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelMedium: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelSmall: GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
    );
  }

  static Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}

/// Provider for tenant theme
final tenantThemeProvider = Provider<TenantTheme>((ref) {
  final colors = ref.watch(tenantColorsProvider);
  return TenantTheme(colors);
});
