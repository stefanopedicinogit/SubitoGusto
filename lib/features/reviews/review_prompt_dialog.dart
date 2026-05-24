import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../core/widgets/rating_stars.dart';
import '../../data/providers/reviews_provider.dart';
import '../../l10n/generated/app_localizations.dart';

/// Bottom-sheet style dialog that asks the customer to rate a restaurant.
/// Used after an order is delivered (auto-prompt) and as a manual entry
/// point from the order detail page.
class ReviewPromptDialog extends ConsumerStatefulWidget {
  final String tenantId;
  final String tenantName;

  const ReviewPromptDialog({
    super.key,
    required this.tenantId,
    required this.tenantName,
  });

  /// Show as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required String tenantId,
    required String tenantName,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => Padding(
        // Lift content above the keyboard.
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ReviewPromptDialog(
          tenantId: tenantId,
          tenantName: tenantName,
        ),
      ),
    );
  }

  @override
  ConsumerState<ReviewPromptDialog> createState() => _ReviewPromptDialogState();
}

class _ReviewPromptDialogState extends ConsumerState<ReviewPromptDialog> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing review (so re-prompt = edit).
    Future.microtask(() async {
      final existing = await ref.read(myReviewForTargetProvider(
        ReviewTargetKey('restaurant', widget.tenantId),
      ).future);
      if (!mounted || existing == null) return;
      setState(() {
        _rating = existing.rating;
        _commentController.text = existing.comment ?? '';
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(submitReviewProvider).submit(SubmitReviewArgs(
            targetType: 'restaurant',
            targetId: widget.tenantId,
            rating: _rating,
            comment: _commentController.text.trim(),
          ));
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).reviewPromptThanks),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = humanizeError(e, context));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.reviewPromptTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.tenantName,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          StarRatingPicker(
            value: _rating,
            onChanged: (v) => setState(() => _rating = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _commentController,
            maxLines: 3,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: l.reviewPromptCommentHint,
              border: const OutlineInputBorder(),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error!,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(l.reviewPromptLater),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton(
                  onPressed: (_rating == 0 || _submitting) ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(l.reviewPromptSubmit),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
