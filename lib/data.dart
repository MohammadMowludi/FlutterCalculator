
import 'package:hive_flutter/adapters.dart';
part 'data.g.dart';
// dastore sakhte adaptorha
// flutter packages pub run build_runner build

@HiveType(typeId: 0)
class History extends HiveObject {
  @HiveField(0)
    late String calculate;
  @HiveField(1)
    late String time;
}

@HiveType(typeId: 1)
class ThemeLightNight extends HiveObject {
  @HiveField(0)
   late bool darkMode;
}