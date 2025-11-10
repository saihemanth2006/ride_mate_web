import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ride_mate/signup_page.dart';
import 'package:ride_mate/forgot_password.dart';
import 'package:ride_mate/widgets/custom_test_feild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_mate/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool _isloading = false;

  final List<IconData> iconList = [
    FontAwesomeIcons.google,
    FontAwesomeIcons.facebook,
    FontAwesomeIcons.microsoft,
  ];
  Future<Map<String, String>> getUserDetails(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();

      if (doc.exists) {
        return {
          'userName': doc['name'] ?? '',
          'userEmail': doc['email'] ?? '',
          'userPhone': doc['phone'] ?? '',
        };
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
    return {'userName': 'User', 'userEmail': '', 'userPhone': ''};
  }

  
  Future<void> login() async {
    setState(() => _isloading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
        
          final details = await getUserDetails(user.uid);

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHome(
                  userName: details['userName']!,
                  userEmail: details['userEmail']!,
                  userPhone: details['userPhone']!,
                ),
              ),
            );
          }

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Login successful')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please verify your email first'),
              backgroundColor: Colors.orange));
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? e.code), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isloading = false);
    }
  }

 
  Future<void> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      final credential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
      final user = credential.user;

      if (user != null) {
        
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? "Google User",
          'email': user.email ?? "",
          'phone': user.phoneNumber ?? "No Phone",
        }, SetOptions(merge: true));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHome(
                userName: user.displayName ?? "Google User",
                userEmail: user.email ?? "No Email",
                userPhone: user.phoneNumber ?? "No Phone",
              ),
            ),
          );
        }
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final fbProvider = FacebookAuthProvider();
      final credential =
          await FirebaseAuth.instance.signInWithPopup(fbProvider);
      final user = credential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? "Facebook User",
          'email': user.email ?? "",
          'phone': user.phoneNumber ?? "No Phone",
        }, SetOptions(merge: true));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHome(
              userName: user.displayName ?? "Facebook User",
              userEmail: user.email ?? "No Email",
              userPhone: user.phoneNumber ?? "No Phone",
            ),
          ),
        );
      }
    } catch (e) {
      print("Facebook Sign-In Error: $e");
    }
  }

  Future<void> signInWithMicrosoft() async {
    try {
      final msProvider = MicrosoftAuthProvider();
      final credential =
          await FirebaseAuth.instance.signInWithPopup(msProvider);
      final user = credential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? "Microsoft User",
          'email': user.email ?? "",
          'phone': user.phoneNumber ?? "No Phone",
        }, SetOptions(merge: true));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHome(
              userName: user.displayName ?? "Microsoft User",
              userEmail: user.email ?? "No Email",
              userPhone: user.phoneNumber ?? "No Phone",
            ),
          ),
        );
      }
    } catch (e) {
      print("Microsoft Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Welcome Back',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  // Logo or App Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.orange,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  const Text(
                    'Sign In to Your Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your credentials to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.orange,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomTextFeild(
                      label: 'Email',
                      pIcon: const Icon(Icons.mail, color: Colors.orange),
                      controller: _email,
                      validate: (v) =>
                          v == null || v.isEmpty ? 'Enter email' : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.orange,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomTextFeild(
                      label: 'Password',
                      pIcon: const Icon(Icons.lock, color: Colors.orange),
                      controller: _pass,
                      isPassword: true,
                      validate: (v) =>
                          v == null || v.isEmpty ? 'Enter password' : null,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ForgotPassword())),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        )),
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) login();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: _isloading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 30),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _social(iconList[0], signInWithGoogle),
                      _social(iconList[1], signInWithFacebook),
                      _social(iconList[2], signInWithMicrosoft),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Sign Up Link
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignupPage())),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _social(IconData icon, VoidCallback onTap) => Container(
        height: 60,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Colors.orange,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: Colors.orange,
            size: 24,
          ),
        ),
      );
}
