import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationScreen extends StatefulWidget {
  final String peerId;
  final String peerUsername;
  final String? peerAvatarUrl;

  const ConversationScreen({
    super.key,
    required this.peerId,
    required this.peerUsername,
    this.peerAvatarUrl,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _supabase = Supabase.instance.client;
  final _input = TextEditingController();

  String? _myId;

  // ===== Realtime Presence =====
  RealtimeChannel? _presence;
  Set<String> _onlineIds = const {};

  @override
  void initState() {
    super.initState();
    _myId = _supabase.auth.currentUser?.id;
    _initPresence();
  }

  Future<void> _initPresence() async {
    if (_myId == null) return;

    // Create a presence channel (you can reuse one app-wide if you like)
    _presence = _supabase.realtime.channel('presence:users');

    // Fires when presence has re-synced (after joins/leaves)
    _presence!.onPresenceSync((_) {
      final states = _presence!.presenceState(); // List<PresenceState>
      final ids = <String>{};

      for (final s in states) {
        // s.presences is List<Presence>
        for (final p in s.presences) {
          // we tracked 'user_id' in track({...})
          final uid = p.payload['user_id'] as String?;
          if (uid != null) ids.add(uid);
        }
      }

      if (mounted) setState(() => _onlineIds = ids);
    });

    // Optional (for logging/analytics)
    _presence!.onPresenceJoin((e) {
      /* debug: joined */
    });
    _presence!.onPresenceLeave((e) {
      /* debug: left */
    });

    // Subscribe and then track myself
    _presence!.subscribe((status, [err]) async {
      if (status == RealtimeSubscribeStatus.subscribed) {
        await _presence!.track({
          'user_id': _myId,
          'name': _supabase.auth.currentUser?.userMetadata?['name'] ?? 'User',
          'online_at': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _presence?.untrack();
    _presence?.unsubscribe();
    super.dispose();
  }

  bool get _isPeerOnline => _onlineIds.contains(widget.peerId);

  @override
  Widget build(BuildContext context) {
    final stream = _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at');

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage:
                      (widget.peerAvatarUrl != null &&
                          widget.peerAvatarUrl!.isNotEmpty)
                      ? NetworkImage(widget.peerAvatarUrl!)
                      : null,
                  child:
                      (widget.peerAvatarUrl == null ||
                          widget.peerAvatarUrl!.isEmpty)
                      ? const Icon(Icons.person)
                      : null,
                ),
                Positioned(
                  right: -1,
                  bottom: -1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _isPeerOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.peerUsername),
                Text(
                  _isPeerOnline ? 'In Chat' : '',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isPeerOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: stream,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final all = List<Map<String, dynamic>>.from(snap.data!);
                final messages =
                    all
                        .where(
                          (m) =>
                              m['group_id'] == null &&
                              ((_myId != null &&
                                      m['sender_id'] == _myId &&
                                      m['receiver_id'] == widget.peerId) ||
                                  (m['sender_id'] == widget.peerId &&
                                      m['receiver_id'] == _myId)),
                        )
                        .toList()
                      ..sort(
                        (a, b) => DateTime.parse(
                          a['created_at'],
                        ).compareTo(DateTime.parse(b['created_at'])),
                      );

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final m = messages[i];
                    final bool isMe = m['sender_id'] == _myId;
                    final bool isDeleted = (m['deleted_for_all'] == true);
                    final dt =
                        DateTime.tryParse('${m['created_at']}') ??
                        DateTime.now();
                    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
                    final time =
                        '${h.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.green[600]
                                : const Color(0xFFEFEFEF),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(isMe ? 12 : 0),
                              bottomRight: Radius.circular(isMe ? 0 : 12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onLongPress: (isMe && !isDeleted)
                                    ? () async {
                                        // Bottom sheet: Edit / Delete
                                        final action =
                                            await showModalBottomSheet<String>(
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            16,
                                                          ),
                                                        ),
                                                  ),
                                              builder: (_) => SafeArea(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.edit_outlined,
                                                      ),
                                                      title: const Text(
                                                        'تعديل الرسالة',
                                                      ),
                                                      onTap: () =>
                                                          Navigator.pop(
                                                            context,
                                                            'edit',
                                                          ),
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.red,
                                                      ),
                                                      title: const Text(
                                                        'حذف للجميع',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      onTap: () =>
                                                          Navigator.pop(
                                                            context,
                                                            'delete',
                                                          ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                  ],
                                                ),
                                              ),
                                            );

                                        if (action == 'delete') {
                                          try {
                                            await _supabase
                                                .from('messages')
                                                .update({
                                                  'deleted_for_all': true,
                                                })
                                                .eq('id', m['id']);
                                            if (mounted) setState(() {});
                                          } catch (e) {
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Failed to delete: $e',
                                                ),
                                              ),
                                            );
                                          }
                                        } else if (action == 'edit') {
                                          final controller =
                                              TextEditingController(
                                                text: (m['content'] ?? '')
                                                    .toString(),
                                              );
                                          final String?
                                          newText = await showDialog<String>(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: const Text(
                                                'تعديل الرسالة',
                                              ),
                                              content: TextField(
                                                controller: controller,
                                                autofocus: true,
                                                maxLines: null,
                                                textInputAction:
                                                    TextInputAction.done,
                                                onSubmitted: (v) =>
                                                    Navigator.of(
                                                      context,
                                                    ).pop(v.trim()),
                                                decoration:
                                                    const InputDecoration(
                                                      hintText:
                                                          'اكتب النص الجديد...',
                                                      border:
                                                          OutlineInputBorder(),
                                                      isDense: true,
                                                    ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(null),
                                                  child: const Text('إلغاء'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(controller.text.trim()),
                                                  child: const Text('حفظ'),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (newText != null &&
                                              newText.isNotEmpty &&
                                              newText != m['content']) {
                                            try {
                                              await _supabase
                                                  .from('messages')
                                                  .update({'content': newText})
                                                  .eq('id', m['id']);
                                              if (mounted) {
                                                setState(
                                                  () => m['content'] = newText,
                                                );
                                              }
                                            } catch (e) {
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Failed to edit: $e',
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      }
                                    : null,
                                child: Text(
                                  isDeleted
                                      ? 'This message was deleted'
                                      : (m['content'] ?? ''),
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black87,
                                    fontStyle: isDeleted
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                time,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isMe ? Colors.white70 : Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) async {
                        final text = _input.text.trim();
                        if (text.isEmpty || _myId == null) return;
                        _input.clear();
                        await _supabase.from('messages').insert({
                          'sender_id': _myId,
                          'receiver_id': widget.peerId,
                          'content': text,
                          'group_id': null,
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      final text = _input.text.trim();
                      if (text.isEmpty || _myId == null) return;
                      _input.clear();
                      await _supabase.from('messages').insert({
                        'sender_id': _myId,
                        'receiver_id': widget.peerId,
                        'content': text,
                        'group_id': null,
                      });
                    },
                    icon: const Icon(Icons.send),
                    color: Colors.green[600],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
