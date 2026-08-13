// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'messages_model.dart';

class MessagesMapper extends ClassMapperBase<Messages> {
  MessagesMapper._();

  static MessagesMapper? _instance;
  static MessagesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessagesMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Messages';

  static String _$id(Messages v) => v.id;
  static const Field<Messages, String> _f$id = Field('id', _$id);
  static String _$sender_id(Messages v) => v.sender_id;
  static const Field<Messages, String> _f$sender_id = Field(
    'sender_id',
    _$sender_id,
  );
  static String? _$receiver_id(Messages v) => v.receiver_id;
  static const Field<Messages, String> _f$receiver_id = Field(
    'receiver_id',
    _$receiver_id,
  );
  static String? _$group_id(Messages v) => v.group_id;
  static const Field<Messages, String> _f$group_id = Field(
    'group_id',
    _$group_id,
  );
  static String _$content(Messages v) => v.content;
  static const Field<Messages, String> _f$content = Field('content', _$content);
  static bool _$deleted_for_all(Messages v) => v.deleted_for_all;
  static const Field<Messages, bool> _f$deleted_for_all = Field(
    'deleted_for_all',
    _$deleted_for_all,
  );
  static DateTime? _$created_at(Messages v) => v.created_at;
  static const Field<Messages, DateTime> _f$created_at = Field(
    'created_at',
    _$created_at,
  );

  @override
  final MappableFields<Messages> fields = const {
    #id: _f$id,
    #sender_id: _f$sender_id,
    #receiver_id: _f$receiver_id,
    #group_id: _f$group_id,
    #content: _f$content,
    #deleted_for_all: _f$deleted_for_all,
    #created_at: _f$created_at,
  };

  static Messages _instantiate(DecodingData data) {
    return Messages(
      data.dec(_f$id),
      data.dec(_f$sender_id),
      data.dec(_f$receiver_id),
      data.dec(_f$group_id),
      data.dec(_f$content),
      data.dec(_f$deleted_for_all),
      data.dec(_f$created_at),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Messages fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Messages>(map);
  }

  static Messages fromJson(String json) {
    return ensureInitialized().decodeJson<Messages>(json);
  }
}

mixin MessagesMappable {
  String toJson() {
    return MessagesMapper.ensureInitialized().encodeJson<Messages>(
      this as Messages,
    );
  }

  Map<String, dynamic> toMap() {
    return MessagesMapper.ensureInitialized().encodeMap<Messages>(
      this as Messages,
    );
  }

  MessagesCopyWith<Messages, Messages, Messages> get copyWith =>
      _MessagesCopyWithImpl<Messages, Messages>(
        this as Messages,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessagesMapper.ensureInitialized().stringifyValue(this as Messages);
  }

  @override
  bool operator ==(Object other) {
    return MessagesMapper.ensureInitialized().equalsValue(
      this as Messages,
      other,
    );
  }

  @override
  int get hashCode {
    return MessagesMapper.ensureInitialized().hashValue(this as Messages);
  }
}

extension MessagesValueCopy<$R, $Out> on ObjectCopyWith<$R, Messages, $Out> {
  MessagesCopyWith<$R, Messages, $Out> get $asMessages =>
      $base.as((v, t, t2) => _MessagesCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessagesCopyWith<$R, $In extends Messages, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? sender_id,
    String? receiver_id,
    String? group_id,
    String? content,
    bool? deleted_for_all,
    DateTime? created_at,
  });
  MessagesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessagesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Messages, $Out>
    implements MessagesCopyWith<$R, Messages, $Out> {
  _MessagesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Messages> $mapper =
      MessagesMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? sender_id,
    Object? receiver_id = $none,
    Object? group_id = $none,
    String? content,
    bool? deleted_for_all,
    Object? created_at = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (sender_id != null) #sender_id: sender_id,
      if (receiver_id != $none) #receiver_id: receiver_id,
      if (group_id != $none) #group_id: group_id,
      if (content != null) #content: content,
      if (deleted_for_all != null) #deleted_for_all: deleted_for_all,
      if (created_at != $none) #created_at: created_at,
    }),
  );
  @override
  Messages $make(CopyWithData data) => Messages(
    data.get(#id, or: $value.id),
    data.get(#sender_id, or: $value.sender_id),
    data.get(#receiver_id, or: $value.receiver_id),
    data.get(#group_id, or: $value.group_id),
    data.get(#content, or: $value.content),
    data.get(#deleted_for_all, or: $value.deleted_for_all),
    data.get(#created_at, or: $value.created_at),
  );

  @override
  MessagesCopyWith<$R2, Messages, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessagesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

