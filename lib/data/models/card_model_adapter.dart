import 'package:hive/hive.dart';
import 'card_model.dart';

class CardModelAdapter extends TypeAdapter<CardModel>{
  @override
  final typeId = 0;

  @override
  CardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i =0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    final model = CardModel(
      id: fields[0] as int, 
      name: fields[1] as String, 
      species: fields[2] as String? ?? 'Unknown', 
      image: fields[3] as String,
      isFavorite: fields[4] as bool? ?? false
    );
    return model;
  }

  @override
  void write(BinaryWriter writer, CardModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.name)
      ..writeByte(2)..write(obj.species)
      ..writeByte(3)..write(obj.image)
      ..writeByte(4)..write(obj.isFavorite);
  }
}