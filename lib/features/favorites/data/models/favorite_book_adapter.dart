part of 'favorite_book_model.dart';

class FavoriteBookAdapter extends TypeAdapter<FavoriteBookModel> {
  @override
  final int typeId = 0;

  @override
  FavoriteBookModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteBookModel(
      id: fields[0] as String,
      title: fields[1] as String,
      authors: (fields[2] as List).cast<String>(),
      description: fields[3] as String?,
      thumbnailUrl: fields[4] as String?,
      publishedDate: fields[5] as String?,
      publisher: fields[6] as String?,
      pageCount: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteBookModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.authors)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.thumbnailUrl)
      ..writeByte(5)
      ..write(obj.publishedDate)
      ..writeByte(6)
      ..write(obj.publisher)
      ..writeByte(7)
      ..write(obj.pageCount);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
