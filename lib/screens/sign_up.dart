// screens/signup_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yawn_on/screens/sign_in.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _fullNameController.text.length >= 3 &&
          _isValidEmail(_emailController.text) &&
          _passwordController.text.length >= 6 &&
          _passwordController.text == _confirmPasswordController.text &&
          _acceptTerms;
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Firebase sign up implementation
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fill all fields correctly');
      return;
    }

    if (!_acceptTerms) {
      _showSnackBar('Please accept the Terms and Conditions');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Update user profile with display name
      await userCredential.user?.updateDisplayName(_fullNameController.text.trim());

      // Store additional user data in Firestore
      await _createUserDocument(userCredential.user!);

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      _showSnackBar(
        'Account created successfully! Please check your email for verification.',
        isError: false,
      );

      // Navigate to welcome screen immediately after account creation
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/welcome',
        (route) => false,
      );

    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseErrorMessage(e.code);
      _showSnackBar(errorMessage);
    } catch (e) {
      _showSnackBar('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'fullName': _fullNameController.text.trim(),
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': false,
        'profileCompleted': false,
        'isNewUser': true,
        // Add sleep tracking related fields
        'sleepGoal': 8, // Default 8 hours
        'bedtimeReminder': true,
        'wakeupReminder': true,
      });
    } catch (e) {
      print('Error creating user document: $e');
      // Note: We don't throw here to avoid disrupting the sign-up flow
      // The user account is still created successfully
    }
  }

  // Convert Firebase error codes to user-friendly messages
  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'The password provided is too weak. Please use a stronger password.';
      case 'email-already-in-use':
        return 'An account already exists for this email address.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An error occurred during sign up. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                
                // App Logo and Branding
                _buildHeader(),
                SizedBox(height: 40),
                
                // Sign Up Form
                _buildSignUpForm(),
                SizedBox(height: 24),
                
                // Terms and Conditions
                _buildTermsCheckbox(),
                SizedBox(height: 32),
                
                // Sign Up Button
                _buildSignUpButton(),
                SizedBox(height: 24),
                
                // Sign In Link
                _buildSignInLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0xFF1E3A8A),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF1E3A8A).withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.bedtime,
            color: Colors.white,
            size: 40,
          ),
        ),
        SizedBox(height: 16),
        
        Text(
          'Yawn&On',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
          ),
        ),
        SizedBox(height: 8),
        
        Text(
          'Create your account to start tracking your sleep',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        // Full Name Field
        CustomTextField(
          controller: _fullNameController,
          hintText: 'Full Name',
          prefixIcon: Icons.person_outline,
          enabled: !_isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            if (value.length < 3) {
              return 'Name must be at least 3 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        
        // Email Field
        CustomTextField(
          controller: _emailController,
          hintText: 'Email Address',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          enabled: !_isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!_isValidEmail(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        
        // Password Field
        CustomTextField(
          controller: _passwordController,
          hintText: 'Password',
          prefixIcon: Icons.lock_outline,
          obscureText: !_isPasswordVisible,
          enabled: !_isLoading,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: _isLoading ? null : () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            // Add password strength validation
            if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
              return 'Password must contain at least one letter and one number';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        
        // Confirm Password Field
        CustomTextField(
          controller: _confirmPasswordController,
          hintText: 'Confirm Password',
          prefixIcon: Icons.lock_outline,
          obscureText: !_isConfirmPasswordVisible,
          enabled: !_isLoading,
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: _isLoading ? null : () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: _isLoading ? null : (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
            _validateForm();
          },
          activeColor: Color(0xFF1E3A8A),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _isLoading ? null : () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
              _validateForm();
            },
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                children: [
                  TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return CustomButton(
      text: _isLoading ? 'Creating Account...' : 'Create Account',
      onPressed: (_isFormValid && !_isLoading) ? _handleSignUp : null,
      isEnabled: _isFormValid && !_isLoading,
      child: _isLoading 
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Creating Account...'),
            ],
          )
        : null,
    );
  }

  Widget _buildSignInLink() {
    return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Already have an account? ',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      GestureDetector(
        onTap: _isLoading ? null : () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        },
        child: Text(
          'Sign In',
          style: TextStyle(
            fontSize: 14,
            color: _isLoading ? Colors.grey[400] : Color(0xFF1E3A8A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}
}