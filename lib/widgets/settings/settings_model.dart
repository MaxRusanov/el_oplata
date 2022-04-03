import 'package:el_oplata/data_provider/box_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:el_oplata/adapters/settings_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';

////////// Model extends ChangeNotifier
class SettingsModel extends ChangeNotifier {
  late final Future<Box<Settings>> _settingsBox;

  int _postT1 = 0;
  int _postT2 = 0;
  double _tariffBefore150 = 0.0;
  double _tariffOver150 = 0.0;
  String _postDate = '2000-12-31';

  set postT1(String value) => _postT1 = int.tryParse(value) ?? 0;
  set postT2(String value) => _postT2 = int.tryParse(value) ?? 0;
  set tariffBefore150(String value) =>
      _tariffBefore150 = double.tryParse(value) ?? 0.0;
  set tariffOver150(String value) =>
      _tariffOver150 = double.tryParse(value) ?? 0.0;
  set postDate(String value) => _postDate = value;

  Future<void> saveSettings(BuildContext context) async {
    _settingsBox = BoxManager.instance.openSettingsBox();
    final tmpSettings = Settings(
        postT1: _postT1,
        postT2: _postT2,
        tariffBefore150: _tariffBefore150,
        tariffOver150: _tariffOver150,
        postDate: _postDate);
    (await _settingsBox).put('settings', tmpSettings);
    BoxManager.instance.closeBox(await _settingsBox);
    // notifyListeners(); //чтобы подписчики узнали о изменении модели
  }

  // @override
  // Future<void> dispose() async {
  //   // _listenableSettingsBox?.removeListener(() => _readSettingsFromHive());
  //   await BoxManager.instance.closeBox(await _settingsBox);
  //   super.dispose();
  // }
}

//////////// Provider extends InheritedNotifier
class SettingsModelProvider extends InheritedNotifier {
  final SettingsModel model;

  const SettingsModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static SettingsModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsModelProvider>();
  }

  static SettingsModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<SettingsModelProvider>()
        ?.widget;
    return widget is SettingsModelProvider ? widget : null;
  }
}
