import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBar(),

            // Hero Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 40 : 100),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2196F3).withOpacity(0.1),
                    const Color(0xFF1976D2).withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'About Learners Gateway',
                    style: TextStyle(
                      fontSize: isMobile ? 32 : 48,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A237E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Empowering learners worldwide with quality tech education',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      color: const Color(0xFF616161),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Mission & Vision
            Container(
              padding: EdgeInsets.all(isMobile ? 30 : 80),
              child: isMobile ? _buildMobileMissionVision() : _buildDesktopMissionVision(),
            ),

            // Our Story
            Container(
              padding: EdgeInsets.all(isMobile ? 30 : 80),
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  const Text(
                    'Our Story',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Learners Gateway was founded in 2020 with a simple mission: to make quality tech education accessible to everyone, everywhere. What started as a small blog sharing coding tutorials has grown into a comprehensive learning platform serving thousands of students worldwide.\n\nWe believe that technology education should be engaging, practical, and accessible. Our team of experienced developers and educators work tirelessly to create content that not only teaches technical skills but also inspires creativity and problem-solving.\n\nToday, we offer hundreds of courses, tutorials, and articles covering everything from basic programming to advanced software architecture. Our community of learners continues to grow, and we\'re committed to evolving with the ever-changing tech landscape.',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: const Color(0xFF616161),
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Team Section
            Container(
              padding: EdgeInsets.all(isMobile ? 30 : 80),
              child: Column(
                children: [
                  const Text(
                    'Meet Our Team',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 40),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate responsive columns
                      int columns = isMobile ? 1 : (constraints.maxWidth > 1200 ? 4 : 2);
                      double spacing = isMobile ? 15 : 20;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        alignment: WrapAlignment.center,
                        children: const [
                          TeamMemberCard(
                            name: 'Su Yin',
                            role: 'Founder & CEO',
                            color: Color(0xFF2196F3),
                            imageUrl: 'assets/images/su.jpg',
                          ),
                          TeamMemberCard(
                            name: 'Phyo Wai Kyaw',
                            role: 'Founder & CEO',
                            color: Color(0xFF4CAF50),
                            imageUrl: 'assets/images/phyo.jpg',
                          ),
                          TeamMemberCard(
                            name: 'Andrew',
                            role: 'Content Director',
                            color: Color(0xFF9C27B0),
                            imageUrl: 'assets/images/andrew.jpg',
                          ),
                          TeamMemberCard(
                            name: 'Teacher Su',
                            role: 'Lead Instructor',
                            color: Color(0xFFFF9800),
                            imageUrl: 'assets/images/teachersu.jpg',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Values Section
            Container(
              padding: EdgeInsets.all(isMobile ? 30 : 80),
              color: const Color(0xFF1A237E),
              child: Column(
                children: [
                  const Text(
                    'Our Core Values',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isMobile ? 1 : 3,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    childAspectRatio: isMobile ? 2 : 1.2,
                    children: const [
                      ValueCard(
                        icon: Icons.lightbulb,
                        title: 'Innovation',
                        description: 'We embrace new technologies and teaching methods',
                      ),
                      ValueCard(
                        icon: Icons.people,
                        title: 'Community',
                        description: 'We foster a supportive learning environment',
                      ),
                      ValueCard(
                        icon: Icons.star,
                        title: 'Excellence',
                        description: 'We maintain high standards in everything we do',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopMissionVision() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF2196F3).withOpacity(0.2),
              ),
            ),
            child: Column(
              children: const [
                Icon(
                  Icons.rocket_launch,
                  size: 60,
                  color: Color(0xFF2196F3),
                ),
                SizedBox(height: 20),
                Text(
                  'Our Mission',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'To provide accessible, high-quality tech education that empowers individuals to build successful careers in technology and make meaningful contributions to the digital world.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF616161),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF4CAF50).withOpacity(0.2),
              ),
            ),
            child: Column(
              children: const [
                Icon(
                  Icons.visibility,
                  size: 60,
                  color: Color(0xFF4CAF50),
                ),
                SizedBox(height: 20),
                Text(
                  'Our Vision',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'To become the world\'s leading platform for tech education, where learners from all backgrounds can discover their potential and transform their careers through technology.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF616161),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileMissionVision() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF2196F3).withOpacity(0.2),
            ),
          ),
          child: Column(
            children: const [
              Icon(
                Icons.rocket_launch,
                size: 50,
                color: Color(0xFF2196F3),
              ),
              SizedBox(height: 15),
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'To provide accessible, high-quality tech education that empowers individuals to build successful careers in technology.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF616161),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF4CAF50).withOpacity(0.2),
            ),
          ),
          child: Column(
            children: const [
              Icon(
                Icons.visibility,
                size: 50,
                color: Color(0xFF4CAF50),
              ),
              SizedBox(height: 15),
              Text(
                'Our Vision',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'To become the world\'s leading platform for tech education, where learners from all backgrounds can discover their potential.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF616161),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final Color color;
  final String? imageUrl;

  const TeamMemberCard({
    super.key,
    required this.name,
    required this.role,
    required this.color,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    // Responsive card width
    double cardWidth = isMobile ? screenWidth - 60 : 280;

    return Container(
      width: cardWidth,
      constraints: const BoxConstraints(
        minHeight: 200,
        maxHeight: 350,
      ),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar with Image Support
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: imageUrl != null
                ? ClipOval(
              child: Image.asset(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackAvatar(color);
                },
              ),
            )
                : _buildFallbackAvatar(color),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            role,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar(Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
      ),
      child: Center(
        child: Text(
          name[0],
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}

class ValueCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ValueCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}