import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sao/feature/chat/bloc/chat_bloc.dart';
import 'package:sao/feature/chat/screens/home_screen/widgets/helper_functions.dart';
import 'package:sao/feature/chat/screens/conversation_screen.dart';
import 'package:sao/feature/chat/screens/group_chat_screen.dart';
import 'package:sao/feature/chat/screens/home_screen/widgets/hero_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sao/feature/auth/screens/login_in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int selectedTab = 0;
  final tabs = const [Tab(text: 'الكل'), Tab(text: 'خاص'), Tab(text: 'قروب')];

  List<Map<String, dynamic>> filterChats(List<dynamic> chats) {
    final validChats = chats
        .where((c) => c != null && c is Map<String, dynamic>)
        .map((c) => c as Map<String, dynamic>)
        .toList();
    if (selectedTab == 1)
      return validChats.where((c) => c['type'] != 'group').toList();
    if (selectedTab == 2)
      return validChats.where((c) => c['type'] == 'group').toList();
    return validChats;
  }

  void _showHeroDetails(BuildContext context, String imageUrl, String heroTag) {
    if (imageUrl.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ImageDetailScreen(imageUrl: imageUrl, heroTag: heroTag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) {
      Future.microtask(() {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => LoginInScreen()));
      });
      return const SizedBox();
    }
    return BlocProvider(
      create: (context) {
        final bloc = ChatBloc();
        bloc.add(LoadChatsEvent());
        return bloc;
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearchBar(),
            SizedBox(height: 6),
            DefaultTabController(
              length: tabs.length,
              initialIndex: selectedTab,
              child: Builder(
                builder: (context) {
                  final TabController tabController = DefaultTabController.of(
                    context,
                  );
                  tabController.addListener(() {
                    if (tabController.indexIsChanging == false &&
                        selectedTab != tabController.index) {
                      setState(() => selectedTab = tabController.index);
                    }
                  });
                  return TabBar(
                    tabs: tabs,
                    controller: tabController,
                    indicatorColor: Colors.green[700],
                    labelColor: Colors.green[700],
                    unselectedLabelColor: Colors.black,
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ChatError) {
                    return Center(child: Text('خطأ: ${state.message}'));
                  }
                  if (state is ChatLoaded) {
                    final List<Map<String, dynamic>> displayedChats =
                        filterChats(state.chats);
                    if (displayedChats.isEmpty) {
                      return const Center(child: Text('لا توجد محادثات'));
                    }
                    return ListView.builder(
                      itemCount: displayedChats.length,
                      itemBuilder: (context, index) {
                        final chat = displayedChats[index];
                        if (chat == null) return const SizedBox();
                        final bool isGroup =
                            (chat['type'] == 'group') ||
                            (chat['peerId'] == null && chat['groupId'] != null);
                        final String id =
                            (chat['id'] ??
                                    chat['peerId'] ??
                                    chat['groupId'] ??
                                    '')
                                .toString();
                        final String name = isGroup
                            ? (chat['name'] ??
                                      chat['groupName'] ??
                                      'مجموعة بدون اسم')
                                  .toString()
                            : (chat['name'] ??
                                      chat['peerUsername'] ??
                                      'بدون اسم')
                                  .toString();
                        final String avatarUrl =
                            (isGroup
                                ? (chat['avatarUrl'] ?? chat['groupAvatarUrl'])
                                : (chat['avatarUrl'] ?? chat['peerAvatarUrl'])
                                      as String?) ??
                            '';
                        final String lastContent = (chat['lastContent'] ?? '')
                            .toString();
                        final DateTime t =
                            DateTime.tryParse(
                              (chat['lastCreatedAt'] ?? '').toString(),
                            ) ??
                            DateTime.now();
                        final String time =
                            '${(t.hour % 12 == 0 ? 12 : t.hour % 12).toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} ${t.hour >= 12 ? 'PM' : 'AM'}';

                        return ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              if (avatarUrl.isNotEmpty) {
                                _showHeroDetails(context, avatarUrl, avatarUrl);
                              }
                            },
                            child: Hero(
                              tag: avatarUrl.isNotEmpty
                                  ? avatarUrl
                                  : 'default-$id',
                              child: CircleAvatar(
                                backgroundImage: avatarUrl.isNotEmpty
                                    ? NetworkImage(avatarUrl)
                                    : null,
                                child: avatarUrl.isEmpty
                                    ? Icon(
                                        isGroup ? Icons.groups : Icons.person,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            lastContent,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            if (id.isEmpty) return;
                            if (isGroup) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GroupChatScreen(
                                    groupId: id,
                                    groupName: name,
                                    groupAvatarUrl: avatarUrl,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ConversationScreen(
                                    peerId: id,
                                    peerUsername: name,
                                    peerAvatarUrl: avatarUrl,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                  return const Center(child: Text('لا توجد بيانات'));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            child: Icon(Icons.group_add),
            onPressed: () async {
              final supabase = Supabase.instance.client;
              String groupName = '';
              List<String> selectedUserIds = [];
              final currentUserId = supabase.auth.currentUser?.id;
              if (currentUserId == null) return;
              final allUsersRes = await supabase
                  .from('users')
                  .select('id, username, avatar_url');
              final allUsersList = List<Map<String, dynamic>>.from(
                allUsersRes,
              ).where((u) => u['id'] != null).toList();
              final shouldCreate = await showDialog<bool>(
                context: context,
                builder: (buildDialogContext) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text('إنشاء مجموعة'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'اسم المجموعة',
                                ),
                                onChanged: (v) {
                                  groupName = v;
                                },
                              ),
                              const SizedBox(height: 8),
                              const Text('اختر الأعضاء:'),
                              ...allUsersList.map((user) {
                                final isMe = user['id'] == currentUserId;
                                final name =
                                    user['username'] as String? ?? 'بدون اسم';
                                return CheckboxListTile(
                                  value:
                                      isMe ||
                                      selectedUserIds.contains(user['id']),
                                  onChanged: isMe
                                      ? null
                                      : (checked) => setState(() {
                                          if (checked == true) {
                                            selectedUserIds.add(
                                              user['id'] as String,
                                            );
                                          } else {
                                            selectedUserIds.remove(
                                              user['id'] as String,
                                            );
                                          }
                                        }),
                                  title: Text(isMe ? '$name (أنت)' : name),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('الغاء'),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: Text('انشاء'),
                            onPressed: () {
                              if (groupName.trim().isNotEmpty &&
                                  selectedUserIds.isNotEmpty) {
                                if (!selectedUserIds.contains(currentUserId)) {
                                  selectedUserIds.add(currentUserId);
                                }
                                Navigator.pop(context, true);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
              if (shouldCreate == true) {
                await context.read<ChatBloc>().createGroup(
                  groupName,
                  selectedUserIds,
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('تم إنشاء المجموعة!')));
              }
            },
          ),
        ),
      ),
    );
  }
}
