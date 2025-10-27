// footer.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 30 : 60),
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
      ),
      child: Column(
        children: [
          isMobile ? _buildMobileFooter(context) : _buildDesktopFooter(context),
          const SizedBox(height: 30),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          Text(
            '© 2025 Learners Gateway. All rights reserved.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final leftWidth = (screenWidth * 0.35).clamp(260.0, 520.0);
    final middleWidth = (screenWidth * 0.25).clamp(180.0, 360.0);
    final rightWidth = (screenWidth * 0.25).clamp(180.0, 360.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: leftWidth, child: _aboutColumn(context)),
        SizedBox(width: middleWidth, child: _quickLinksColumn(context)),
        SizedBox(width: rightWidth, child: _contactColumn(context)),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _aboutColumn(context),
        const SizedBox(height: 30),
        _quickLinksColumn(context),
        const SizedBox(height: 30),
        _contactColumn(context),
      ],
    );
  }

  Widget _aboutColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Learners Gateway',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Empowering learners worldwide with quality tech education and coding knowledge.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _SocialIcon(
              icon: FontAwesomeIcons.facebook,
              url: 'https://www.facebook.com/share/17Bcwbpgyf/',
            ),
            const SizedBox(width: 15),
            _SocialIcon(
              icon: FontAwesomeIcons.telegram,
              url: 'https://t.me/learnersgateway',
            ),
            const SizedBox(width: 15),
            _SocialIcon(
              icon: FontAwesomeIcons.youtube,
              url: 'https://www.youtube.com/@learnersgateway_mm',
            ),
            const SizedBox(width: 15),
            _SocialIcon(
              icon: FontAwesomeIcons.github,
              url: 'https://github.com',
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickLinksColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        _FooterLink(title: 'Home', onTap: () => GoRouter.of(context).go('/')),
        _FooterLink(title: 'Courses', onTap: () => GoRouter.of(context).go('/courses')),
        _FooterLink(title: 'Tutorials', onTap: () => GoRouter.of(context).go('/tutorials')),
        _FooterLink(title: 'Blog', onTap: () => GoRouter.of(context).go('/blog')),
        _FooterLink(title: 'About Us', onTap: () => GoRouter.of(context).go('/about')),
      ],
    );
  }

  Widget _contactColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Contact Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        _ContactInfo(
          icon: Icons.email,
          text: 'learnersgateway.mm@gmail.com',
        ),
        SizedBox(height: 10),
        _ContactInfo(
          icon: Icons.phone,
          text: '+66 61 809 8313',
        ),
        SizedBox(height: 10),
        _ContactInfo(
          icon: Icons.location_on,
          text: 'Bangkok , Thailand',
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot open link')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FaIcon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _FooterLink({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
