import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/postmodel.dart';
import '../models/usermodel.dart';
import 'services/apiservices.dart';

/// Provider fetching list of users asynchronously
final userListProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  return ApiService.fetchUsers();
});

/// Provider fetching posts by userId asynchronously
final postsByUserProvider = FutureProvider.family<List<Post>, int>((ref, userId) {
  return ApiService.fetchPostsByUser(userId);
});

/// StateNotifier to manage bookmarked posts with local persistence
class BookmarkNotifier extends StateNotifier<List<Post>> {
  static const _key = 'bookmarks';

  BookmarkNotifier() : super([]) {
    _loadBookmarks();
  }

  /// Load bookmarks from SharedPreferences
  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_key) ?? [];
    state = savedList.map((e) => Post.fromJson(jsonDecode(e))).toList();
  }

  /// Toggle bookmark status for a post and persist
  Future<void> toggle(Post post) async {
    final isBookmarked = state.any((p) => p.id == post.id);
    if (isBookmarked) {
      state = state.where((p) => p.id != post.id).toList();
    } else {
      state = [...state, post];
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_key, state.map((p) => jsonEncode(p.toJson())).toList());
  }

  /// Check if a post is bookmarked
  bool isBookmarked(Post post) {
    return state.any((p) => p.id == post.id);
  }
}

/// Riverpod provider for bookmark state
final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, List<Post>>((ref) {
  return BookmarkNotifier();
});

/// StateNotifier to manage app theme mode with persistence
class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _key = 'theme_mode';

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  /// Load saved theme mode from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == 'light') {
      state = ThemeMode.light;
    } else if (saved == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  /// Toggle between light and dark theme modes and persist
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setString(_key, 'dark');
    } else {
      state = ThemeMode.light;
      await prefs.setString(_key, 'light');
    }
  }
}

/// Riverpod provider for theme mode state
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
