import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget child;

  const BaseLayout({super.key, this.appBar, this.backgroundColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
