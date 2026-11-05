import 'package:flutter/material.dart';

import 'ui/core/theme.dart';
import 'ui/shell/app_shell.dart';

class NusaKampusApp extends StatelessWidget {
  const NusaKampusApp({super.key, this.clock});

  final DateTime Function()? clock;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaKampus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: AppShell(clock: clock),
    );
  }
}
