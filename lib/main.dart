import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'config/dependencies.dart';

void main() {
  runApp(
    MultiProvider(
      providers: providers, // service + repository (config/dependencies.dart)
      child: const NusaKampusApp(),
    ),
  );
}
