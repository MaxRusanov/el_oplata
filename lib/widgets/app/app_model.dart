import 'package:el_oplata/data_provider/box_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:el_oplata/adapters/settings_adapter.dart';
import 'package:el_oplata/adapters/data_adapter.dart';

///////// Модель для считывания из Hive настроек и последующей передачи объекта
///////// класса Settings в виде аргументов для new_calculation.dart и settings.dart
////////// Modl extends ChangeNotifier
class SettingesModel extends ChangeNotifier {
  late final Future<Box<Settings>> _settingsBox;
  ValueListenable<Object>? _listenableSettingsBox;
  late Settings settings;

  SettingesModel() {
    _setup();
  }

  Future<void> _readSettingsFromHive() async {
    if ((await _settingsBox).isNotEmpty) {
      settings = (await _settingsBox).get('settings')!;
      notifyListeners(); //чтобы подписчики узнали о изменении модели
    } else {
      settings = Settings(
          postT1: 0,
          postT2: 0,
          postDate: '2000-12-31',
          tariffBefore150: 0.0,
          tariffOver150: 0.0);
    }
  }

  Future<void> _setup() async {
    _settingsBox = BoxManager.instance.openSettingsBox();
    await _readSettingsFromHive();
    _listenableSettingsBox = (await _settingsBox).listenable();
    _listenableSettingsBox?.addListener(() => _readSettingsFromHive());
  }

  Future<void> deleteAllSettings() async {
    _settingsBox = BoxManager.instance.openSettingsBox();
    (await _settingsBox).deleteFromDisk();
    BoxManager.instance.closeBox(await _settingsBox);
  }

  @override
  Future<void> dispose() async {
    _listenableSettingsBox?.removeListener(() => _readSettingsFromHive());
    await BoxManager.instance.closeBox(await _settingsBox);
    super.dispose();
  }
}

////////// Provider extends InheritedNotifier
class SettingesModelProvider extends InheritedNotifier {
  final SettingesModel model;

  const SettingesModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static SettingesModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingesModelProvider>();
  }

  static SettingesModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<SettingesModelProvider>()
        ?.widget;
    return widget is SettingesModelProvider ? widget : null;
  }
}

///////// Модель для отображения списка считанных из Hive расчётов за предыдущие месяца
////////// Modl extends ChangeNotifier
class DataModel extends ChangeNotifier {
  late final Future<Box<DataCalc>> _dataCalcBox;
  ValueListenable<Object>? _listenableDataCalcBox;
  var _dataList = <DataCalc>[];

  List<DataCalc> get getDataList => _dataList.toList();

  DataModel() {
    _setup();
  }
  Future<void> _readDataListFromHive() async {
    if ((await _dataCalcBox).isNotEmpty) {
      _dataList = [];
      _dataList = (await _dataCalcBox).values.toList();
      for (var i = 0; i < _dataList.length; i++) {
        _dataList[i].keyFromHive = (await _dataCalcBox).keyAt(i);
      }

      _dataList = _dataList.reversed.toList();
      notifyListeners(); //чтобы подписчики узнали о изменении модели
    }
  }

  Future<void> _setup() async {
    _dataCalcBox = BoxManager.instance.openDataCalcBox();
    await _readDataListFromHive();
    _listenableDataCalcBox = (await _dataCalcBox).listenable();
    _listenableDataCalcBox?.addListener(() => _readDataListFromHive());
  }

  Future<void> deleteData(int dataKey) async {
    // final boxData = await BoxManager.instance.openDataCalcBox();
    (await _dataCalcBox).delete(dataKey);
  }

  void deleteAll() async {
    // final boxData = await BoxManager.instance.openDataCalcBox();
    (await _dataCalcBox).deleteFromDisk();
    // await boxData.close();
  }

  @override
  Future<void> dispose() async {
    _listenableDataCalcBox?.removeListener(() => _readDataListFromHive());
    await BoxManager.instance.closeBox((await _dataCalcBox));
    super.dispose();
  }
}

////////// Provider extends InheritedNotifier
class DataModelProvider extends InheritedNotifier {
  final DataModel model;

  const DataModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static DataModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataModelProvider>();
  }

  static DataModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<DataModelProvider>()
        ?.widget;
    return widget is DataModelProvider ? widget : null;
  }
}
