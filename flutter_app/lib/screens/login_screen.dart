// //lib/screens/login_screen.dart
// import 'package:flutter/material.dart';
// import'../services/auth_services.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
// s
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade900, Colors.blue.shade500],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Welcome Back!',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 NeumorphicInputField(
//                   hintText: 'Email',
//                   prefixIcon: Icons.email,
//                 ),
//                 const SizedBox(height: 16),
//                 NeumorphicInputField(
//                   hintText: 'Password',
//                   prefixIcon: Icons.lock,
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 24),
//                 GradientButton(
//                   text: 'Login',
//                   onPressed: () {
//                     Navigator.pushReplacementNamed(context, '/home');
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/signup');
//                   },
//                   child: Text(
//                     'Don\'t have an account? Sign up',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NeumorphicInputField extends StatelessWidget {
//   final String hintText;
//   final IconData prefixIcon;
//   final bool obscureText;

//   const NeumorphicInputField({
//     required this.hintText,
//     required this.prefixIcon,
//     this.obscureText = false,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.blue.shade800,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(5, 5),
//           ),
//           BoxShadow(
//             color: Colors.white.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(-5, -5),
//           ),
//         ],
//       ),
//       child: TextField(
//         obscureText: obscureText,
//         style: TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.white54),
//           prefixIcon: Icon(prefixIcon, color: Colors.white54),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.all(16),
//         ),
//       ),
//     );
//   }
// }

// class GradientButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;

//   const GradientButton({
//     required this.text,
//     required this.onPressed,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade700, Colors.blue.shade400],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 18, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
