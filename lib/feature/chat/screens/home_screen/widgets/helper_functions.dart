import 'package:flutter/material.dart';
import 'package:sao/feature/auth/screens/login_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sao/feature/chat/screens/conversation_screen.dart';

PreferredSizeWidget buildAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    leading: IconButton(
      icon: const Icon(Icons.logout, color: Colors.black),
      onPressed: () {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => LoginInScreen()));
      },
    ),
    title: const Text(
      'المحادثات',
      style: TextStyle(
        color: Colors.black,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      textDirection: TextDirection.rtl,
    ),
  );
}

Widget buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Builder(
        builder: (context) {
          final supabase = Supabase.instance.client;
          final controller = TextEditingController();
          return TextField(
            controller: controller,
            textAlign: TextAlign.right,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'أبحث عن أنيس',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
            onSubmitted: (value) async {
              final q = value.trim();
              controller.clear();
              if (q.isEmpty) return;
              try {
                final data = await supabase
                    .from('users')
                    .select('id, username, avatar_url')
                    .ilike('username', '%$q%')
                    .limit(20);
                final results = List<Map<String, dynamic>>.from(data);
                if (results.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('لا يوجد مستخدمين مطابقين')),
                  );
                  return;
                }

                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context2, index) {
                        final u = results[index];
                        final String id = u['id'] as String;
                        final String name = u['username'] as String;
                        final String? avatar = u['avatar_url'] as String?;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                (avatar != null && avatar.isNotEmpty)
                                ? NetworkImage(avatar)
                                : null,
                            child: (avatar == null || avatar.isEmpty)
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.pop(context2);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConversationScreen(
                                  peerId: id,
                                  peerUsername: name,
                                  peerAvatarUrl: avatar,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('خطأ في البحث: $e')));
              }
            },
          );
        },
      ),
    ),
  );
}

Widget buildFilterTabs() {
  final List<String> filters = ['الكل', 'غير مقروء', 'المفضلة', 'المجموعات'];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      children: [
        ...filters.map((filter) => buildFilterButton(filter)).toList(),
        Padding(padding: const EdgeInsets.only(left: 8.0)),
      ],
    ),
  );
}

Widget buildFilterButton(String text) {
  final bool isSelected = text == 'الكل';
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Chip(
      label: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      backgroundColor: isSelected ? Colors.green[600] : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
  );
}
