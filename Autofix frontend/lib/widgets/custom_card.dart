import "package:flutter/material.dart";
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow>? boxShadow;

  const CustomCard({
    super.key,
    this.title,
    required this.child,
    this.backgroundColor = AppColors.white,
    this.padding = const EdgeInsets.all(24.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.boxShadow = const [
      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.grey, width: 0.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blueGrey,
                    ),
                  ),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}
