import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityPost {
  final String id; // timestamp ou uuid
  final String theme;
  final int score;
  final int total;
  final List<Map<String, String>> missed; // [{'question':..., 'given':..., 'correct':...}]
  final List<Map<String, String>> comments; // [{'author':'', 'text':''}]

  CommunityPost({required this.id, required this.theme, required this.score, required this.total, required this.missed, List<Map<String, String>>? comments}) : comments = comments ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'theme': theme,
        'score': score,
        'total': total,
        'missed': missed,
        'comments': comments,
      };

  static CommunityPost fromJson(Map<String, dynamic> j) {
    return CommunityPost(
      id: j['id'] as String,
      theme: j['theme'] as String,
      score: j['score'] as int,
      total: j['total'] as int,
      missed: List<Map<String, String>>.from((j['missed'] as List).map((e) => Map<String, String>.from(e))),
      comments: List<Map<String, String>>.from((j['comments'] as List).map((e) => Map<String, String>.from(e))),
    );
  }
}

class CommunityService {
  static const _key = 'community_posts_v1';

  static Future<List<CommunityPost>> loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => CommunityPost.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<void> savePost(CommunityPost post) async {
    final prefs = await SharedPreferences.getInstance();
    final posts = await loadPosts();
    posts.insert(0, post); // newest first
    final raw = jsonEncode(posts.map((p) => p.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  static Future<void> addComment(String postId, String author, String text) async {
    final prefs = await SharedPreferences.getInstance();
    final posts = await loadPosts();
    for (var p in posts) {
      if (p.id == postId) {
        p.comments.add({'author': author, 'text': text});
        break;
      }
    }
    final raw = jsonEncode(posts.map((p) => p.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
