import 'package:dart_mappable/dart_mappable.dart';

part 'users_model.mapper.dart';

@MappableClass()
class Users with UsersMappable {
  final String id;
  final String username;
  String? avatar_url;
  final DateTime created_at;

  Users(this.id, this.username, this.avatar_url, this.created_at);
}
