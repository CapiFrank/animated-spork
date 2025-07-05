import 'package:flutter/material.dart';

class PieceDetail {
  final String label;
  final String value;

  PieceDetail({required this.label, required this.value});
}

class PieceDetailsCard extends StatelessWidget {
  final String title;
  final List<PieceDetail> details;

  const PieceDetailsCard({
    super.key,
    required this.title,
    required this.details,
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
          children: details
              .map(
                (detail) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      detail.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
