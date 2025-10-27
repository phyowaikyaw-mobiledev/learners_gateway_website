# Learners Gateway - Tech Education Platform 🎓

A Flutter web application for sharing tech knowledge, tutorials, and blog posts.  
This is an **ongoing learning project** where I'm building a community platform while mastering Flutter web and Firebase.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

**Live Demo:** [learners-gateway.web.app](https://learners-gateway.web.app/)

---

## 🌟 About This Project

**Project Status:** 🚧 In Development (60-70% Complete)

I'm building this platform to support my tech education community on Facebook (Learners Gateway).  
This is my **first Flutter web project**, and I'm learning Flutter web development, Firebase integration, and web security concepts as I build it.

### Learning Approach

This project involves:
- **Self-learning** through official Flutter and Firebase documentation  
- **AI assistance** (ChatGPT, Claude) for understanding complex concepts  
- **Problem-solving** by debugging real issues  
- **Community feedback** from fellow developers  

**Transparency Note:** Some advanced implementations like Firebase security rules, admin authentication, and input validation were developed with AI guidance. I'm actively studying these patterns to understand them deeply.

---

## ✅ Implemented Features

### User-Facing Features
- **Homepage** with animated sections and course showcase  
- **Blog System** with post listing and filtering by category  
- **Post Details** with likes and comments functionality  
- **Responsive Design** for mobile and desktop views  
- **Navigation** with go_router for clean URL routing  

### Admin Features (Login Required)
- **Create Blog Posts** with title, content, and tags  
- **Edit Posts** with real-time updates  
- **Delete Posts** with confirmation dialog  
- **Admin Badge** showing admin mode status  
- **Comment Management** (viewing, planned deletion)

### Technical Features
- **Firebase Authentication** for admin login  
- **Cloud Firestore** for data storage (posts, comments)  
- **Real-time Updates** with Firestore streams  
- **State Management** using Provider pattern  
- **Input Validation** for security  
- **Responsive UI** with Flutter's MediaQuery  

---

## 🚧 In Progress / Planned

### Currently Working On
- [ ] Course management system  
- [ ] Tutorial videos section  
- [ ] User profiles for students  
- [ ] Enhanced admin dashboard  

### Planned Features
- [ ] Email notifications for new posts  
- [ ] Advanced search functionality  
- [ ] Certificate generation system  
- [ ] Payment integration  
- [ ] Mobile app version (Flutter mobile)  

### Known Limitations
- Firebase Storage not implemented (requires paid plan)  
- Image uploads limited to Firebase Firestore only  
- No user registration (admin-only access currently)  
- Limited to 1GB free Firestore storage  

---

## 🛠️ Tech Stack

### Frontend Framework
- **Flutter Web** (3.0+) - Cross-platform UI framework  
- **Dart** - Programming language  

### State Management
- **Provider** (6.1+) - Simple and scalable state management  

### Backend & Database
- **Firebase Authentication** - Secure user authentication  
- **Cloud Firestore** - NoSQL cloud database  
- **Firebase Hosting** - Web hosting platform  

### Routing & Navigation
- **go_router** (14.0+) - Declarative routing for Flutter web  

### UI & Styling
- **Material Design 3** - Modern UI components  
- **Custom Gradients** - Branded color schemes  
- **Responsive Layouts** - Mobile-first design  

### Additional Packages
```yaml
dependencies:
  visibility_detector: ^0.2.2    # Scroll animations
  google_fonts: ^6.1.0           # Custom typography
  url_launcher: ^6.2.0           # External links
  intl: ^0.19.0                  # Date formatting
  uuid: ^4.3.3                   # Unique ID generation
  share_plus: ^7.2.1             # Social sharing
📁 Project Structure
bash
Copy code
lib/
├── main.dart                      # App entry point & routing
├── config/
│   └── firebase_config.dart       # Firebase settings & admin list
├── models/
│   ├── blog_post.dart             # Blog post data model
│   └── comment.dart               # Comment data model
├── screens/
│   ├── home_page.dart             # Landing page
│   ├── blog_page.dart             # Blog listing & details
│   ├── courses_page.dart          # Courses (placeholder)
│   ├── tutorials_page.dart        # Tutorials (placeholder)
│   ├── about_page.dart            # About section
│   └── contact_page.dart          # Contact form
├── services/
│   ├── firebase_service.dart      # Firebase CRUD operations
│   ├── admin_auth_service.dart    # Admin authentication
│   └── validators/
│       └── input_validator.dart   # Input sanitization
└── widgets/
    ├── navbar.dart                # Navigation bar
    └── footer.dart                # Page footer

web/
├── index.html                     # HTML entry point
└── firebase.json                  # Firebase hosting config
🔐 Security Implementation
Authentication Security
Admin-only access with email whitelist validation

Rate limiting to prevent brute-force attacks (5 attempts per 5 minutes)

Email verification required for admin accounts

Secure sign-out with proper session cleanup

Input Validation
dart
Copy code
// XSS Prevention
static String sanitizeInput(String input) {
  return input
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

// Email validation with regex
// Password strength requirements (8+ chars, uppercase, lowercase, number)
// Post content validation (length limits, dangerous pattern detection)
Firestore Security (Planned)
javascript
Copy code
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /posts/{postId} {
      allow read: if true;
      allow write: if request.auth != null && isAdmin(request.auth.uid);
    }
  }
}
Web Security Headers
json
Copy code
{
  "headers": [
    {"key": "X-Content-Type-Options", "value": "nosniff"},
    {"key": "X-Frame-Options", "value": "DENY"},
    {"key": "X-XSS-Protection", "value": "1; mode=block"},
    {"key": "Strict-Transport-Security", "value": "max-age=31536000"}
  ]
}
🚀 Setup & Installation
Prerequisites
Flutter SDK (3.0 or higher)

Dart SDK

Firebase account

VS Code or Android Studio

Local Development
Clone the repository

bash
Copy code
git clone https://github.com/phyowaikyaw-mobiledev/learners_gateway_website.git
cd learners_gateway_website
Install dependencies

bash
Copy code
flutter pub get
Firebase Setup

Create a Firebase project at https://console.firebase.google.com

Enable Authentication (Email/Password)

Create Firestore database

Download Firebase config

Update lib/config/firebase_config.dart with your admin emails

Update Firebase credentials in web/index.html

javascript
Copy code
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID"
};
Run on web

bash
Copy code
flutter run -d chrome
Build for production

bash
Copy code
flutter build web --release
Deploy to Firebase Hosting

bash
Copy code
firebase login
firebase init hosting
firebase deploy
📊 Database Schema
Firestore Collections
posts/ (Blog Posts)

javascript
Copy code
{
  id: "uuid-string",
  title: "Post Title",
  content: "Full post content...",
  author: "Admin Name",
  authorId: "firebase-uid",
  imageUrl: null,
  tags: ["Flutter", "Web Development"],
  likes: ["user-id-1", "user-id-2"],
  createdAt: Timestamp,
  updatedAt: Timestamp
}
posts/{postId}/comments/ (Comments)

javascript
Copy code
{
  id: "uuid-string",
  postId: "parent-post-id",
  authorName: "User Name",
  authorEmail: "user@email.com",
  content: "Comment text...",
  createdAt: Timestamp
}
(All other sections stay the same — About Learning, Challenges, Roadmap, Acknowledgments, etc., already format perfectly as written.)

<div align="center">
💙 Learning in Public | Building with Flutter
"This isn't just a portfolio project - it's my journey of learning Flutter web development while building something meaningful for my community."





Status: 🚧 In Active Development | Completion: ~65%

⭐️ If this project helps you learn, please give it a star! ⭐️

Built with Flutter 💙 | Powered by Firebase 🔥 | Learning Never Stops 📚

</div>
