import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:interesting_number/features/number/data/models/number_model.dart';
import 'package:interesting_number/number_fact_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NumberAdapter());
  await Hive.openBox<Number>('numbers');
  runApp(NumberFactApp());
}
