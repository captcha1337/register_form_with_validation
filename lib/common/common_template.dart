import 'package:flutter/material.dart';

class CommonTemplate extends StatelessWidget {
  final Widget child;
  const CommonTemplate({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: child,
              ),
            ),
          ),
        )
      ],
    );
  }
}
