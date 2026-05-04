import 'package:bookvers/data/models/genre_model.dart';
import 'package:hive/hive.dart';

class GenreModelAdapter extends TypeAdapter<GenreModel> {
  @override
  final int typeId = 1;

  @override
  GenreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GenreModel(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GenreModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
