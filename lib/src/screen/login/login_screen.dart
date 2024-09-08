import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmobril_test/src/Authentication/authentication_service.dart';
import 'package:webmobril_test/src/screen/login/login_provider.dart';
import 'package:webmobril_test/src/utils/app_text_filed.dart';
import 'package:webmobril_test/src/utils/maxin/validesion.dart';

class LoginScreen extends StatelessWidget with InputValidationMixin {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final authService =
    // Provider.of<AuthenticationService>(context, listen: false);
    return Consumer<LoginProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: value.formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildEmailField(value),
                const SizedBox(height: 40),
                _buildPasswordField(value),
                const SizedBox(height: 20),
                Consumer<AuthenticationService>(
                    builder: (context, value1, child) => value1.isLoding
                        ? CircularProgressIndicator()
                        : _buildLoginButton(context, value, value1)),
                const SizedBox(height: 20),
                _buildRegisterLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(LoginProvider value) {
    return AppTextFormField(
      controller: value.emailController,
      labelText: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
    );
  }

  Widget _buildPasswordField(LoginProvider value) {
    return AppTextFormField(
      controller: value.passwordController,
      labelText: 'Password',
      validator: validatePassword,
      obscureText: true,
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginProvider value,
      AuthenticationService authService) {
    return ElevatedButton(
      onPressed: () {
        if (value.formKey.currentState?.validate() ?? false) {
          // value.getlogin(context);

          authService.signInWithEmailPassword(
            context,
            email: value.emailController.text.trim(),
            password: value.passwordController.text.trim(),
          );
        }
      },
      child: const Text('Login'),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: const Text('Create an Account'),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:webmobril_test/src/Authentication/authentication_service.dart';
// import 'package:webmobril_test/src/utils/app_text_filed.dart';
//
// import '../../utils/maxin/validesion.dart';
//
// class LoginScreen extends StatelessWidget with InputValidationMixin {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   LoginScreen({super.key});
//   final _formKey1 = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     final provide = Provider.of<AuthenticationService>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Form(
//           key: _formKey1,
//           // autovalidateMode: ,
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               AppTextFormField(
//                 controller: emailController,
//                 labelText: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//                 validator: validateEmail,
//               ),
//               const SizedBox(height: 40),
//               AppTextFormField(
//                 controller: passwordController, labelText: 'Password',
//                 validator: validatePassword,
//
//                 // obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   provide.signInWithEmailPassword(
//                     context,
//                     email: emailController.text.trim(),
//                     password: passwordController.text.trim(),
//                   );
//                 },
//                 child: const Text('Login'),
//               ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/register');
//                 },
//                 child: const Text('Create an Account'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
