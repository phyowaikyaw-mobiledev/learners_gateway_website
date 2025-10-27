import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBar(), // always visible, not part of stagger
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: StaggeredFadeIn(
                  children: [
                    HeroSection(),
                    FeaturedCoursesSection(),
                    WhyChooseUsSection(),
                    StatsSection(),
                    Footer(),
                  ],
                )
            ),
          ],
        ), // Fixed: Added closing bracket for Column and removed stray '>'
      ),
    );
  }
}

class StaggeredFadeIn extends StatelessWidget {
  final List<Widget> children;
  final Duration delayBetween;
  final Duration duration;

  const StaggeredFadeIn({
    super.key,
    required this.children,
    this.delayBetween = const Duration(milliseconds: 120),
    this.duration = const Duration(milliseconds: 450),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < children.length; i++)
          RevealOnScroll(
            child: children[i],
            delay: Duration(milliseconds: delayBetween.inMilliseconds * i),
            duration: duration,
          ),
      ],
    );
  }
}


class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00B4D8).withOpacity(0.05),
            const Color(0xFFCAF542).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isMobile ? _buildMobileHero(context) : _buildDesktopHero(context),
    );
  }

  Widget _buildDesktopHero(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
                ).createShader(bounds),
                child: const Text(
                  'Welcome to Learners Gateway',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Master coding and technology with our comprehensive courses and tutorials. Learn from industry experts and build your dream career.',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF023E8A),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 20,
                runSpacing: 15,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00B4D8).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => context.go('/courses'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Explore Courses',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => context.go('/tutorials'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00B4D8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      side: const BorderSide(color: Color(0xFF00B4D8), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'View Tutorials',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 60),
        Expanded(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00B4D8).withOpacity(0.1),
                  const Color(0xFFCAF542).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00B4D8).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.code,
                size: 200,
                color: Color(0xFF00B4D8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHero(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
          ).createShader(bounds),
          child: const Text(
            'Welcome to Learners Gateway',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Master coding and technology with our comprehensive courses and tutorials.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF023E8A),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00B4D8).withOpacity(0.1),
                const Color(0xFFCAF542).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF00B4D8).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.code,
              size: 120,
              color: Color(0xFF00B4D8),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () => context.go('/courses'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Explore Courses', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/tutorials'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00B4D8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF00B4D8), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('View Tutorials', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FeaturedCoursesSection extends StatelessWidget {
  const FeaturedCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 80),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
            ).createShader(bounds),
            child: const Text(
              'Featured Courses',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Start learning with our most popular courses',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF023E8A),
            ),
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: isMobile ? 1.2 : 0.85,
            children: const [
              CourseCard(
                title: 'Python Programming',
                description: 'Learn Python from basics to advanced',
                icon: Icons.code,
                gradient: LinearGradient(
                  colors: [Color(0xFF00B4D8), Color(0xFF48CAE4)],
                ),
              ),
              CourseCard(
                title: 'Web Development',
                description: 'Master HTML, CSS, and JavaScript',
                icon: Icons.web,
                gradient: LinearGradient(
                  colors: [Color(0xFF0096C7), Color(0xFF00B4D8)],
                ),
              ),
              CourseCard(
                title: 'Flutter Development',
                description: 'Build beautiful mobile and web apps',
                icon: Icons.phone_android,
                gradient: LinearGradient(
                  colors: [Color(0xFFCAF542), Color(0xFF90E0EF)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;

  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF03045E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF023E8A),
              height: 1.5,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => context.go('/courses'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF00B4D8),
            ),
            child: const Text('Learn More →', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00B4D8).withOpacity(0.05),
            const Color(0xFFCAF542).withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
            ).createShader(bounds),
            child: const Text(
              'Why Choose Learners Gateway?',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: isMobile ? 2 : 2.5,
            children: const [
              FeatureCard(
                icon: Icons.school,
                title: 'Expert Instructors',
                description: 'Learn from industry professionals',
                gradient: LinearGradient(
                  colors: [Color(0xFF00B4D8), Color(0xFF48CAE4)],
                ),
              ),
              FeatureCard(
                icon: Icons.access_time,
                title: 'Flexible Learning',
                description: 'Study at your own pace',
                gradient: LinearGradient(
                  colors: [Color(0xFF0096C7), Color(0xFF00B4D8)],
                ),
              ),
              FeatureCard(
                icon: Icons.verified,
                title: 'Certificates',
                description: 'Earn recognized certifications',
                gradient: LinearGradient(
                  colors: [Color(0xFFCAF542), Color(0xFF90E0EF)],
                ),
              ),
              FeatureCard(
                icon: Icons.support_agent,
                title: '24/7 Support',
                description: 'Get help whenever you need',
                gradient: LinearGradient(
                  colors: [Color(0xFF48CAE4), Color(0xFFCAF542)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF023E8A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      padding: EdgeInsets.all(isMobile ? 40 : 80),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A1128), Color(0xFF03045E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: isMobile ? 1.2 : 1.5,
        children: const [
          StatCard(number: '10K+', label: 'Students', color: Color(0xFF00B4D8)),
          StatCard(number: '50+', label: 'Courses', color: Color(0xFF48CAE4)),
          StatCard(number: '100+', label: 'Tutorials', color: Color(0xFF90E0EF)),
          StatCard(number: '95%', label: 'Success Rate', color: Color(0xFFCAF542)),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String number;
  final String label;
  final Color color;

  const StatCard({
    super.key,
    required this.number,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );

  }
}

class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double visibleFractionToTrigger; // e.g. 0.12

  const RevealOnScroll({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.visibleFractionToTrigger = 0.12,
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(_c);
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_started && info.visibleFraction >= widget.visibleFractionToTrigger) {
      _started = true;
      Future.delayed(widget.delay, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('reveal-${widget.child.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
  }
}
