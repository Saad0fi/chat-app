import 'package:dart_mappable/dart_mappable.dart';

part 'messages_model.mapper.dart';

@MappableClass()
class Messages with MessagesMappable {
  final String id;
  final String sender_id;
  final String? receiver_id;
  final String? group_id;
  final String content;
  final bool deleted_for_all;

  final DateTime? created_at;

  Messages(
    this.id,
    this.sender_id,
    this.receiver_id,
    this.group_id,
    this.content,
    this.deleted_for_all,
    this.created_at,
  );
}
