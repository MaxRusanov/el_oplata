import 'package:flutter/material.dart';
import 'package:el_oplata/widgets/settings/settings_model.dart';
import 'package:el_oplata/adapters/settings_adapter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:el_oplata/widgets/add_func.dart';

////////////// Основной SettingsWidget
class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  static const routeName = '/extractArgumentsSettings';

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final _model = SettingsModel();

  // @override
  // //Перед удалением виджета из дерева виджетов
  // void dispose() async {
  //   await _model.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Settings;

    return ChangeNotifierProvider<Settings>(
      create: (context) => args,
      child: SettingsModelProvider(
        model: _model,
        // child: Text('${args.postT1}'),
        child: const SettingsWidgetBody(),
      ),
    );
  }
}

class SettingsWidgetBody extends StatelessWidget {
  const SettingsWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
      ),
      body: const SafeArea(
        // child: Text('data'),
        child: MainSettingsWidget(),
      ),
    );
  }
}

class MainSettingsWidget extends StatelessWidget {
  const MainSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: const [
          SizedBox(height: 10),
          WidgetMonthYear(),
          SizedBox(height: 10),
          PostValuesT1(),
          SizedBox(height: 10),
          PostValuesT2(),
          SizedBox(height: 10),
          ValuesTariffBefore150(),
          SizedBox(height: 10),
          ValuesTariffOver150(),
          SizedBox(height: 20),
          WidgetSaveButton(),
        ],
      ),
    );
  }
}

class WidgetSaveButton extends StatelessWidget {
  const WidgetSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        SettingsModelProvider.read(context)?.model.saveSettings(context);
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.save),
      label: const Text('Сохранить'),
    );
  }
}

class WidgetMonthYear extends StatefulWidget {
  const WidgetMonthYear({Key? key}) : super(key: key);

  @override
  State<WidgetMonthYear> createState() => _WidgetMonthYearState();
}

class _WidgetMonthYearState extends State<WidgetMonthYear> {
  final String initialDate = '2000-01-01';
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.parse(context.read<Settings>().postDate);
    SettingsModelProvider.read(context)?.model.postDate = _dateTime.toString();
  }

  @override
  Widget build(BuildContext context) {
    int _tmpYear = _dateTime.year;
    DateTime _firstDate = DateTime.parse('${_tmpYear - 20}-01-01');
    DateTime _lastDate = DateTime.parse('${_tmpYear + 20}-01-01');

    void dateChenge() async {
      DateTime? _newDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: _firstDate,
        lastDate: _lastDate,
      );
      if (_newDate != null) {
        setState(() => _dateTime = _newDate);
        SettingsModelProvider.read(context)?.model.postDate =
            _newDate.toString();
      }
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: const BorderRadius.all(Radius.circular(7)),
      ),
      child: Row(children: [
        Flexible(
          child: InkWell(
            onTap: dateChenge,
            child: IgnorePointer(
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 10),
                  const Text('Период: ', style: TextStyle(color: Colors.grey)),
                  Text(monthYearFromDate(_dateTime.toString())),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

//// PostValuesT1
class PostValuesT1 extends StatefulWidget {
  const PostValuesT1({Key? key}) : super(key: key);

  @override
  State<PostValuesT1> createState() => _PostValuesT1State();
}

class _PostValuesT1State extends State<PostValuesT1> {
  var myController = TextEditingController(text: '');
  int firstVal = 0;

  @override
  Widget build(BuildContext context) {
    if (firstVal < 2) {
      myController.text = context.read<Settings>().postT1.toString();
      SettingsModelProvider.read(context)?.model.postT1 = myController.text;
      firstVal += 1;
    }
    return TextField(
        controller: myController,
        // autofocus: true,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          isCollapsed: true,
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'Предыдущие показания Т1',
        ),
        onChanged: (value) =>
            SettingsModelProvider.read(context)?.model.postT1 = value,
        onTap: () {
          myController.selection = TextSelection(
              baseOffset: 0, extentOffset: myController.value.text.length);
        });
  }
}

//// PostValuesT2
class PostValuesT2 extends StatefulWidget {
  const PostValuesT2({Key? key}) : super(key: key);

  @override
  State<PostValuesT2> createState() => _PostValuesT2State();
}

class _PostValuesT2State extends State<PostValuesT2> {
  var myController = TextEditingController(text: '');
  int firstVal = 0;

  @override
  Widget build(BuildContext context) {
    if (firstVal < 2) {
      myController.text = context.read<Settings>().postT2.toString();
      SettingsModelProvider.read(context)?.model.postT2 = myController.text;
      firstVal += 1;
    }
    return TextField(
        controller: myController,
        // autofocus: true,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          isCollapsed: true,
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'Предыдущие показания Т2',
        ),
        onChanged: (value) =>
            SettingsModelProvider.read(context)?.model.postT2 = value,
        onTap: () {
          myController.selection = TextSelection(
              baseOffset: 0, extentOffset: myController.value.text.length);
        });
  }
}

//// ValuesTariffBefore150
class ValuesTariffBefore150 extends StatefulWidget {
  const ValuesTariffBefore150({Key? key}) : super(key: key);

  @override
  State<ValuesTariffBefore150> createState() => _ValuesTariffBefore150State();
}

class _ValuesTariffBefore150State extends State<ValuesTariffBefore150> {
  var myController = TextEditingController(text: '');
  int firstVal = 0;

  @override
  Widget build(BuildContext context) {
    if (firstVal < 2) {
      myController.text = context.read<Settings>().tariffBefore150.toString();
      SettingsModelProvider.read(context)?.model.tariffBefore150 =
          myController.text;
      firstVal += 1;
    }
    return TextField(
        controller: myController,
        // autofocus: true,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
        ],
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          isCollapsed: true,
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'Предыдущие показания тарифа до 150 кВтч',
        ),
        onChanged: (value) =>
            SettingsModelProvider.read(context)?.model.tariffBefore150 = value,
        onTap: () {
          myController.selection = TextSelection(
              baseOffset: 0, extentOffset: myController.value.text.length);
        });
  }
}

//// ValuesTariffOver150
class ValuesTariffOver150 extends StatefulWidget {
  const ValuesTariffOver150({Key? key}) : super(key: key);

  @override
  State<ValuesTariffOver150> createState() => _ValuesTariffOver150State();
}

class _ValuesTariffOver150State extends State<ValuesTariffOver150> {
  var myController = TextEditingController(text: '');
  int firstVal = 0;

  @override
  Widget build(BuildContext context) {
    if (firstVal < 2) {
      myController.text = context.read<Settings>().tariffOver150.toString();
      SettingsModelProvider.read(context)?.model.tariffOver150 =
          myController.text;
      firstVal += 1;
    }
    return TextField(
        controller: myController,
        // autofocus: true,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
        ],
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          isCollapsed: true,
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'Предыдущие показания тарифа свыше 150 кВтч',
        ),
        onChanged: (value) =>
            SettingsModelProvider.read(context)?.model.tariffOver150 = value,
        onTap: () {
          myController.selection = TextSelection(
              baseOffset: 0, extentOffset: myController.value.text.length);
        });
  }
}
