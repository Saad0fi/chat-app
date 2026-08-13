// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'group_members_model.dart';

class GroupMembersMapper extends ClassMapperBase<GroupMembers> {
  GroupMembersMapper._();

  static GroupMembersMapper? _instance;
  static GroupMembersMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GroupMembersMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'GroupMembers';

  static String _$id(GroupMembers v) => v.id;
  static const Field<GroupMembers, String> _f$id = Field('id', _$id);
  static String _$group_id(GroupMembers v) => v.group_id;
  static const Field<GroupMembers, String> _f$group_id = Field(
    'group_id',
    _$group_id,
  );
  static String _$user_id(GroupMembers v) => v.user_id;
  static const Field<GroupMembers, String> _f$user_id = Field(
    'user_id',
    _$user_id,
  );
  static DateTime? _$joined_at(GroupMembers v) => v.joined_at;
  static const Field<GroupMembers, DateTime> _f$joined_at = Field(
    'joined_at',
    _$joined_at,
  );

  @override
  final MappableFields<GroupMembers> fields = const {
    #id: _f$id,
    #group_id: _f$group_id,
    #user_id: _f$user_id,
    #joined_at: _f$joined_at,
  };

  static GroupMembers _instantiate(DecodingData data) {
    return GroupMembers(
      data.dec(_f$id),
      data.dec(_f$group_id),
      data.dec(_f$user_id),
      data.dec(_f$joined_at),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GroupMembers fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GroupMembers>(map);
  }

  static GroupMembers fromJson(String json) {
    return ensureInitialized().decodeJson<GroupMembers>(json);
  }
}

mixin GroupMembersMappable {
  String toJson() {
    return GroupMembersMapper.ensureInitialized().encodeJson<GroupMembers>(
      this as GroupMembers,
    );
  }

  Map<String, dynamic> toMap() {
    return GroupMembersMapper.ensureInitialized().encodeMap<GroupMembers>(
      this as GroupMembers,
    );
  }

  GroupMembersCopyWith<GroupMembers, GroupMembers, GroupMembers> get copyWith =>
      _GroupMembersCopyWithImpl<GroupMembers, GroupMembers>(
        this as GroupMembers,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return GroupMembersMapper.ensureInitialized().stringifyValue(
      this as GroupMembers,
    );
  }

  @override
  bool operator ==(Object other) {
    return GroupMembersMapper.ensureInitialized().equalsValue(
      this as GroupMembers,
      other,
    );
  }

  @override
  int get hashCode {
    return GroupMembersMapper.ensureInitialized().hashValue(
      this as GroupMembers,
    );
  }
}

extension GroupMembersValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GroupMembers, $Out> {
  GroupMembersCopyWith<$R, GroupMembers, $Out> get $asGroupMembers =>
      $base.as((v, t, t2) => _GroupMembersCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GroupMembersCopyWith<$R, $In extends GroupMembers, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? group_id, String? user_id, DateTime? joined_at});
  GroupMembersCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _GroupMembersCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GroupMembers, $Out>
    implements GroupMembersCopyWith<$R, GroupMembers, $Out> {
  _GroupMembersCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GroupMembers> $mapper =
      GroupMembersMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? group_id,
    String? user_id,
    Object? joined_at = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (group_id != null) #group_id: group_id,
      if (user_id != null) #user_id: user_id,
      if (joined_at != $none) #joined_at: joined_at,
    }),
  );
  @override
  GroupMembers $make(CopyWithData data) => GroupMembers(
    data.get(#id, or: $value.id),
    data.get(#group_id, or: $value.group_id),
    data.get(#user_id, or: $value.user_id),
    data.get(#joined_at, or: $value.joined_at),
  );

  @override
  GroupMembersCopyWith<$R2, GroupMembers, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _GroupMembersCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

