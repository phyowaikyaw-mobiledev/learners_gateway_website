import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'services/firebase_service.dart';
import 'screens/home_page.dart';
import 'screens/courses_page.dart';
import 'screens/tutorials_page.dart';
import 'screens/blog_page.dart';
import 'screens/about_page.dart';
import 'screens/contact_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAwKskm7vGlssSDWpvddYnemT7TbXCKKnU",
      authDomain: "learners-gateway.firebaseapp.com",
      projectId: "learners-gateway",
      storageBucket: "learners-gateway.firebasestorage.app",
      messagingSenderId: "183142236733",
      appId: "1:183142236733:web:3cb314dc4b27288eab9a054",
      measurementId: "G-M4GFXGWS1M",
    ),
  );

  runApp(const LearnersGatewayApp());
}

class LearnersGatewayApp extends StatelessWidget {
  const LearnersGatewayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(  // ✅ ChangeNotifierProvider သုံးပါ
      create: (_) => FirebaseService(),
      child: MaterialApp.router(
        title: 'Learners Gateway',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF00B4D8),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00B4D8),
            secondary: Color(0xFFCAF542),
          ),
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/courses',
      builder: (context, state) => const CoursesPage(),
    ),
    GoRoute(
      path: '/tutorials',
      builder: (context, state) => const TutorialsPage(),
    ),
    GoRoute(
      path: '/blog',
      builder: (context, state) => const BlogPage(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutPage(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            'Page Not Found',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('The page you are looking for does not exist.'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);