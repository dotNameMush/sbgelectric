import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Category {
  late final String id;
  final String name;
  final List<Item> items;
  Category({this.id = '', this.name = '', this.items = const []});
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Item {
  String id;
  String name;
  String description;
  String price;
  String img;
  Item({
    this.id = '',
    this.name = '',
    this.description = '',
    this.img = '',
    this.price = '',
  });
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class Showcase {
  String id;
  String name;
  String price;
  String img;
  Showcase({
    this.id = '',
    this.name = '',
    this.img = '',
    this.price = '',
  });
  factory Showcase.fromJson(Map<String, dynamic> json) =>
      _$ShowcaseFromJson(json);
  Map<String, dynamic> toJson() => _$ShowcaseToJson(this);
}
