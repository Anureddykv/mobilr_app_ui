import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/buildSectionTitle.dart';

Widget HorizontalCardList<T>({
  required String title,
  required List<T> items,
  required Widget Function(BuildContext context, T item) cardBuilder,
  double listHeight = 320.0,
}) {
  if (items.isEmpty) {
    return const SizedBox.shrink();
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildSectionTitle(title),
      SizedBox(
        height: listHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              margin: EdgeInsets.only(right: index == items.length - 1 ? 0 : 14),
              child: cardBuilder(context, item),
            );
          },
        ),
      ),
    ],
  );
}