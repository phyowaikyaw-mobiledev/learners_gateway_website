import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';
import 'home_page.dart'; // <- added

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text('Message sent successfully! We will get back to you soon.'),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 3),
        ),
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // keep NavBar static for better UX
            const NavBar(),

            // Page Header - reveal on scroll
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
                      'Get In Touch',
                      style: TextStyle(
                        fontSize: isMobile ? 32 : 48,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Have questions? We\'d love to hear from you',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 18,
                        color: const Color(0xFF616161),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Contact Content (form + social) - reveal on scroll
            RevealOnScroll(
              delay: const Duration(milliseconds: 120),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 30 : 80),
                child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
              ),
            ),

            const SizedBox(height: 10),

            // Quick Contact Cards - reveal on scroll
            RevealOnScroll(
              delay: const Duration(milliseconds: 240),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 30 : 80),
                color: const Color(0xFFF5F5F5),
                child: Column(
                  children: [
                    const Text(
                      'Other Ways to Reach Us',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 40),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isMobile ? 1 : 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: isMobile ? 2 : 1.5,
                      children: const [
                        ContactInfoCard(
                          icon: Icons.email,
                          title: 'Email Us',
                          content: 'learnersgateway.mm@gmail.com',
                          color: Color(0xFF2196F3),
                        ),
                        ContactInfoCard(
                          icon: Icons.phone,
                          title: 'Call Us',
                          content: '+66 61 809 8313',
                          color: Color(0xFF4CAF50),
                        ),
                        ContactInfoCard(
                          icon: Icons.location_on,
                          title: 'Visit Us',
                          content: 'Bangkok , Thailand',
                          color: Color(0xFFFF9800),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Footer - reveal on scroll
            RevealOnScroll(
              delay: const Duration(milliseconds: 360),
              child: const Footer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildContactForm(),
        ),
        const SizedBox(width: 60),
        Expanded(
          child: _buildSocialSection(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildContactForm(),
        const SizedBox(height: 40),
        _buildSocialSection(),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send us a Message',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 30),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Your Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Subject Field
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                prefixIcon: const Icon(Icons.subject),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Message Field
            TextFormField(
              controller: _messageController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Your Message',
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Icon(Icons.message),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your message';
                }
                if (value.length < 10) {
                  return 'Message must be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Send Message',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2196F3).withOpacity(0.1),
                const Color(0xFF1976D2).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Connect With Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Follow us on social media for the latest updates, tutorials, and tech news.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF616161),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 30),

              _SocialButton(
                icon: FontAwesomeIcons.facebook,
                label: 'Facebook',
                color: const Color(0xFF1877F2),
                onTap: () async {
                  const url = 'https://www.facebook.com/share/17Bcwbpgyf/';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              const SizedBox(height: 15),
              _SocialButton(
                icon: FontAwesomeIcons.youtube,
                label: 'YouTube',
                color: const Color(0xFFFF0000),
                onTap: () async {
                  const url = 'https://www.youtube.com/@learnersgateway_mm';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              const SizedBox(height: 15),
              _SocialButton(
                icon: FontAwesomeIcons.telegram,
                label: 'Telegram',
                color: const Color(0xFF1DA1F2),
                onTap: () async {
                  const url = 'https://t.me/learnersgateway';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              const SizedBox(height: 15),
              _SocialButton(
                icon: FontAwesomeIcons.github,
                label: 'GitHub',
                color: const Color(0xFF333333),
                onTap: () {},
              ),
              const SizedBox(height: 15),
              _SocialButton(
                icon: FontAwesomeIcons.linkedin,
                label: 'LinkedIn',
                color: const Color(0xFF0A66C2),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // FAQ Link
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.help_outline,
                size: 50,
                color: Color(0xFF4CAF50),
              ),
              const SizedBox(height: 15),
              const Text(
                'Need Quick Answers?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Check out our FAQ section for common questions and answers.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF616161),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View FAQ'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            FaIcon(icon, color: color, size: 24),
            const SizedBox(width: 15),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A237E),
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const ContactInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF616161),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
