import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sublimetask/screens/bookmark.dart';
import 'package:sublimetask/screens/userdetails.dart';
import '../providers.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final async = ref.watch(userListProvider);
    final size = MediaQuery.of(ctx).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const BookmarksScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: size.height * 0.9,
          width: size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: async.when(
            data: (list) {
              if (list.isEmpty) {
                return const Center(child: Text('No users found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final u = list[i];
                  return Card(                   
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Hero(
                        tag: 'userHero-${u.id}',
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.person, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  u.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),                      
                      ),                      
                      subtitle: Text(u.email,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Navigator.push(
                        ctx,
                        MaterialPageRoute(builder: (_) => UserDetailScreen(user: u)),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }
}
