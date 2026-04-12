import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette "Italian Elegance" per SubitoGusto
class AppColors {
  // Primary Colors
  static const Color burgundy = Color(0xFF722F37);
  static const Color burgundyLight = Color(0xFF8B3D47);
  static const Color burgundyDark = Color(0xFF5A252C);

  // Secondary Colors
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE5C767);
  static const Color goldDark = Color(0xFFB8960F);

  // Background Colors
  static const Color cream = Color(0xFFFDF5E6);
  static const Color creamLight = Color(0xFFFFFAF0);
  static const Color surface = Color(0xFFFFFFFF);

  // Text Colors
  static const Color charcoal = Color(0xFF36454F);
  static const Color charcoalLight = Color(0xFF5A6A75);
  static const Color textSecondary = Color(0xFF6B7C87);

  // Semantic Colors
  static const Color success = Color(0xFF8B9A6B);
  static const Color successLight = Color(0xFFE8EDE0);
  static const Color warning = Color(0xFFFFBF00);
  static const Color warningLight = Color(0xFFFFF4CC);
  static const Color error = Color(0xFFC04000);
  static const Color errorLight = Color(0xFFFDE8E0);

  // Order Status Colors
  static const Color statusPending = Color(0xFFFFB347);
  static const Color statusConfirmed = Color(0xFF87CEEB);
  static const Color statusPreparing = Color(0xFFDDA0DD);
  static const Color statusReady = Color(0xFF90EE90);
  static const Color statusServed = Color(0xFF98FB98);
  static const Color statusPaid = Color(0xFFB0C4DE);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkSurfaceLight = Color(0xFF3D3D3D);
  static const Color darkText = Color(0xFFE8E8E8);
  static const Color darkTextSecondary = Color(0xFFA0A0A0);
}

/// Spacing constants (8px grid)
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Border radius constants
class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;
}

/// App theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.burgundy,
        primaryContainer: AppColors.burgundyLight,
        secondary: AppColors.gold,
        secondaryContainer: AppColors.goldLight,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: AppColors.charcoal,
        onSurface: AppColors.charcoal,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: _textTheme,
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
          backgroundColor: AppColors.burgundy,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.burgundy,
          side: const BorderSide(color: AppColors.burgundy),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.burgundy,
          textStyle: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.creamLight,
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
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: GoogleFonts.lato(color: AppColors.textSecondary),
        hintStyle: GoogleFonts.lato(color: AppColors.textSecondary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.creamLight,
        labelStyle: GoogleFonts.lato(
          fontSize: 12,
          color: AppColors.charcoal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.burgundy,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.burgundy,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.charcoal,
        contentTextStyle: GoogleFonts.lato(color: Colors.white),
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
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
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
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.burgundyLight,
        primaryContainer: AppColors.burgundy,
        secondary: AppColors.gold,
        secondaryContainer: AppColors.goldDark,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: AppColors.darkText,
        onSurface: AppColors.darkText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: _darkTextTheme,
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
          side: BorderSide(color: AppColors.darkSurfaceLight),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.burgundyLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.burgundyLight,
          side: const BorderSide(color: AppColors.burgundyLight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.burgundyLight,
          textStyle: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
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
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: GoogleFonts.lato(color: AppColors.darkTextSecondary),
        hintStyle: GoogleFonts.lato(color: AppColors.darkTextSecondary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceLight,
        labelStyle: GoogleFonts.lato(
          fontSize: 12,
          color: AppColors.darkText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.darkSurfaceLight,
        thickness: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.burgundyLight,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.burgundyLight,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceLight,
        contentTextStyle: GoogleFonts.lato(color: AppColors.darkText),
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
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
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
            return AppColors.burgundyLight;
          }
          return AppColors.darkTextSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.burgundyLight.withValues(alpha: 0.5);
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

  static TextTheme get _darkTextTheme {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: AppColors.darkText,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: AppColors.darkText,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: AppColors.darkText,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      ),
      titleLarge: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      ),
      titleSmall: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.darkText,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.darkText,
      ),
      bodySmall: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.darkTextSecondary,
      ),
      labelLarge: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      ),
      labelMedium: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      ),
      labelSmall: GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.darkTextSecondary,
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      // Display
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: AppColors.charcoal,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: AppColors.charcoal,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: AppColors.charcoal,
      ),
      // Headline
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      // Title
      titleLarge: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      titleSmall: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      // Body
      bodyLarge: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.charcoal,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.charcoal,
      ),
      bodySmall: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      // Label
      labelLarge: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      labelMedium: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      labelSmall: GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}
