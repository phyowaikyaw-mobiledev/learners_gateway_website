import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/blog_post.dart';
import '../models/comment.dart';
import '../config/firebase_config.dart';
import 'admin_auth_service.dart';

class FirebaseService with ChangeNotifier {
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;
  late FirebaseStorage _storage;

  User? _currentUser;
  BuildContext? _context; // Store context for showing snackbars

  User? get currentUser => _currentUser;

  // Constructor without context
  FirebaseService() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _storage = FirebaseStorage.instance;

    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // Method to set context when needed
  void setContext(BuildContext context) {
    _context = context;
  }

  // Sign in (Admin only)
  // In your FirebaseService class, update the signIn method:
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      // Use secure admin login for admin users
      if (FirebaseConfig.isAdmin(email)) {
        return await AdminAuthService.secureAdminLogin(email, password);
      } else {
        // Regular user login (if you have regular users)
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _currentUser = userCredential.user;
        notifyListeners();
        return userCredential;
      }
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Validate admin access
  Future<bool> _validateAdmin() async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return false;

    // Check if user is in admin list
    if (!FirebaseConfig.isAdmin(user.email!)) {
      print('Security: Unauthorized admin access attempt by ${user.email}');

      // Show snackbar if context is available
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(content: Text('Admin access required')),
        );
      }
      return false;
    }

    return true;
  }

  // Create blog post
  Future<bool> createPost(BlogPost post) async {
    try {
      // Admin validation
      if (!await _validateAdmin()) {
        return false;
      }

      await _firestore.collection('posts').doc(post.id).set(post.toMap());
      return true;
    } catch (e) {
      print('Create post error: $e');
      return false;
    }
  }

  // Update blog post
  Future<bool> updatePost(BlogPost post) async {
    try {
      // Admin validation
      if (!await _validateAdmin()) {
        return false;
      }

      await _firestore.collection('posts').doc(post.id).update(post.toMap());
      return true;
    } catch (e) {
      print('Update post error: $e');
      return false;
    }
  }

  // Delete blog post
  Future<bool> deletePost(String postId) async {
    try {
      // Admin validation
      if (!await _validateAdmin()) {
        return false;
      }

      await _firestore.collection('posts').doc(postId).delete();
      return true;
    } catch (e) {
      print('Delete post error: $e');
      return false;
    }
  }

  // Get all posts (stream)
  Stream<List<BlogPost>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BlogPost.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get single post
  Future<BlogPost?> getPost(String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();
      if (doc.exists) {
        return BlogPost.fromMap(doc.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Get post error: $e');
      return null;
    }
  }

  // Like post
  Future<bool> likePost(String postId, String userId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);
        if (!snapshot.exists) return;

        final likes = List<String>.from(snapshot.data()!['likes'] ?? []);
        if (likes.contains(userId)) {
          likes.remove(userId);
        } else {
          likes.add(userId);
        }

        transaction.update(postRef, {'likes': likes});
      });
      return true;
    } catch (e) {
      print('Like post error: $e');
      return false;
    }
  }

  // Add comment
  Future<bool> addComment(Comment comment) async {
    try {
      await _firestore
          .collection('posts')
          .doc(comment.postId)
          .collection('comments')
          .doc(comment.id)
          .set(comment.toMap());
      return true;
    } catch (e) {
      print('Add comment error: $e');
      return false;
    }
  }

  // Get comments for a post
  Stream<List<Comment>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Delete comment
  Future<bool> deleteComment(String postId, String commentId) async {
    try {
      // Admin validation for comment deletion
      if (!await _validateAdmin()) {
        return false;
      }

      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
      return true;
    } catch (e) {
      print('Delete comment error: $e');
      return false;
    }
  }

  // Upload image to Firebase Storage
  Future<String?> uploadImage(List<int> imageBytes, String fileName) async {
    try {
      final ref = _storage.ref().child('blog_images/$fileName');
      await ref.putData(Uint8List.fromList(imageBytes));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Upload image error: $e');
      return null;
    }
  }

  // Delete image from Firebase Storage
  Future<bool> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } catch (e) {
      print('Delete image error: $e');
      return false;
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).update(userData);
      return true;
    } catch (e) {
      print('Update user profile error: $e');
      return false;
    }
  }

  // Check if user is admin
  Future<bool> isAdmin(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        return userData?['isAdmin'] == true;
      }
      return false;
    } catch (e) {
      print('Check admin error: $e');
      return false;
    }
  }

  // Get posts by category
  Stream<List<BlogPost>> getPostsByCategory(String category) {
    return _firestore
        .collection('posts')
        .where('tags', arrayContains: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BlogPost.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Search posts
  Stream<List<BlogPost>> searchPosts(String query) {
    return _firestore
        .collection('posts')
        .orderBy('title')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .where((doc) {
        final post = BlogPost.fromMap(doc.data() as Map<String, dynamic>);
        return post.title.toLowerCase().contains(query.toLowerCase()) ||
            post.content.toLowerCase().contains(query.toLowerCase()) ||
            post.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
      })
          .map((doc) => BlogPost.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get popular posts (most liked)
  Stream<List<BlogPost>> getPopularPosts() {
    return _firestore
        .collection('posts')
        .orderBy('likes', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BlogPost.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}