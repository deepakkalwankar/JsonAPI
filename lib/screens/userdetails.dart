import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sublimetask/models/usermodel.dart';
import 'package:sublimetask/providers.dart';

class UserDetailScreen extends ConsumerWidget {
  final User user;
  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final async = ref.watch(postsByUserProvider(user.id));
    final bookmarks = ref.watch(bookmarkProvider);

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'userHero-${user.id}',
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, color: Colors.blue),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📧 Email: ${user.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              '📞 Phone: ${user.phone}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              '🌐 Website: ${user.website}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              '🏠 Address: ${user.street}, ${user.suite}, ${user.city} - ${user.zipcode}',
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 32),
            const Text(
              '📝 Posts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            async.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const Text('No posts available.');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (_, i) {
                    final post = posts[i];
                    final isBook = bookmarks.any((p) => p.id == post.id);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    post.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isBook
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: isBook ? Colors.blue : Colors.grey,
                                  ),
                                  onPressed:
                                      () => ref
                                          .read(bookmarkProvider.notifier)
                                          .toggle(post),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              post.body,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading:
                  () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              error:
                  (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Error fetching posts: $e',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
