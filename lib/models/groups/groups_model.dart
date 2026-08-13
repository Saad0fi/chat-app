import 'package:dart_mappable/dart_mappable.dart';

part 'groups_model.mapper.dart';

@MappableClass()
class Groups with GroupsMappable {
  final String id;
  final String name;
  final DateTime? created_at;

  Groups(this.id, this.name, this.created_at);
}
