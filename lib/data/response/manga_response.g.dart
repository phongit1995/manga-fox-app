// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MangaAdapter extends TypeAdapter<Manga> {
  @override
  final int typeId = 0;

  @override
  Manga read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Manga(
      category: (fields[0] as List?)?.cast<String>(),
      views: fields[1] as int?,
      mangaStatus: fields[2] as int?,
      chapterUpdateCount: fields[3] as int?,
      enable: fields[4] as bool?,
      crawled: fields[5] as bool?,
      commentCount: fields[6] as int?,
      sId: fields[7] as String?,
      name: fields[8] as String?,
      url: fields[9] as String?,
      chapterUpdate: fields[10] as String?,
      createdAt: fields[11] as String?,
      updatedAt: fields[12] as String?,
      iV: fields[13] as int?,
      author: fields[14] as String?,
      description: fields[15] as String?,
      image: fields[16] as String?,
    )..imageLocal = fields[17] as String?;
  }

  @override
  void write(BinaryWriter writer, Manga obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.views)
      ..writeByte(2)
      ..write(obj.mangaStatus)
      ..writeByte(3)
      ..write(obj.chapterUpdateCount)
      ..writeByte(4)
      ..write(obj.enable)
      ..writeByte(5)
      ..write(obj.crawled)
      ..writeByte(6)
      ..write(obj.commentCount)
      ..writeByte(7)
      ..write(obj.sId)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.url)
      ..writeByte(10)
      ..write(obj.chapterUpdate)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.iV)
      ..writeByte(14)
      ..write(obj.author)
      ..writeByte(15)
      ..write(obj.description)
      ..writeByte(16)
      ..write(obj.image)
      ..writeByte(17)
      ..write(obj.imageLocal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MangaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
