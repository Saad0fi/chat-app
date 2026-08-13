// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'groups_model.dart';

class GroupsMapper extends ClassMapperBase<Groups> {
  GroupsMapper._();

  static GroupsMapper? _instance;
  static GroupsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GroupsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Groups';

  static String _$id(Groups v) => v.id;
  static const Field<Groups, String> _f$id = Field('id', _$id);
  static String _$name(Groups v) => v.name;
  static const Field<Groups, String> _f$name = Field('name', _$name);
  static DateTime? _$created_at(Groups v) => v.created_at;
  static const Field<Groups, DateTime> _f$created_at = Field(
    'created_at',
    _$created_at,
  );

  @override
  final MappableFields<Groups> fields = const {
    #id: _f$id,
    #name: _f$name,
    #created_at: _f$created_at,
  };

  static Groups _instantiate(DecodingData data) {
    return Groups(data.dec(_f$id), data.dec(_f$name), data.dec(_f$created_at));
  }

  @override
  final Function instantiate = _instantiate;

  static Groups fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Groups>(map);
  }

  static Groups fromJson(String json) {
    return ensureInitialized().decodeJson<Groups>(json);
  }
}

mixin GroupsMappable {
  String toJson() {
    return GroupsMapper.ensureInitialized().encodeJson<Groups>(this as Groups);
  }

  Map<String, dynamic> toMap() {
    return GroupsMapper.ensureInitialized().encodeMap<Groups>(this as Groups);
  }

  GroupsCopyWith<Groups, Groups, Groups> get copyWith =>
      _GroupsCopyWithImpl<Groups, Groups>(this as Groups, $identity, $identity);
  @override
  String toString() {
    return GroupsMapper.ensureInitialized().stringifyValue(this as Groups);
  }

  @override
  bool operator ==(Object other) {
    return GroupsMapper.ensureInitialized().equalsValue(this as Groups, other);
  }

  @override
  int get hashCode {
    return GroupsMapper.ensureInitialized().hashValue(this as Groups);
  }
}

extension GroupsValueCopy<$R, $Out> on ObjectCopyWith<$R, Groups, $Out> {
  GroupsCopyWith<$R, Groups, $Out> get $asGroups =>
      $base.as((v, t, t2) => _GroupsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GroupsCopyWith<$R, $In extends Groups, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name, DateTime? created_at});
  GroupsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _GroupsCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Groups, $Out>
    implements GroupsCopyWith<$R, Groups, $Out> {
  _GroupsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Groups> $mapper = GroupsMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, Object? created_at = $none}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (created_at != $none) #created_at: created_at,
    }),
  );
  @override
  Groups $make(CopyWithData data) => Groups(
    data.get(#id, or: $value.id),
    data.get(#name, or: $value.name),
    data.get(#created_at, or: $value.created_at),
  );

  @override
  GroupsCopyWith<$R2, Groups, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _GroupsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

