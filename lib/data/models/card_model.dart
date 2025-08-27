import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'card_model.g.dart';

@JsonSerializable()
class CardModel extends HiveObject{
  final int id;
  final String name;
  final String image;
  final String species;
  bool isFavorite;

  CardModel({
    required this.id,
    required this.name,
    required this.species,
    required this.image,
    this.isFavorite = false,
  });

  //factory CardModel.fromJson(Map<String, dynamic> json) => _$CardModelFromJson(json);
  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : (json['id'] ?? 0), 
    name: json['name']?.toString() ?? '', 
    species: json['species']?.toString() ?? '', 
    image: json['image']?.toString() ?? '',
  );

  //Map<String, dynamic> toJson() => _$CardModelToJson(this);
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'species': species,
    'isFavorite': isFavorite
  };
}