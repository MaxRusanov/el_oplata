import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

/////////// для обмена в инхеритах - для хранения в Hive настроек последних тарифов и показаний
class Settings extends ChangeNotifier {
  int postT1 = 0;
  int postT2 = 0;
  double tariffBefore150 = 0.0;
  double tariffOver150 = 0.0;
  String postDate = '2000-12-31';

  Settings({
    required this.postT1,
    required this.postT2,
    required this.tariffBefore150,
    required this.tariffOver150,
    required this.postDate,
  });
}

////////// Adapter extends TypeAdapter<Settings> для хранения в Hive c typeId=0
class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final typeId = 0; //!!! Обязательный уникальный идентификатор объектов

  @override
  void write(BinaryWriter writer, Settings obj) {
    //!!!По очереди и с учётом типов записываются поля
    writer.writeInt(obj.postT1);
    writer.writeInt(obj.postT2);
    writer.writeDouble(obj.tariffBefore150);
    writer.writeDouble(obj.tariffOver150);
    writer.writeString(obj.postDate);
  }

  @override
  Settings read(BinaryReader reader) {
    //!!!По очереди и с учётом типов считываю поля
    final postT1 = reader.readInt();
    final postT2 = reader.readInt();
    final tariffBefore150 = reader.readDouble();
    final tariffOver150 = reader.readDouble();
    final postDate = reader.readString();

    return Settings(
      postT1: postT1,
      postT2: postT2,
      tariffBefore150: tariffBefore150,
      tariffOver150: tariffOver150,
      postDate: postDate,
    );
  }
}
