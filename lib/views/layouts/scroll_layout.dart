import 'package:flutter/material.dart';
import 'package:project_cipher/utils/palette.dart';

class ScrollLayout extends StatelessWidget {
  final Widget headerChild;
  final Widget bodyChild;
  final double toolbarHeight;
  final Color? backgroundColor;

  // Nuevos parámetros
  final bool isEmpty;
  final bool showEmptyMessage;
  final String emptyMessage;

  const ScrollLayout({
    super.key,
    required this.headerChild,
    required this.bodyChild,
    this.toolbarHeight = 300,
    this.backgroundColor,
    this.isEmpty = false,
    this.showEmptyMessage = true,
    this.emptyMessage = "No hay datos disponibles.",
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          pinned: true,
          toolbarHeight: toolbarHeight,
          backgroundColor: backgroundColor ?? Palette(context).secondary,
          shadowColor: Colors.black,
          title: Center(child: headerChild),
        ),
        if (isEmpty && showEmptyMessage)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  emptyMessage,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ),
          )
        else
          bodyChild,
      ],
    );
  }
}
