// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'users_model.dart';

class UsersMapper extends ClassMapperBase<Users> {
  UsersMapper._();

  static UsersMapper? _instance;
  static UsersMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UsersMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Users';

  static String _$id(Users v) => v.id;
  static const Field<Users, String> _f$id = Field('id', _$id);
  static String _$username(Users v) => v.username;
  static const Field<Users, String> _f$username = Field('username', _$username);
  static String _$avatar_url(Users v) => v.avatar_url!;
  static const Field<Users, String> _f$avatar_url = Field(
    'avatar_url',
    _$avatar_url,
  );
  static DateTime _$created_at(Users v) => v.created_at;
  static const Field<Users, DateTime> _f$created_at = Field(
    'created_at',
    _$created_at,
  );

  @override
  final MappableFields<Users> fields = const {
    #id: _f$id,
    #username: _f$username,
    #avatar_url: _f$avatar_url,
    #created_at: _f$created_at,
  };

  static Users _instantiate(DecodingData data) {
    return Users(
      data.dec(_f$id),
      data.dec(_f$username),
      data.dec(_f$avatar_url),
      data.dec(_f$created_at),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Users fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Users>(map);
  }

  static Users fromJson(String json) {
    return ensureInitialized().decodeJson<Users>(json);
  }
}

mixin UsersMappable {
  String toJson() {
    return UsersMapper.ensureInitialized().encodeJson<Users>(this as Users);
  }

  Map<String, dynamic> toMap() {
    return UsersMapper.ensureInitialized().encodeMap<Users>(this as Users);
  }

  UsersCopyWith<Users, Users, Users> get copyWith =>
      _UsersCopyWithImpl<Users, Users>(this as Users, $identity, $identity);
  @override
  String toString() {
    return UsersMapper.ensureInitialized().stringifyValue(this as Users);
  }

  @override
  bool operator ==(Object other) {
    return UsersMapper.ensureInitialized().equalsValue(this as Users, other);
  }

  @override
  int get hashCode {
    return UsersMapper.ensureInitialized().hashValue(this as Users);
  }
}

extension UsersValueCopy<$R, $Out> on ObjectCopyWith<$R, Users, $Out> {
  UsersCopyWith<$R, Users, $Out> get $asUsers =>
      $base.as((v, t, t2) => _UsersCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UsersCopyWith<$R, $In extends Users, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? username,
    String? avatar_url,
    DateTime? created_at,
  });
  UsersCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UsersCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Users, $Out>
    implements UsersCopyWith<$R, Users, $Out> {
  _UsersCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Users> $mapper = UsersMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? username,
    String? avatar_url,
    DateTime? created_at,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (username != null) #username: username,
      if (avatar_url != null) #avatar_url: avatar_url,
      if (created_at != null) #created_at: created_at,
    }),
  );
  @override
  Users $make(CopyWithData data) => Users(
    data.get(#id, or: $value.id),
    data.get(#username, or: $value.username),
    data.get(#avatar_url, or: $value.avatar_url),
    data.get(#created_at, or: $value.created_at),
  );

  @override
  UsersCopyWith<$R2, Users, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UsersCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

