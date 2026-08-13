import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SupabaseClient _supabase = Supabase.instance.client;
  StreamSubscription<List<Map<String, dynamic>>>? _messagesSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? _groupsSubscription;

  ChatBloc() : super(ChatInitial()) {
    on<LoadChatsEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final userId = _supabase.auth.currentUser?.id;

        if (userId == null) {
          emit(ChatLoaded([]));
          return;
        }

        final privateChats = await _supabase
            .from('messages')
            .select('*, sender_id:sender_id(*), receiver_id:receiver_id(*)')
            .or('sender_id.eq.$userId,receiver_id.eq.$userId')
            .order('created_at');

        final byPeer = <String, Map<String, dynamic>>{};
        for (final m in privateChats) {
          final s = m['sender_id'], r = m['receiver_id'];
          if (s == null || r == null) continue;
          final iAmSender = s['id'] == userId;
          final peer = iAmSender ? r : s;
          if (peer == null) continue;
          final pid = peer['id'].toString();

          byPeer.putIfAbsent(
            pid,
            () => {
              'type': 'private',
              'peerId': pid,
              'peerUsername': peer['username'] ?? 'بدون اسم',
              'peerAvatarUrl': peer['avatar_url'],
              'lastContent': m['content'] ?? '',
              'lastCreatedAt': m['created_at'],
            },
          );
        }
        final conversations = byPeer.values.toList();

        final groupMemberships = await _supabase
            .from('group_members')
            .select('*, groups(*)')
            .eq('user_id', userId);

        final List<Map<String, dynamic>> groupEntries = [];
        for (final membership in groupMemberships) {
          final group = membership['groups'];
          if (group == null || group['id'] == null) continue;

          final recentMsgs = await _supabase
              .from('messages')
              .select('content, created_at, sender_id:sender_id(username)')
              .eq('group_id', group['id'])
              .order('created_at', ascending: false)
              .limit(1);
          final recent = recentMsgs.isNotEmpty ? recentMsgs.first : null;
          groupEntries.add({
            'type': 'group',
            'groupId': group['id'],
            'groupName': group['name'] ?? 'مجموعة بدون اسم',
            'groupAvatarUrl': null,
            'lastContent': recent?['content'] ?? 'لا يوجد رسائل',
            'lastCreatedAt': recent?['created_at'] ?? group['created_at'],
            'lastSender':
                (recent != null &&
                    recent['sender_id'] is Map &&
                    recent['sender_id']['username'] != null)
                ? recent['sender_id']['username']
                : '',
          });
        }

        emit(ChatLoaded([...conversations, ...groupEntries]));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    _messagesSubscription = _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .listen((_) {
          add(LoadChatsEvent());
        });
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      _groupsSubscription = _supabase
          .from('group_members')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .listen((_) {
            add(LoadChatsEvent());
          });
    }
  }

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    await _groupsSubscription?.cancel();
    return super.close();
  }

  Future<void> createGroup(String groupName, List<String> userIds) async {
    final createdGroups = await _supabase.from('groups').insert({
      'name': groupName,
    }).select();
    if (createdGroups == null || createdGroups.isEmpty) {
      throw Exception('Failed to create group');
    }
    final groupId = createdGroups.first['id'] as String;

    final memberInserts = userIds
        .map((uid) => {'group_id': groupId, 'user_id': uid})
        .toList();
    await _supabase.from('group_members').insert(memberInserts);
  }
}
