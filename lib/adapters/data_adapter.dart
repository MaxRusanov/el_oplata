import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

/////// Класс для обмена в инхеритах - для хранения в Hive в виде List<DataCalc>
/////// для передачи в open_calculation.dart в виде агрументов при переходе на страницу
class DataCalc with ChangeNotifier {
  String postMonthYear = '';
  int postT1 = 0;
  int postT2 = 0;
  int newT1 = 0;
  int newT2 = 0;
  double tariffBefore150 = 0.0;
  double tariffOver150 = 0.0;
  String postDate = '2000-12-31'; // 'yyyy-mm-dd'
  int totalT1 = 0;
  int totalT2 = 0;
  int costT1Result = 0;
  int costT2Result = 0;
  dynamic keyFromHive;

  DataCalc({
    required this.postMonthYear,
    required this.postT1,
    required this.postT2,
    required this.newT1,
    required this.newT2,
    required this.tariffBefore150,
    required this.tariffOver150,
    required this.postDate,
    required this.totalT1,
    required this.totalT2,
    required this.costT1Result,
    required this.costT2Result,
  });

  // set keyFromHive(value) => _keyFromHive = value;
  // dynamic get getKeyFromHive => _keyFromHive;
}

////// Adapter extends TypeAdapter<DataCalc> для хранения в Hive c typeId=1
class DataCalcAdapter extends TypeAdapter<DataCalc> {
  @override
  final typeId = 1; //!!! Обязательный уникальный идентификатор объектов

  @override
  void write(BinaryWriter writer, DataCalc obj) {
    //!!!По очереди и с учётом типов записываю поля
    writer.writeString(obj.postMonthYear);
    writer.writeInt(obj.postT1);
    writer.writeInt(obj.postT2);
    writer.writeInt(obj.newT1);
    writer.writeInt(obj.newT2);
    writer.writeDouble(obj.tariffBefore150);
    writer.writeDouble(obj.tariffOver150);
    writer.writeString(obj.postDate);
    writer.writeInt(obj.totalT1);
    writer.writeInt(obj.totalT2);
    writer.writeInt(obj.costT1Result);
    writer.writeInt(obj.costT2Result);
  }

  @override
  DataCalc read(BinaryReader reader) {
    //!!!По очереди и с учётом типов считываю поля
    final postMonthYear = reader.readString();
    final postT1 = reader.readInt();
    final postT2 = reader.readInt();
    final newT1 = reader.readInt();
    final newT2 = reader.readInt();
    final tariffBefore150 = reader.readDouble();
    final tariffOver150 = reader.readDouble();
    final postDate = reader.readString();
    final totalT1 = reader.readInt();
    final totalT2 = reader.readInt();
    final costT1Result = reader.readInt();
    final costT2Result = reader.readInt();

    return DataCalc(
      postMonthYear: postMonthYear,
      postT1: postT1,
      postT2: postT2,
      newT1: newT1,
      newT2: newT2,
      tariffBefore150: tariffBefore150,
      tariffOver150: tariffOver150,
      postDate: postDate,
      totalT1: totalT1,
      totalT2: totalT2,
      costT1Result: costT1Result,
      costT2Result: costT2Result,
    );
  }
}
