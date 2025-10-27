import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';
import 'home_page.dart';


class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Programming',
    'Web Development',
    'Mobile Development',
    'Data Science',
    'DevOps'
  ];

  final List<Course> courses = [
    Course(
      title: 'Java',
      category: 'Programming',
      level: 'Advanced',
      duration: '12 weeks',
      students: 5000,
      rating: 5.1,
      price: '\$150',
      description: 'Build anything with Java — powerful, fast, and everywhere',
      icon: Icons.code,
      color: Color(0xFFFF4081),
    ),
    Course(
      title: 'Python for Beginners',
      category: 'Programming',
      level: 'Beginner',
      duration: '8 weeks',
      students: 2500,
      rating: 4.8,
      price: 'Free',
      description: 'Learn Python from scratch with hands-on projects',
      icon: Icons.code,
      color: Color(0xFF4CAF50),
    ),
    Course(
      title: 'JavaScript Masterclass',
      category: 'Programming',
      level: 'Intermediate',
      duration: '10 weeks',
      students: 1800,
      rating: 4.7,
      price: '\$49',
      description: 'Master JavaScript and modern ES6+ features',
      icon: Icons.javascript,
      color: Color(0xFFFFC107),
    ),
    Course(
      title: 'Full Stack Web Development',
      category: 'Web Development',
      level: 'Advanced',
      duration: '16 weeks',
      students: 3200,
      rating: 4.9,
      price: '\$99',
      description: 'Become a full-stack developer with MERN stack',
      icon: Icons.web,
      color: Color(0xFF2196F3),
    ),
    Course(
      title: 'Flutter Mobile Development',
      category: 'Mobile Development',
      level: 'Intermediate',
      duration: '12 weeks',
      students: 1500,
      rating: 4.6,
      price: '\$79',
      description: 'Build beautiful cross-platform mobile apps',
      icon: Icons.phone_android,
      color: Color(0xFF00BCD4),
    ),
    Course(
      title: 'React Native Essentials',
      category: 'Mobile Development',
      level: 'Intermediate',
      duration: '10 weeks',
      students: 1200,
      rating: 4.5,
      price: '\$69',
      description: 'Create native mobile apps with React',
      icon: Icons.mobile_friendly,
      color: Color(0xFF9C27B0),
    ),
    Course(
      title: 'Data Science with Python',
      category: 'Data Science',
      level: 'Advanced',
      duration: '14 weeks',
      students: 2800,
      rating: 4.8,
      price: '\$129',
      description: 'Master data analysis and machine learning',
      icon: Icons.analytics,
      color: Color(0xFFFF5722),
    ),
    Course(
      title: 'Docker & Kubernetes',
      category: 'DevOps',
      level: 'Advanced',
      duration: '8 weeks',
      students: 1600,
      rating: 4.7,
      price: '\$89',
      description: 'Learn containerization and orchestration',
      icon: Icons.cloud,
      color: Color(0xFF607D8B),
    ),
    Course(
      title: 'HTML & CSS Fundamentals',
      category: 'Web Development',
      level: 'Beginner',
      duration: '6 weeks',
      students: 4500,
      rating: 4.9,
      price: 'Free',
      description: 'Build responsive websites from scratch',
      icon: Icons.design_services,
      color: Color(0xFFE91E63),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    final filteredCourses = selectedCategory == 'All'
        ? courses
        : courses.where((c) => c.category == selectedCategory).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBar(),

            // Page Header -> reveal on scroll
            RevealOnScroll(
              delay: const Duration(milliseconds: 0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 40 : 80),
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
                      'Our Courses',
                      style: TextStyle(
                        fontSize: isMobile ? 32 : 48,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Choose from our wide range of tech courses',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 18,
                        color: const Color(0xFF616161),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Category Filter -> reveal on scroll
            RevealOnScroll(
              delay: const Duration(milliseconds: 120),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 20 : 40),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: categories.map((category) {
                        final isSelected = selectedCategory == category;
                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFF2196F3),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF616161),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Courses Grid -> reveal on scroll; each card has its own small delay
            RevealOnScroll(
              delay: const Duration(milliseconds: 240),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 20 : 60),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : (screenWidth < 1200 ? 2 : 3),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: isMobile ? 0.85 : 0.75,
                  ),
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    // small incremental delay per card for a pleasing cascade
                    final cardDelay = Duration(milliseconds: index * 60);
                    return RevealOnScroll(
                      delay: cardDelay,
                      child: CourseDetailCard(course: course),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Footer -> reveal on scroll
            RevealOnScroll(
              delay: const Duration(milliseconds: 360),
              child: const Footer(),
            ),
          ],
        ),
      ),
    );
  }
}

class Course {
  final String title;
  final String category;
  final String level;
  final String duration;
  final int students;
  final double rating;
  final String price;
  final String description;
  final IconData icon;
  final Color color;

  Course({
    required this.title,
    required this.category,
    required this.level,
    required this.duration,
    required this.students,
    required this.rating,
    required this.price,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class CourseDetailCard extends StatelessWidget {
  final Course course;

  const CourseDetailCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Header with Icon
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: course.color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(course.icon, size: 40, color: course.color),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: course.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Course Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF616161),
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),

                  // Level Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getLevelColor(course.level).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      course.level,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getLevelColor(course.level),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Course Info Row
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Color(0xFF616161)),
                      const SizedBox(width: 5),
                      Text(
                        course.duration,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF616161)),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.people, size: 16, color: Color(0xFF616161)),
                      const SizedBox(width: 5),
                      Text(
                        '${course.students}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF616161)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Rating and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18, color: Color(0xFFFFC107)),
                          const SizedBox(width: 5),
                          Text(
                            '${course.rating}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        course.price,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Enroll Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: course.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Enroll Now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Beginner':
        return const Color(0xFF4CAF50);
      case 'Intermediate':
        return const Color(0xFFFF9800);
      case 'Advanced':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF616161);
    }
  }
}
