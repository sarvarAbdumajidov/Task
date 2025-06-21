import 'package:hive/hive.dart';
import 'package:interesting_number/features/number/data/models/number_model.dart';

class HiveService {
  static const String boxName = 'numbers';
  final box = Hive.box<Number>(boxName);
  Future<void> saveNumber(Number number) async {
    await box.add(number);
  }

  List<Number> getAllNumbers() {
    return box.values.toList();
  }

  Future<void> deleteNumber(int index) async {
    await box.deleteAt(index);
  }

  Future<void> clearAll() async {
    await box.clear();
  }
}
