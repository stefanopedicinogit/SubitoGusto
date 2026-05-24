import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';

/// Read-only star row showing an average rating (e.g. 4.5 ★ × 5).
/// Half-stars supported via [Icons.star_half]. Used on marketplace cards,
/// restaurant detail header, menu item cards.
class RatingStars extends StatelessWidget {
  final double rating;
  final int? count;
  final double size;
  final bool showNumber;
  final Color? color;

  const RatingStars({
    super.key,
    required this.rating,
    this.count,
    this.size = 16,
    this.showNumber = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.gold;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: c, size: size),
        if (showNumber) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size - 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (count != null) ...[
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: size - 3,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Read-only 5-star row showing filled / empty stars for a specific rating
/// (1–5). Use this when you want a *visual* rating display, like on a user's
/// own review. The compact [RatingStars] above is for aggregate badges on
/// cards.
class RatingStarsRow extends StatelessWidget {
  final int rating;
  final double size;
  final Color? color;

  const RatingStarsRow({
    super.key,
    required this.rating,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.gold;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating;
        return Icon(
          filled ? Icons.star : Icons.star_border,
          color: filled ? c : AppColors.textSecondary,
          size: size,
        );
      }),
    );
  }
}

/// "Compact" placeholder shown when a target has zero reviews — keeps cards
/// from shifting layout once a rating is added.
class NoRatingChip extends StatelessWidget {
  final double size;
  const NoRatingChip({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_border,
            color: AppColors.textSecondary, size: size),
        const SizedBox(width: 4),
        Text(
          AppLocalizations.of(context).marketplaceRatingNew,
          style: TextStyle(
            fontSize: size - 3,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Interactive 1–5 star picker. Tap or drag to set a rating.
class StarRatingPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  const StarRatingPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final filled = i < value;
        return IconButton(
          onPressed: () => onChanged(i + 1),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          constraints: const BoxConstraints(),
          icon: Icon(
            filled ? Icons.star : Icons.star_border,
            color: filled ? AppColors.gold : AppColors.textSecondary,
            size: size,
          ),
        );
      }),
    );
  }
}
