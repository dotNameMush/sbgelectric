// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'items': instance.items,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      img: json['img'] as String? ?? '',
      price: json['price'] as String? ?? '',
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'img': instance.img,
    };

Showcase _$ShowcaseFromJson(Map<String, dynamic> json) => Showcase(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      img: json['img'] as String? ?? '',
      price: json['price'] as String? ?? '',
    );

Map<String, dynamic> _$ShowcaseToJson(Showcase instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'img': instance.img,
    };
