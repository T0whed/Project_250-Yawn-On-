// main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yawn_on/firebase_options.dart';
import 'package:yawn_on/screens/settings_page.dart';
import 'package:yawn_on/screens/sign_up.dart';
import 'package:yawn_on/screens/welcome_screen.dart';
import 'screens/home_page.dart';
import 'screens/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(YawnOnApp());
}

class YawnOnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yawn&On',
      theme: ThemeData(
        primaryColor: Color(0xFF1E3A8A), // Dark blue
        scaffoldBackgroundColor: Color(0xFFFAFAFA), // Soft white
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      routes: {
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/welcome': (context) => WelcomeScreen(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading screen while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        
        // If user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userDoc) {
              if (userDoc.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              
              // Check if user is new
              if (userDoc.hasData && userDoc.data!.exists) {
                Map<String, dynamic> userData = userDoc.data!.data() as Map<String, dynamic>;
                bool isNewUser = userData['isNewUser'] ?? false;
                
                if (isNewUser) {
                  return WelcomeScreen();
                }
              }
              
              return HomePage();
            },
          );
        }
        
        // If user is not logged in, show sign in page
        return SignInPage();
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A8A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.bedtime,
                color: Color(0xFF1E3A8A),
                size: 60,
              ),
            ),
            SizedBox(height: 24),
            
            // App Name
            Text(
              'Yawn&On',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            
            Text(
              'Track your sleep journey',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(255, 255, 255, 0.8),
              ),
            ),
            SizedBox(height: 40),
            
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}