import 'package:flutter/material.dart';
import 'package:project_cipher/views/layouts/base_layout.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: CircularProgressIndicator(),
    );
  }
}
