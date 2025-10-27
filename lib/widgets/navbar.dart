import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/blog_post.dart';
import '../services/firebase_service.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final firebaseService = Provider.of<FirebaseService>(context, listen: true);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: _buildLogoOrAdminAvatar(context, isMobile, firebaseService),
          ),

          if (isMobile)
            _buildMobileMenu(context, firebaseService)
          else
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildDesktopMenu(context, firebaseService),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoOrAdminAvatar(BuildContext context, bool isMobile, FirebaseService firebaseService) {
    final isLoggedIn = firebaseService.currentUser != null;

    return InkWell(
      onTap: () => context.go('/'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoggedIn)
            _buildAdminAvatar(isMobile, firebaseService)
          else
            _buildLogo(isMobile),

          const SizedBox(width: 12),

          Flexible(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF00B4D8),
                  Color(0xFF0096C7),
                ],
              ).createShader(bounds),
              child: Text(
                'Learners Gateway',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isMobile) {
    return Container(
      height: isMobile ? 40 : 50,
      width: isMobile ? 40 : 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00B4D8),
            Color(0xFF0096C7),
            Color(0xFFCAF542),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B4D8).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/logo1.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF00B4D8),
                    Color(0xFF0096C7),
                    Color(0xFFCAF542),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: isMobile ? 20 : 28,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdminAvatar(bool isMobile, FirebaseService firebaseService) {
    final user = firebaseService.currentUser;
    final displayName = user?.displayName ?? 'Admin';
    final email = user?.email ?? '';

    String getInitials() {
      if (displayName.isNotEmpty && displayName != 'Admin') {
        final names = displayName.split(' ');
        if (names.length > 1) {
          return '${names[0][0]}${names[1][0]}'.toUpperCase();
        }
        return displayName.substring(0, 1).toUpperCase();
      }
      if (email.isNotEmpty) {
        return email.substring(0, 1).toUpperCase();
      }
      return 'A';
    }

    return Tooltip(
      message: 'Logged in as $displayName\n$email',
      child: Container(
        height: isMobile ? 40 : 50,
        width: isMobile ? 40 : 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFCAF542),
              Color(0xFF00B4D8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00B4D8).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: user?.photoURL != null
              ? ClipOval(
            child: Image.network(
              user!.photoURL!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildInitialsAvatar(getInitials(), isMobile);
              },
            ),
          )
              : _buildInitialsAvatar(getInitials(), isMobile),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(String initials, bool isMobile) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 14 : 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDesktopMenu(BuildContext context, FirebaseService firebaseService) {
    final isLoggedIn = firebaseService.currentUser != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.end,
            children: [
              _NavLink(title: 'Home', route: '/'),
              _NavLink(title: 'Courses', route: '/courses'),
              _NavLink(title: 'Tutorials', route: '/tutorials'),
              _NavLink(title: 'Blog', route: '/blog'),
              _NavLink(title: 'About', route: '/about'),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Flexible(
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            alignment: WrapAlignment.end,
            children: [
              if (isLoggedIn) ...[
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width < 1000 ? 110 : 130,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFCAF542), Color(0xFF90E0EF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _showCreatePostDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 14, color: Color(0xFF03045E)),
                    label: Text(
                      'Create Post',
                      style: TextStyle(
                        color: const Color(0xFF03045E),
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width < 1000 ? 10 : 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 90),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00B4D8), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout, size: 14, color: Color(0xFF00B4D8)),
                    label: Text(
                      'Logout',
                      style: TextStyle(
                        color: const Color(0xFF00B4D8),
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width < 1000 ? 10 : 12,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width < 1000 ? 120 : 140,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _showLoginDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.admin_panel_settings, size: 14, color: Colors.white),
                    label: Text(
                      'Admin Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width < 1000 ? 10 : 12,
                      ),
                    ),
                  ),
                ),
              ],

              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width < 1000 ? 100 : 120,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () => context.go('/contact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width < 1000 ? 10 : 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileMenu(BuildContext context, FirebaseService firebaseService) {
    final isLoggedIn = firebaseService.currentUser != null;
    final user = firebaseService.currentUser;

    return Container(
      constraints: const BoxConstraints(maxWidth: 100),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoggedIn && user != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Tooltip(
                message: 'Logged in as ${user.displayName ?? user.email}',
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF00B4D8),
                  child: user.photoURL != null
                      ? ClipOval(
                    child: Image.network(
                      user.photoURL!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Text(
                    user.displayName?.substring(0, 1).toUpperCase() ??
                        user.email?.substring(0, 1).toUpperCase() ?? 'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),

          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF00B4D8), size: 24),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(maxWidth: 40),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF0A1128),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                isScrollControlled: true,
                builder: (context) => SafeArea(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // FIX: Reduced vertical padding to eliminate the 0.12px overflow
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Reduced from 10 to 8
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isLoggedIn && user != null) ...[
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: const Color(0xFF00B4D8),
                                      child: user.photoURL != null
                                          ? ClipOval(
                                        child: Image.network(
                                          user.photoURL!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                          : Text(
                                        user.displayName?.substring(0, 1).toUpperCase() ??
                                            user.email?.substring(0, 1).toUpperCase() ?? 'A',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.displayName ?? 'Admin',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            user.email ?? '',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.white54, height: 16), // Reduced from 20 to 16
                              ],
                            ],
                          ),
                        ),

                        // FIX: Use ListView.builder for more efficient rendering
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              _MobileNavLink(title: 'Home', route: '/'),
                              _MobileNavLink(title: 'Courses', route: '/courses'),
                              _MobileNavLink(title: 'Tutorials', route: '/tutorials'),
                              _MobileNavLink(title: 'Blog', route: '/blog'),
                              _MobileNavLink(title: 'About', route: '/about'),
                              _MobileNavLink(title: 'Contact', route: '/contact'),

                              if (isLoggedIn) ...[
                                const Divider(color: Colors.white54, height: 16), // Reduced from 20 to 16
                                _MobileNavLink(
                                    title: 'Create Post',
                                    route: '',
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showCreatePostDialog(context);
                                    }
                                ),
                                _MobileNavLink(
                                    title: 'Logout',
                                    route: '',
                                    onTap: () {
                                      Navigator.pop(context);
                                      _logout(context);
                                    }
                                ),
                              ] else ...[
                                const Divider(color: Colors.white54, height: 16), // Reduced from 20 to 16
                                _MobileNavLink(
                                    title: 'Admin Login',
                                    route: '',
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showLoginDialog(context);
                                    }
                                ),
                              ],
                            ],
                          ),
                        ),

                        // FIX: Add minimal bottom padding
                        const SizedBox(height: 4), // Minimal padding to avoid overflow
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              if (email.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              final user = await firebaseService.signIn(email, password);
              if (user != null) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login failed. Check your credentials.')),
                );
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final tagsController = TextEditingController();
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Blog Post'),
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

              final post = BlogPost(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                content: content,
                author: firebaseService.currentUser?.displayName ?? 'Admin',
                authorId: firebaseService.currentUser!.uid,
                tags: tags.isNotEmpty ? tags.split(',').map((tag) => tag.trim()).toList() : ['General'],
                likes: [],
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              final success = await firebaseService.createPost(post);
              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post created successfully!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to create post')),
                );
              }
            },
            child: const Text('Create Post'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    await firebaseService.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String title;
  final String route;

  const _NavLink({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: () => context.go(route),
        child: Text(
          title,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width < 1000 ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF023E8A),
          ),
        ),
      ),
    );
  }
}

class _MobileNavLink extends StatelessWidget {
  final String title;
  final String route;
  final VoidCallback? onTap;

  const _MobileNavLink({
    required this.title,
    required this.route,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true, // FIX: Make list tile more compact
      visualDensity: VisualDensity.compact, // FIX: Reduce visual density
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), // FIX: Reduce padding
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Container(
        width: 4,
        height: 16, // Reduced from 20 to 16
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00B4D8), Color(0xFFCAF542)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      onTap: onTap ?? () {
        Navigator.pop(context);
        if (route.isNotEmpty) {
          context.go(route);
        }
      },
    );
  }
}