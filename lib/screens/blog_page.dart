import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/blog_post.dart';
import '../models/comment.dart';
import '../services/firebase_service.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final TextEditingController _commentController = TextEditingController();
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Technology', 'Programming', 'Flutter', 'Web Development', 'Mobile Development'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final firebaseService = Provider.of<FirebaseService>(context);
    final isAdmin = firebaseService.currentUser != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBar(),

            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 40 : 80),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00B4D8).withOpacity(0.15),
                    const Color(0xFFCAF542).withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.article, size: 60, color: Color(0xFF00B4D8)),
                  const SizedBox(height: 20),
                  Text(
                    'Blog & Articles',
                    style: TextStyle(
                      fontSize: isMobile ? 36 : 56,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF03045E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Discover the latest tech insights, tutorials, and coding tips',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      color: const Color(0xFF023E8A),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // ✅ ADMIN BADGE - Show if admin is logged in
                  if (isAdmin) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCAF542),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.admin_panel_settings, size: 16, color: Color(0xFF03045E)),
                          SizedBox(width: 6),
                          Text(
                            'Admin Mode',
                            style: TextStyle(
                              color: Color(0xFF03045E),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Category Filter
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : 'All';
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF00B4D8),
                        labelStyle: TextStyle(
                          color: _selectedCategory == category ? Colors.white : const Color(0xFF03045E),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Blog Posts List
            Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 60),
              child: StreamBuilder<List<BlogPost>>(
                stream: firebaseService.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final posts = snapshot.data ?? [];
                  final filteredPosts = _selectedCategory == 'All'
                      ? posts
                      : posts.where((post) => post.tags.contains(_selectedCategory)).toList();

                  if (filteredPosts.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(Icons.article, size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 20),
                          Text(
                            'No blog posts yet',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Check back later for new articles',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: filteredPosts.map((post) {
                      return BlogPostCard(
                        post: post,
                        isAdmin: isAdmin,
                        onTap: () {
                          _showBlogPostDetail(context, post);
                        },
                        onEdit: () => _editPost(context, post),
                        onDelete: () => _deletePost(context, post),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }

  // ✅ EDIT POST FUNCTION
  void _editPost(BuildContext context, BlogPost post) {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final titleController = TextEditingController(text: post.title);
    final contentController = TextEditingController(text: post.content);
    final tagsController = TextEditingController(text: post.tags.join(', '));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Blog Post'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Post Title',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Post Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  hintText: 'Flutter, Dart, Programming',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();
              final tags = tagsController.text.trim();

              if (title.isEmpty || content.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill title and content')),
                );
                return;
              }

              final updatedPost = post.copyWith(
                title: title,
                content: content,
                tags: tags.isNotEmpty ? tags.split(',').map((tag) => tag.trim()).toList() : ['General'],
                updatedAt: DateTime.now(),
              );

              final success = await firebaseService.updatePost(updatedPost);
              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post updated successfully!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to update post')),
                );
              }
            },
            child: const Text('Update Post'),
          ),
        ],
      ),
    );
  }

  // ✅ DELETE POST FUNCTION
  void _deletePost(BuildContext context, BlogPost post) {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: Text('Are you sure you want to delete "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await firebaseService.deletePost(post.id);
              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post deleted successfully!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete post')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showBlogPostDetail(BuildContext context, BlogPost post) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 0 : 0, // ✅ WIDER ON DESKTOP
            vertical: isMobile ? 0:0,
          ),
          child: BlogPostDetailModal(
            post: post,
          ),
        );
      },
    );
  }
}

class BlogPostCard extends StatelessWidget {
  final BlogPost post;
  final VoidCallback onTap;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BlogPostCard({
    super.key,
    required this.post,
    required this.onTap,
    this.isAdmin = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with author and date
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF00B4D8),
                      child: Text(
                        post.author.isNotEmpty ? post.author[0].toUpperCase() : 'A',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF03045E),
                            ),
                          ),
                          Text(
                            '${_formatDate(post.createdAt)} • ${post.likes.length} likes',
                            style: const TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ✅ ADMIN ACTIONS - Edit & Delete Buttons
                    if (isAdmin) ...[
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, color: Color(0xFF00B4D8), size: 20),
                        tooltip: 'Edit Post',
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        tooltip: 'Delete Post',
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045E),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${post.content.substring(0, post.content.length > 150 ? 150 : post.content.length)}...',
                  style: const TextStyle(
                    color: Color(0xFF023E8A),
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        children: post.tags.take(3).map((tag) {
                          return Chip(
                            label: Text(
                              tag,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: const Color(0xFF00B4D8).withOpacity(0.1),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Read More',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class BlogPostDetailModal extends StatefulWidget {
  final BlogPost post;

  const BlogPostDetailModal({
    super.key,
    required this.post,
  });

  @override
  State<BlogPostDetailModal> createState() => _BlogPostDetailModalState();
}

class _BlogPostDetailModalState extends State<BlogPostDetailModal> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  void _checkIfLiked() {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final currentUser = firebaseService.currentUser;
    if (currentUser != null) {
      setState(() {
        _isLiked = widget.post.likes.contains(currentUser.uid);
      });
    }
  }

  void _toggleLike() async {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final currentUser = firebaseService.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to like posts')),
      );
      return;
    }

    final success = await firebaseService.likePost(
      widget.post.id,
      currentUser.uid,
    );

    if (success) {
      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  void _addComment() async {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final currentUser = firebaseService.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to comment')),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      return;
    }

    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      authorName: currentUser.displayName ?? 'Anonymous User',
      authorEmail: currentUser.email ?? '',
      content: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    final success = await firebaseService.addComment(comment);
    if (success) {
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 24),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Blog Post Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF03045E),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                    color: _isLiked ? const Color(0xFF00B4D8) : Colors.grey,
                    size: 24,
                  ),
                ),
                Text(
                  '${widget.post.likes.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045E),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 20 : 40), // ✅ MORE PADDING ON DESKTOP
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Info
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF00B4D8),
                        radius: 25,
                        child: Text(
                          widget.post.author.isNotEmpty ? widget.post.author[0].toUpperCase() : 'A',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.author,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF03045E),
                              ),
                            ),
                            Text(
                              _formatDate(widget.post.createdAt),
                              style: const TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Title
                  Text(
                    widget.post.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF03045E),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Content
                  Text(
                    widget.post.content,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF023E8A),
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tags
                  Wrap(
                    spacing: 10,
                    children: widget.post.tags.map((tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: const Color(0xFF00B4D8),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 40),

                  // Comments Section
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF03045E),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Add Comment
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      suffixIcon: IconButton(
                        onPressed: _addComment,
                        icon: const Icon(Icons.send, color: Color(0xFF00B4D8), size: 24),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF00B4D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF00B4D8), width: 2),
                      ),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 20),

                  // Comments List
                  StreamBuilder<List<Comment>>(
                    stream: Provider.of<FirebaseService>(context).getComments(widget.post.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final comments = snapshot.data ?? [];

                      return Column(
                        children: comments.map((comment) {
                          return CommentCard(comment: comment);
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF00B4D8),
                radius: 20,
                child: Text(
                  comment.authorName.isNotEmpty ? comment.authorName[0].toUpperCase() : 'U',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF03045E),
                      ),
                    ),
                    if (comment.authorEmail.isNotEmpty)
                      Text(
                        comment.authorEmail,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(comment.createdAt),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF023E8A),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')} • ${date.day}/${date.month}/${date.year}';
  }
}