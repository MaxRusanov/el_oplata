import 'package:el_oplata/adapters/data_adapter.dart';
import 'package:el_oplata/adapters/settings_adapter.dart';
import 'package:hive/hive.dart';

class BoxManager {
  //будет только единственный экземпляр этого класса во всём приложении
  static final BoxManager instance = BoxManager._();
  // счётчик открытых/закрытых Hive.box
  final Map<String, int> _boxCounter = <String, int>{};

  // невозможно будет создать самостоятельно в приложении сождать объект(экземпляр) этого класса
  BoxManager._();

  Future<Box<Settings>> openSettingsBox() async {
    // final box = await Hive.openBox<Settings>('el_oplata_settings_box'); typeId=0
    return _openBox('el_oplata_settings_box', 0, SettingsAdapter());
  }

  Future<Box<DataCalc>> openDataCalcBox() async {
    // final boxData = await Hive.openBox<DataCalc>('el_oplata_list_box'); typeId=1
    return _openBox('el_oplata_list_box', 1, DataCalcAdapter());
  }

  Future<Box<T>> _openBox<T>(
    String nameBox,
    int typeId,
    TypeAdapter<T> adapter,
  ) async {
    if (Hive.isBoxOpen(nameBox)) {
      int count = _boxCounter[nameBox] ?? 1;
      count += 1;
      _boxCounter[nameBox] = count;
      return Hive.box(nameBox);
    }

    _boxCounter[nameBox] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    // final box = await Hive.openBox<Settings>('el_oplata_settings_box'); typeId=0
    // final boxData = await Hive.openBox<DataCalc>('el_oplata_list_box'); typeId=1
    return Hive.openBox<T>(nameBox);
  }

  Future<void> closeBox<T>(Box<T> box) async {
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
      return;
    }

    int count = _boxCounter[box.name] ?? 1;
    count -= 1;
    _boxCounter[box.name] = count;
    if (count > 0) return;

    _boxCounter.remove(box.name);
    await box.compact();
    await box.close();
  }
}
