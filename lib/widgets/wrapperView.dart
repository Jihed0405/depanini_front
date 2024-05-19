import 'package:depanini/widgets/app.dart';
import 'package:depanini/widgets/mainLayout.dart';
import 'package:flutter/material.dart';

class WrapperView extends StatelessWidget {
  final Widget view;

  WrapperView({required this.view});

  @override
  Widget build(BuildContext context) {
    return MainLayout(nestedView: view);
  }
}
