import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String? groupAvatarUrl;

  const GroupChatScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
    this.groupAvatarUrl,
  }) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _supabase = Supabase.instance.client;
  final _input = TextEditingController();
  String? _myId;
  Map<String, String> _usernames = {};
  Future<void>? _userFetchFuture;

  @override
  void initState() {
    super.initState();
    _myId = _supabase.auth.currentUser?.id;
    _userFetchFuture = _fetchUsernames();
  }

  Future<void> _fetchUsernames() async {
    final usersRes = await _supabase.from('users').select('id, username');
    final users = List<Map<String, dynamic>>.from(usersRes);
    final map = <String, String>{};
    for (final u in users) {
      if (u['id'] != null && u['username'] != null) {
        map[u['id'] as String] = u['username'] as String;
      }
    }
    setState(() => _usernames = map);
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stream = _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('group_id', widget.groupId)
        .order('created_at');

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  (widget.groupAvatarUrl != null &&
                      widget.groupAvatarUrl!.isNotEmpty)
                  ? NetworkImage(widget.groupAvatarUrl!)
                  : null,
              child:
                  (widget.groupAvatarUrl == null ||
                      widget.groupAvatarUrl!.isEmpty)
                  ? const Icon(Icons.groups)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(widget.groupName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _userFetchFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return StreamBuilder<List<Map<String, dynamic>>>(
                  stream: stream,
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final messages =
                        List<Map<String, dynamic>>.from(snap.data!).toList()
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
                        final senderObj = m['sender_id'];
                        String senderId = '';
                        String username = '';
                        if (senderObj != null &&
                            senderObj is Map &&
                            senderObj['id'] != null) {
                          senderId = senderObj['id'] as String;
                          username = '';
                          if (senderObj['username'] != null &&
                              senderObj['username'] is String) {
                            username = senderObj['username'];
                          }
                        } else if (senderObj != null && senderObj is String) {
                          senderId = senderObj;
                          username = _usernames[senderObj] ?? senderObj;
                        } else {
                          senderId = '';
                          username = '';
                        }
                        final bool isMe = senderId == _myId;
                        final dt =
                            DateTime.tryParse(
                              m['created_at']?.toString() ?? '',
                            ) ??
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
                                  if (!isMe)
                                    Text(
                                      username,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  Text(
                                    m['content'] ?? '',
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    time,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isMe
                                          ? Colors.white70
                                          : Colors.black45,
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
                          'group_id': widget.groupId,
                          'content': text,
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
                        'group_id': widget.groupId,
                        'content': text,
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
