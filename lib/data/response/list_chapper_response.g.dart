// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_chapper_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListChapterAdapter extends TypeAdapter<ListChapter> {
  @override
  final int typeId = 1;

  @override
  ListChapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListChapter(
      index: fields[0] as int?,
      commentCount: fields[1] as int?,
      images: (fields[2] as List?)?.cast<String>(),
      sId: fields[3] as String?,
      name: fields[4] as String?,
      url: fields[5] as String?,
      createdAt: fields[6] as String?,
      iV: fields[7] as int?,
      after: fields[8] as String?,
      before: fields[9] as String?,
    )..imagesLocal = (fields[10] as List?)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, ListChapter obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.commentCount)
      ..writeByte(2)
      ..write(obj.images)
      ..writeByte(3)
      ..write(obj.sId)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.iV)
      ..writeByte(8)
      ..write(obj.after)
      ..writeByte(9)
      ..write(obj.before)
      ..writeByte(10)
      ..write(obj.imagesLocal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListChapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
