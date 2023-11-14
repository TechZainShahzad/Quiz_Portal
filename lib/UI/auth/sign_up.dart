import 'package:chatapp/UI/auth/login_screen.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController =
      TextEditingController(); // Add full name controller
  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose(); // Dispose full name controller
    super.dispose();
  }

  void signUp() {
    // Rename the function to signUp
    setState(() {
      loading = true;
    });

    _auth
        .createUserWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
    )
        .then((authResult) {
      // After successful sign-up, update the user's profile with the full name
      authResult.user!.updateProfile(displayName: fullNameController.text);

      setState(() {
        loading = false;
      });
      utils().toastMessage("Successfully added account");
    }).catchError((error) {
      utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.password),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                          height: 20), // Add space for full name field
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          hintText: 'Full Name', // Add full name hint text
                          prefixIcon:
                              Icon(Icons.person), // Add icon for full name
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Full Name'; // Validate full name field
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUp(); // Call signUp function
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          )
                        : const Text("Sign Up"),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
