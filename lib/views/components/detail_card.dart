import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final List<DetailItem> items;

  const DetailCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
        subtitle: Wrap(
          spacing: 16,
          runSpacing: 8,
          children: items.map((item) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DetailItem {
  final String label;
  final String value;

  const DetailItem({
    required this.label,
    required this.value,
  });
}
