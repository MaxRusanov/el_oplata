import 'package:el_oplata/data_provider/box_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:el_oplata/adapters/settings_adapter.dart';
import 'package:el_oplata/adapters/data_adapter.dart';
import 'package:el_oplata/widgets/add_func.dart';
import 'package:hive_flutter/hive_flutter.dart';

///////// Модель для расяёта и выдачи результата с последующей записью
///////// в Hive (в два хранилища: el_oplata_settings_box и el_oplata_list_box)
////////// Model extends ChangeNotifier
class NewCalcModel extends ChangeNotifier {
  late final Future<Box<Settings>> _settingsBox;
  late final Future<Box<DataCalc>> _dataCalcBox;

  int _postT1 = 0;
  int _postT2 = 0;
  int _newT1 = 0;
  int _newT2 = 0;
  double _tariffBefore150 = 0.0;
  double _tariffOver150 = 0.0;
  String _postDate = '2000-12-31'; // 'yyyy-mm-dd'
  int? totalT1;
  int? totalT2;
  int? costT1Result;
  int? costT2Result;

  int get getPostT1 => _postT1;
  int get getPostT2 => _postT2;
  int get getNewT1 => _newT1;
  int get getNewT2 => _newT2;
  double get getTariffBefore150 => _tariffBefore150;
  double get getTariffOver150 => _tariffOver150;
  String get getPostDate => _postDate;

  set postT1(int value) => _postT1 = value;
  set postT2(int value) => _postT2 = value;
  set newT1(String value) => _newT1 = int.tryParse(value) ?? 0;
  set newT2(String value) => _newT2 = int.tryParse(value) ?? 0;
  set tariffBefore150(double value) => _tariffBefore150 = value;
  set tariffOver150(double value) => _tariffOver150 = value;
  set postDate(String value) => _postDate = value;

  void changePostT1(String value) {
    _postT1 = int.tryParse(value) ?? -1;
    notifyListeners(); //чтобы подписчики узнали о изменении модели
  }

  void changePostT2(String value) {
    _postT2 = int.tryParse(value) ?? -1;
    notifyListeners(); //чтобы подписчики узнали о изменении модели
  }

  void calcResult() {
    int? differenceT1;
    int? differenceT2;
    double? summT1;
    double? summT2;

    summT1 = null;
    summT2 = null;
    differenceT1 = null;
    differenceT2 = null;

    final summ = (_newT1 - _postT1) + (_newT2 - _postT2);
    differenceT1 = _newT1 - _postT1;
    differenceT2 = _newT2 - _postT2;
    summT1 = 0;
    summT2 = 0;

    int n = (150 / summ * (_newT1 - _postT1)).ceil();
    summT1 += 1 * _tariffBefore150 * n;

    n = (150 / summ * (_newT2 - _postT2)).ceil();
    summT2 += 0.7 * _tariffBefore150 * n;

    n = ((summ - 150) / summ * (_newT1 - _postT1)).ceil();
    summT1 += 1 * _tariffOver150 * n;

    n = ((summ - 150) / summ * (_newT2 - _postT2)).ceil();
    summT2 += 0.7 * _tariffOver150 * n;

    if (costT1Result != summT1 ||
        costT2Result != summT2 ||
        totalT1 != differenceT1 ||
        totalT2 != differenceT2) {
      totalT1 = differenceT1;
      totalT2 = differenceT2;
      costT1Result = summT1.ceil();
      costT2Result = summT2.ceil();
      notifyListeners(); //чтобы подписчики узнали о изменении модели
    }
  }

  void saveNewCalc() async {
    /////// Сохранение в Hive-settings
    _settingsBox = BoxManager.instance.openSettingsBox();
    final tmpDate = addMonth(_postDate);
    final title = monthYearFromDate(tmpDate);
    final tmpSettings = Settings(
        postT1: _newT1,
        postT2: _newT2,
        tariffBefore150: _tariffBefore150,
        tariffOver150: _tariffOver150,
        postDate: tmpDate);
    (await _settingsBox).put('settings', tmpSettings);
    BoxManager.instance.closeBox(await _settingsBox);

    //////  Сохранение в Hive-таблице объектов
    _dataCalcBox = BoxManager.instance.openDataCalcBox();
    final obj = DataCalc(
      postMonthYear: title,
      postT1: _postT1,
      postT2: _postT2,
      newT1: _newT1,
      newT2: _newT2,
      tariffBefore150: _tariffBefore150,
      tariffOver150: _tariffOver150,
      postDate: tmpDate,
      totalT1: totalT1 ?? 0,
      totalT2: totalT2 ?? 0,
      costT1Result: costT1Result ?? 0,
      costT2Result: costT2Result ?? 0,
    );
    (await _dataCalcBox).add(obj);
    BoxManager.instance.closeBox(await _dataCalcBox);
    notifyListeners(); //чтобы подписчики узнали о изменении модели
  }

  void deleteAllCalcs() async {
    _dataCalcBox = BoxManager.instance.openDataCalcBox();
    (await _dataCalcBox).deleteFromDisk();
    BoxManager.instance.closeBox(await _dataCalcBox);
  }
}

//////////// Provider extends InheritedNotifier
class NewCalcModelProvider extends InheritedNotifier {
  final NewCalcModel model;

  const NewCalcModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static NewCalcModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NewCalcModelProvider>();
  }

  static NewCalcModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NewCalcModelProvider>()
        ?.widget;
    return widget is NewCalcModelProvider ? widget : null;
  }
}
