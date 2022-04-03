import 'package:flutter/material.dart';
import 'package:el_oplata/adapters/data_adapter.dart';

class MyArgsProvider extends InheritedNotifier {
  final DataCalc model;

  const MyArgsProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static MyArgsProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyArgsProvider>();
  }

  static MyArgsProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<MyArgsProvider>()
        ?.widget;
    return widget is MyArgsProvider ? widget : null;
  }
}

class OpenCalculationWidget extends StatefulWidget {
  const OpenCalculationWidget({Key? key}) : super(key: key);

  static const routeName = '/extractArgumentsOpenCalc';

  @override
  State<OpenCalculationWidget> createState() => _OpenCalculationWidgetState();
}

class _OpenCalculationWidgetState extends State<OpenCalculationWidget> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DataCalc;

    return MyArgsProvider(
      model: args,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Расчёт: ${args.postMonthYear}'),
          centerTitle: true,
        ),
        body: const SafeArea(
          child: MainCalcWidget(),
        ),
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
        SizedBox(
          height: 10,
        ),
        PostValuesT1(),
        SizedBox(
          height: 10,
        ),
        PostValuesT2(),
        SizedBox(
          height: 10,
        ),
        NewValuesT1(),
        SizedBox(
          height: 10,
        ),
        NewValuesT2(),
        SizedBox(
          height: 10,
        ),
        ResultWidget(),
      ]),
    );
  }
}

class PostValuesT1 extends StatelessWidget {
  const PostValuesT1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: MyArgsProvider.read(context)?.model.postT1.toString(),
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

class PostValuesT2 extends StatelessWidget {
  const PostValuesT2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: MyArgsProvider.read(context)?.model.postT2.toString(),
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

class NewValuesT1 extends StatelessWidget {
  const NewValuesT1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: MyArgsProvider.read(context)?.model.newT1.toString(),
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isCollapsed: true,
        contentPadding: EdgeInsets.all(10.0),
        labelText: 'Новые показания Т1',
      ),
    );
  }
}

class NewValuesT2 extends StatelessWidget {
  const NewValuesT2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: MyArgsProvider.read(context)?.model.newT2.toString(),
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isCollapsed: true,
        contentPadding: EdgeInsets.all(10.0),
        labelText: 'Новые показания Т2',
      ),
    );
  }
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final costT1 = MyArgsProvider.read(context)?.model.costT1Result ?? 0;
    final costT2 = MyArgsProvider.read(context)?.model.costT2Result ?? 0;

    return Column(
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
              '${MyArgsProvider.read(context)?.model.costT1Result},00',
              textAlign: TextAlign.center,
            ),
            Text(
              '${MyArgsProvider.read(context)?.model.postT1}',
              textAlign: TextAlign.center,
            ),
            Text(
              '${MyArgsProvider.read(context)?.model.newT1}',
              textAlign: TextAlign.center,
            ),
            Text(
              '${MyArgsProvider.read(context)?.model.totalT1}',
              textAlign: TextAlign.center,
            ),
          ]),
          TableRow(children: [
            Text(
              '${MyArgsProvider.read(context)?.model.costT2Result},00',
              textAlign: TextAlign.center,
            ),
            Text(
              '${MyArgsProvider.read(context)?.model.postT2}',
              textAlign: TextAlign.center,
            ),
            Text(
              '${MyArgsProvider.read(context)?.model.newT2}',
              textAlign: TextAlign.center,
            ),
            Text(
              '${MyArgsProvider.read(context)?.model.totalT2}',
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
                'Тариф до 150 кВтч: ${MyArgsProvider.read(context)?.model.tariffBefore150} руб.',
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                'Тариф свыше 150 кВтч: ${MyArgsProvider.read(context)?.model.tariffOver150} руб.',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
