import 'package:bookvers/data/models/book_model.dart';
import 'package:hive/hive.dart';

class BookModelAdapter extends TypeAdapter<BookModel> {
  @override
  final int typeId = 0;

  @override
  BookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookModel(
      id: fields[0] as int,
      title: fields[1] as String,
      author: fields[2] as String,
      description: fields[3] as String,
      status: fields[4] as String,
      genreId: fields[5] as int,
      url: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.genreId)
      ..writeByte(6)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
