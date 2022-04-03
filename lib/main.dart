import 'package:flutter/material.dart';

import 'package:el_oplata/widgets/app/app.dart';
import 'package:el_oplata/widgets/settings/settings.dart';
import 'package:el_oplata/widgets/new_calc/new_calculation.dart';
import 'package:el_oplata/widgets/open_calc/open_calculation.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сalculation of payment for consumed electricity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyAppWidget(),
        // '/settings': (BuildContext context) => const SettingsWidget(),
        SettingsWidget.routeName: (context) => const SettingsWidget(),

        // '/new_calc': (BuildContext context) => const NewCalcWidget(),
        NewCalcWidget.routeName: (context) => const NewCalcWidget(),

        OpenCalculationWidget.routeName: (context) =>
            const OpenCalculationWidget(),
      },
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru', 'RU')],
    );
  }
}
