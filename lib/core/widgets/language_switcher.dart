import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/locale_provider.dart';

/// Compact globe-icon button that opens a popup with the supported locales.
/// Place in any AppBar's `actions` to let users switch language without
/// needing to be signed in.
class LanguageSwitcher extends ConsumerWidget {
  final Color? iconColor;

  const LanguageSwitcher({super.key, this.iconColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider)?.languageCode ?? 'it';
    return PopupMenuButton<String>(
      tooltip: 'Lingua / Language',
      icon: Icon(Icons.language, color: iconColor),
      onSelected: (code) =>
          ref.read(localeProvider.notifier).set(Locale(code)),
      itemBuilder: (_) => [
        for (final option in const [
          ('it', '🇮🇹  Italiano'),
          ('en', '🇬🇧  English'),
        ])
          CheckedPopupMenuItem<String>(
            value: option.$1,
            checked: current == option.$1,
            child: Text(option.$2),
          ),
      ],
    );
  }
}
