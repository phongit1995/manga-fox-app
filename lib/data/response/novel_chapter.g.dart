// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_chapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NovelChapterAdapter extends TypeAdapter<NovelChapter> {
  @override
  final int typeId = 4;

  @override
  NovelChapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NovelChapter(
      index: fields[0] as int?,
      commentCount: fields[1] as int?,
      sId: fields[2] as String?,
      manga: fields[3] as String?,
      title: fields[4] as String?,
      createdAt: fields[5] as String?,
      iV: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, NovelChapter obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.commentCount)
      ..writeByte(2)
      ..write(obj.sId)
      ..writeByte(3)
      ..write(obj.manga)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.iV);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelChapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
