import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_theme.dart';

/// Shimmer-wrapped placeholder block.
class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  const _SkeletonBox({
    this.width,
    this.height,
    this.radius = AppRadius.sm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _ShimmerWrap extends StatelessWidget {
  final Widget child;
  const _ShimmerWrap({required this.child});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkSurfaceLight
        : Colors.grey.shade300;
    final highlight = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkSurface
        : Colors.grey.shade100;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: child,
    );
  }
}

/// Single restaurant card skeleton (matches marketplace card shape).
class RestaurantCardSkeleton extends StatelessWidget {
  const RestaurantCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: _ShimmerWrap(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SkeletonBox(height: 150, radius: 0),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SkeletonBox(height: 18, width: 180),
                  SizedBox(height: AppSpacing.xs),
                  _SkeletonBox(height: 12, width: double.infinity),
                  SizedBox(height: 4),
                  _SkeletonBox(height: 12, width: 220),
                  SizedBox(height: AppSpacing.sm),
                  _SkeletonBox(height: 12, width: 260),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical list of restaurant card skeletons.
class RestaurantListSkeleton extends StatelessWidget {
  final int itemCount;
  const RestaurantListSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: itemCount,
      itemBuilder: (_, _) => const RestaurantCardSkeleton(),
    );
  }
}

/// Single menu item row skeleton (matches restaurant detail menu card).
class MenuItemRowSkeleton extends StatelessWidget {
  const MenuItemRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: _ShimmerWrap(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SkeletonBox(width: 80, height: 80),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SkeletonBox(height: 16, width: 160),
                    SizedBox(height: AppSpacing.xs),
                    _SkeletonBox(height: 12, width: double.infinity),
                    SizedBox(height: 4),
                    _SkeletonBox(height: 12, width: 180),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const _SkeletonBox(width: 50, height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vertical list of menu item row skeletons.
class MenuItemListSkeleton extends StatelessWidget {
  final int itemCount;
  const MenuItemListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (_, _) => const MenuItemRowSkeleton(),
    );
  }
}

/// Single order card skeleton (matches consumer orders list card).
class OrderCardSkeleton extends StatelessWidget {
  const OrderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: _ShimmerWrap(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  _SkeletonBox(width: 90, height: 22, radius: AppRadius.full),
                  Spacer(),
                  _SkeletonBox(width: 60, height: 12),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: const [
                  _SkeletonBox(width: 120, height: 15),
                  Spacer(),
                  _SkeletonBox(width: 60, height: 16),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              const _SkeletonBox(width: double.infinity, height: 13),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vertical list of order card skeletons.
class OrderListSkeleton extends StatelessWidget {
  final int itemCount;
  const OrderListSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (_) => const OrderCardSkeleton()),
    );
  }
}
