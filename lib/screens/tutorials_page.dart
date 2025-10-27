import 'package:flutter/material.dart';

class TutorialsPage extends StatelessWidget {
  const TutorialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    const Color(0xFF0077B6),
                    const Color(0xFF00B4D8),
                    const Color(0xFFCAF542).withOpacity(0.2),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Free Tutorials',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Step-by-step guides to master new skills',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              padding: const EdgeInsets.all(30),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00B4D8).withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search tutorials...',
                    prefixIcon: Icon(Icons.search, color: const Color(0xFF00B4D8)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                ),
              ),
            ),

            // Categories
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  _buildCategoryChip(Icons.code, 'Programming'),
                  _buildCategoryChip(Icons.palette, 'Design'),
                  _buildCategoryChip(Icons.phone_android, 'Mobile'),
                  _buildCategoryChip(Icons.language, 'Web Dev'),
                  _buildCategoryChip(Icons.storage, 'Database'),
                ],
              ),
            ),

            // Tutorials List
            Container(
              padding: const EdgeInsets.all(30),
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: List.generate(
                  6,
                      (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: _buildTutorialCard(index),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00B4D8).withOpacity(0.1),
            const Color(0xFFCAF542).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF00B4D8).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF00B4D8), size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF03045E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(int index) {
    final tutorials = [
      {
        'title': 'Flutter Basics: Building Your First App',
        'description': 'Learn the fundamentals of Flutter and create your first mobile application from scratch.',
        'duration': '45 min',
        'level': 'Beginner',
        'lessons': '12',
        'icon': Icons.phone_android,
      },
      {
        'title': 'Responsive Web Design with CSS Grid',
        'description': 'Master CSS Grid layout system and create beautiful responsive websites.',
        'duration': '35 min',
        'level': 'Intermediate',
        'lessons': '8',
        'icon': Icons.web,
      },
      {
        'title': 'Python Data Analysis with Pandas',
        'description': 'Explore data manipulation and analysis using the powerful Pandas library.',
        'duration': '60 min',
        'level': 'Intermediate',
        'lessons': '15',
        'icon': Icons.analytics,
      },
      {
        'title': 'UI/UX Design Principles',
        'description': 'Understand the core principles of creating user-friendly and beautiful interfaces.',
        'duration': '40 min',
        'level': 'Beginner',
        'lessons': '10',
        'icon': Icons.design_services,
      },
      {
        'title': 'React Hooks Deep Dive',
        'description': 'Master React Hooks and learn how to write modern, efficient React components.',
        'duration': '50 min',
        'level': 'Advanced',
        'lessons': '14',
        'icon': Icons.code,
      },
      {
        'title': 'Git & GitHub for Beginners',
        'description': 'Learn version control with Git and collaborate using GitHub.',
        'duration': '30 min',
        'level': 'Beginner',
        'lessons': '9',
        'icon': Icons.source,
      },
    ];

    final tutorial = tutorials[index % tutorials.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive layout
            if (constraints.maxWidth > 700) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIcon(tutorial['icon'] as IconData),
                  const SizedBox(width: 30),
                  Expanded(child: _buildTutorialContent(tutorial)),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildIcon(tutorial['icon'] as IconData),
                  const SizedBox(height: 20),
                  _buildTutorialContent(tutorial),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00B4D8),
            const Color(0xFF0077B6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTutorialContent(Map<String, dynamic> tutorial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFCAF542),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tutorial['level']!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF03045E),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.timer_outlined, color: Colors.grey[400], size: 18),
            const SizedBox(width: 4),
            Text(
              tutorial['duration']!,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(Icons.play_circle_outline, color: Colors.grey[400], size: 18),
            const SizedBox(width: 4),
            Text(
              '${tutorial['lessons']} lessons',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          tutorial['title']!,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF03045E),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          tutorial['description']!,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF00B4D8),
                    Color(0xFF0077B6),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Start Learning',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00B4D8)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.bookmark_border,
                color: Color(0xFF00B4D8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}