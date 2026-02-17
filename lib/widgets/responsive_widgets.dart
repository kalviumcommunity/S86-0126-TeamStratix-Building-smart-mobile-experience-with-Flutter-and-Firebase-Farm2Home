import 'package:flutter/material.dart';
import '../core/app_breakpoints.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: child,
        ),
      ),
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? EdgeInsets.all(context.responsivePadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.gridColumns,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

class ResponsiveTwoColumn extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;
  final double breakpoint;

  const ResponsiveTwoColumn({
    super.key,
    required this.leftChild,
    required this.rightChild,
    this.breakpoint = 900,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < breakpoint) {
      return Column(
        children: [
          leftChild,
          const SizedBox(height: AppSpacing.md),
          rightChild,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: leftChild),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: rightChild),
      ],
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double breakpoint;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.breakpoint = 600,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < breakpoint) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: child,
                ))
            .toList(),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children
          .map((child) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: child,
              ))
          .toList(),
    );
  }
}
