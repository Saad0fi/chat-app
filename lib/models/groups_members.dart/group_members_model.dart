import 'package:dart_mappable/dart_mappable.dart';

part 'group_members_model.mapper.dart';

@MappableClass()
class GroupMembers with GroupMembersMappable {
  final String id;
  final String group_id;
  final String user_id;

  final DateTime? joined_at;

  GroupMembers(this.id, this.group_id, this.user_id, this.joined_at);
}
