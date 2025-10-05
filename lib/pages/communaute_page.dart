import 'package:flutter/material.dart';
import '../services/community_service.dart';
import 'histoire_questions.dart';
import 'gastronomie_questions.dart';
import 'geographie_questions.dart';
import 'social_questions.dart';
import 'traditions_questions.dart';

class CommunautePage extends StatefulWidget {
  const CommunautePage({super.key});

  @override
  State<CommunautePage> createState() => _CommunautePageState();
}

class _CommunautePageState extends State<CommunautePage> {
  List<CommunityPost> _posts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final posts = await CommunityService.loadPosts();
    setState(() => _posts = posts);
  }

  void _openPost(CommunityPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text('${post.theme} — ${post.score}/${post.total}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    const Text('Questions ratées', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ...post.missed.map((m) => ListTile(
                          title: Text(m['question'] ?? ''),
                          subtitle: Text('Vous: ${m['given']} • Correct: ${m['correct']}'),
                        )),
                    const SizedBox(height: 12),
                    const Text('Commentaires', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ...post.comments.map((c) => ListTile(title: Text(c['author'] ?? 'Anonyme'), subtitle: Text(c['text'] ?? ''))),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _replay(post.theme);
                      },
                      child: const Text('Rejouer le quiz'),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _CommentBox(postId: post.id, onCommentAdded: _load),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _replay(String theme) {
    Widget? page;
    switch (theme.toLowerCase()) {
      case 'histoire':
        page = const HistoireQuestionsPage();
        break;
      case 'gastronomie':
        page = const GastronomieQuestionsPage();
        break;
      case 'géographie':
      case 'geographie':
        page = const GeographieQuestionsPage();
        break;
      case 'social':
        page = const SocialQuestionsPage();
        break;
      case 'traditions':
        page = const TraditionsQuestionsPage();
        break;
    }
    if (page != null) Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Communauté')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, i) {
            final p = _posts[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                title: Text('${p.theme} — ${p.score}/${p.total}'),
                subtitle: Text('${p.missed.length} question(s) ratée(s)'),
                trailing: IconButton(icon: const Icon(Icons.comment), onPressed: () => _openPost(p)),
                onTap: () => _openPost(p),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CommentBox extends StatefulWidget {
  final String postId;
  final VoidCallback onCommentAdded;
  const _CommentBox({required this.postId, required this.onCommentAdded});

  @override
  State<_CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<_CommentBox> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Ajouter un commentaire'))),
        IconButton(
            onPressed: () async {
              if (_controller.text.trim().isEmpty) return;
              await CommunityService.addComment(widget.postId, 'Anonyme', _controller.text.trim());
              _controller.clear();
              widget.onCommentAdded();
            },
            icon: const Icon(Icons.send))
      ],
    );
  }
}
