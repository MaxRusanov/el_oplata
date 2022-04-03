import 'package:flutter/material.dart';
import 'package:el_oplata/widgets/app/app_model.dart';
import 'package:el_oplata/widgets/settings/settings.dart';
import 'package:el_oplata/adapters/settings_adapter.dart';
import 'package:el_oplata/adapters/data_adapter.dart';
import 'package:el_oplata/widgets/new_calc/new_calculation.dart';
import 'package:el_oplata/widgets/open_calc/open_calculation.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

////////////// Основной MyAppWidget
class MyAppWidget extends StatefulWidget {
  const MyAppWidget({Key? key}) : super(key: key);

  @override
  State<MyAppWidget> createState() => _MyAppWidgetState();
}

class _MyAppWidgetState extends State<MyAppWidget> {
  final model = SettingesModel();

  @override
  //Перед удалением виджета из дерева виджетов
  void dispose() async {
    await model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingesModelProvider(
      model: model,
      child: const MyAppWidgetBody(),
    );
  }
}

class MyAppWidgetBody extends StatelessWidget {
  const MyAppWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лицевой счёт: 7-9-29'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          // onPressed: () => Navigator.of(context).pushNamed('/settings'),
          onPressed: () => Navigator.pushNamed(
            context,
            SettingsWidget.routeName,
            arguments:
                Settings(
                    postT1: SettingesModelProvider.watch(context)
                            ?.model
                            .settings
                            .postT1 ??
                        0,
                    postT2: SettingesModelProvider.watch(context)
                            ?.model
                            .settings
                            .postT2 ??
                        0,
                    tariffBefore150: SettingesModelProvider.watch(context)
                            ?.model
                            .settings
                            .tariffBefore150 ??
                        0.0,
                    tariffOver150: SettingesModelProvider.watch(context)
                            ?.model
                            .settings
                            .tariffOver150 ??
                        0.0,
                    postDate: SettingesModelProvider.watch(context)
                            ?.model
                            .settings
                            .postDate ??
                        '2000-12-31'),
          ),
        ),
      ),
      // body: ElevatedButton(
      //   onPressed: () =>
      //       SettingesModelProvider.read(context)?.model.deleteAllSettings(),
      //   child: const Text('Удалить настройки - Settings'),
      // ),
      body: const DataResultsWidget(),
      floatingActionButton: FloatingActionButton(
        // onPressed: () => Navigator.pushNamed(context, '/new_calc'),
        onPressed: () => Navigator.pushNamed(
          context,
          NewCalcWidget.routeName,
          arguments: Settings(
              postT1: SettingesModelProvider.watch(context)
                      ?.model
                      .settings
                      .postT1 ??
                  0,
              postT2: SettingesModelProvider.watch(context)
                      ?.model
                      .settings
                      .postT2 ??
                  0,
              tariffBefore150: SettingesModelProvider.watch(
                          context)
                      ?.model
                      .settings
                      .tariffBefore150 ??
                  0.0,
              tariffOver150: SettingesModelProvider.watch(context)
                      ?.model
                      .settings
                      .tariffOver150 ??
                  0.0,
              postDate: SettingesModelProvider.watch(context)
                      ?.model
                      .settings
                      .postDate ??
                  '2000-12-31'),
        ),
        tooltip: 'Добавить новый расчёт',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DataResultsWidget extends StatefulWidget {
  const DataResultsWidget({Key? key}) : super(key: key);

  @override
  State<DataResultsWidget> createState() => _DataResultsWidgetState();
}

class _DataResultsWidgetState extends State<DataResultsWidget> {
  final _model = DataModel();

  @override
  Widget build(BuildContext context) {
    return DataModelProvider(
      model: _model,
      child: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DataResultsWidgetBody(),
          ),
        ),
      ),
    );
  }
}

class DataResultsWidgetBody extends StatelessWidget {
  const DataResultsWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int listCount =
        DataModelProvider.watch(context)?.model.getDataList.length ?? 0;

    return ListView.separated(
      itemCount: listCount,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 1,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return _DataListRowWidget(
          indexInList: index,
        );
      },
    );
  }
}

class _DataListRowWidget extends StatelessWidget {
  final int indexInList;
  const _DataListRowWidget({
    Key? key,
    required this.indexInList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _element = DataModelProvider.read(context)
            ?.model
            .getDataList[indexInList]
            .postMonthYear ??
        'AAAA';
    // int _keyElement = indexInList;
    var _keyElement = DataModelProvider.read(context)
        ?.model
        .getDataList[indexInList]
        .keyFromHive;

    return Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            /////// вызов удаления расяёта в модели DataModel (в Hive)
            onPressed: (context) =>
                DataModelProvider.read(context)?.model.deleteData(_keyElement),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ]),
        child: ListTile(
          title:
              // Text('$_element     (key=$_keyElement)'), ///////!!!!!!!!!!!!!!!!
              Text(_element),
          trailing: const Icon(Icons.chevron_right),
          // onTap: () {},
          ////////// вередача в аргументы для окна open_calculation.dart расчёта выбранного месяца
          onTap: () => Navigator.pushNamed(
            context,
            OpenCalculationWidget.routeName,
            arguments: DataCalc(
              postMonthYear: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .postMonthYear ??
                  'AAA',
              postT1: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .postT1 ??
                  0,
              postT2: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .postT2 ??
                  0,
              newT1: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .newT1 ??
                  0,
              newT2: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .newT2 ??
                  0,
              tariffBefore150: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .tariffBefore150 ??
                  0.0,
              tariffOver150: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .tariffOver150 ??
                  0.0,
              postDate: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .postDate ??
                  '2000-12-31',
              totalT1: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .totalT1 ??
                  0,
              totalT2: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .totalT2 ??
                  0,
              costT1Result: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .costT1Result ??
                  0,
              costT2Result: DataModelProvider.read(context)
                      ?.model
                      .getDataList[indexInList]
                      .costT2Result ??
                  0,
            ),
          ),
        ));
  }
}
