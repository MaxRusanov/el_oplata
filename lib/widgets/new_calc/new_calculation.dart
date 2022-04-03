import 'package:flutter/material.dart';
import 'package:el_oplata/widgets/new_calc/new_calc_model.dart';
import 'package:el_oplata/adapters/settings_adapter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:el_oplata/widgets/add_func.dart';

////////// Основной NewCalcWidget
class NewCalcWidget extends StatefulWidget {
  const NewCalcWidget({Key? key}) : super(key: key);

  static const routeName = '/extractArgumentsNewCalc';

  @override
  State<NewCalcWidget> createState() => _NewCalcWidgetState();
}

class _NewCalcWidgetState extends State<NewCalcWidget> {
  final _model = NewCalcModel();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Settings;

    ////////// подключаем provider для передачи по дереву аргументов пришедших из app.dart
    return ChangeNotifierProvider<Settings>(
      create: (context) => args,
      ///////// Через инхерит следим за нашей моделью NewCalcModel
      child: NewCalcModelProvider(
        model: _model,
        child: const NewCalcWidgetBody(),
      ),
    );
  }
}

class NewCalcWidgetBody extends StatelessWidget {
  const NewCalcWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isVisible = false;
    if (NewCalcModelProvider.watch(context)?.model.costT1Result != null) {
      _isVisible = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый расчёт'),
        centerTitle: true,
      ),
      floatingActionButton: _isVisible
          ? FloatingActionButton(
              onPressed: () {
                NewCalcModelProvider.read(context)?.model.saveNewCalc();
                Navigator.of(context).pop();
              },
              tooltip: 'Сохранить расчёт',
              child: const Icon(Icons.save),
            )
          : null,
      body: const SafeArea(
        // child: ElevatedButton(
        //   onPressed: () =>
        //       NewCalcModelProvider.read(context)?.model.deleteAllCalcs(),
        //   child: const Text('Удалить всё из DataList'),
        // ),
        child: MainCalcWidget(),
      ),
    );
  }
}

class MainCalcWidget extends StatelessWidget {
  const MainCalcWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: const [
        SizedBox(height: 10),
        WidgetMonthYear(),
        SizedBox(height: 10),
        PostValuesT1(),
        SizedBox(height: 10),
        PostValuesT2(),
        SizedBox(height: 10),
        NewValuesT1(),
        SizedBox(height: 10),
        NewValuesT2(),
        SizedBox(height: 5),
        SummButtonWidget(),
        SizedBox(height: 5),
        ResultWidget(),
      ]),
    );
  }
}

class SummButtonWidget extends StatelessWidget {
  const SummButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        NewCalcModelProvider.read(context)?.model.postDate =
            context.read<Settings>().postDate;
        NewCalcModelProvider.read(context)?.model.postT1 =
            context.read<Settings>().postT1;
        NewCalcModelProvider.read(context)?.model.postT2 =
            context.read<Settings>().postT2;
        NewCalcModelProvider.read(context)?.model.tariffBefore150 =
            context.read<Settings>().tariffBefore150;
        NewCalcModelProvider.read(context)?.model.tariffOver150 =
            context.read<Settings>().tariffOver150;

        NewCalcModelProvider.read(context)?.model.calcResult();
      },
      child: const Text('Расчитать'),
    );
  }
}

class WidgetMonthYear extends StatelessWidget {
  const WidgetMonthYear({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newDate = addMonth(context.read<Settings>().postDate);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: const BorderRadius.all(Radius.circular(7)),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 10),
          const Text('Период: ', style: TextStyle(color: Colors.grey)),
          Text(monthYearFromDate(newDate.toString())),
        ],
      ),
    );
  }
}

//// PostValuesT1
class PostValuesT1 extends StatelessWidget {
  const PostValuesT1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: context.read<Settings>().postT1.toString(),
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isCollapsed: true,
        contentPadding: EdgeInsets.all(10.0),
        labelText: 'Предыдущие показания Т1',
      ),
    );
  }
}

//// PostValuesT2
class PostValuesT2 extends StatelessWidget {
  const PostValuesT2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: context.read<Settings>().postT2.toString(),
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isCollapsed: true,
        contentPadding: EdgeInsets.all(10.0),
        labelText: 'Предыдущие показания Т2',
      ),
    );
  }
}

//// NewValuesT1
class NewValuesT1 extends StatelessWidget {
  const NewValuesT1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isCollapsed: true,
        contentPadding: EdgeInsets.all(10.0),
        labelText: 'Новые показания Т1',
        hintText: 'Введите показания для Т1',
        // errorText: 'Новые показания Т1 должны быть больше предыдцщих показаний Т1'
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) =>
          NewCalcModelProvider.read(context)?.model.newT1 = value,
    );
  }
}

//// NewValuesT2
class NewValuesT2 extends StatelessWidget {
  const NewValuesT2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      // autofocus: true,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isCollapsed: true,
        contentPadding: EdgeInsets.all(10.0),
        labelText: 'Новые показания Т2',
        hintText: 'Введите показания для Т2',
        // errorText: 'Новые показания Т2 должны быть больше предыдцщих показаний Т2'
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) =>
          NewCalcModelProvider.read(context)?.model.newT2 = value,
    );
  }
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final costT1 = NewCalcModelProvider.watch(context)?.model.costT1Result ?? 0;
    final costT2 = NewCalcModelProvider.watch(context)?.model.costT2Result ?? 0;
    bool _isVisible = false;
    if (NewCalcModelProvider.watch(context)?.model.costT1Result != null) {
      _isVisible = true;
    }

    return _isVisible
        ? Column(
            children: [
              Table(border: TableBorder.all(), children: [
                const TableRow(children: [
                  Text(
                    'Сумма, руб.',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Начальные показания, кВт*ч',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Конечные показания, кВт*ч',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Разница, кВт*ч',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '$costT1,00',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${NewCalcModelProvider.watch(context)?.model.getPostT1}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${NewCalcModelProvider.watch(context)?.model.getNewT1}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${NewCalcModelProvider.watch(context)?.model.totalT1}',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '$costT2,00',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${NewCalcModelProvider.watch(context)?.model.getPostT2}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${NewCalcModelProvider.watch(context)?.model.getNewT2}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${NewCalcModelProvider.watch(context)?.model.totalT2}',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '${costT1 + costT2},00',
                    textAlign: TextAlign.center,
                  ),
                  const Text(''),
                  const Text(''),
                  const Text(''),
                ]),
              ]),
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тариф до 150 кВтч: ${NewCalcModelProvider.watch(context)?.model.getTariffBefore150} руб.',
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Тариф свыше 150 кВтч: ${NewCalcModelProvider.watch(context)?.model.getTariffOver150} руб.',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }
}
