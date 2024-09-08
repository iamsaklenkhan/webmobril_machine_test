import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmobril_test/src/Authentication/authentication_service.dart';
import 'package:webmobril_test/src/screen/Register/register_provider.dart';
import 'package:webmobril_test/src/utils/app_text_filed.dart';
import 'package:webmobril_test/src/utils/maxin/validesion.dart';

class RegisterScreen extends StatelessWidget with InputValidationMixin {
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AuthenticationService>(context, listen: false);
    return Consumer<RegisterProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: value.formKey1,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                AppTextFormField(
                  validator: validateEmail,
                  controller: value.emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 40,
                ),
                AppTextFormField(
                  labelText: 'Password',
                  validator: validatePassword,
                  controller: value.passwordController,

                  // obscureText: true,
                ),
                const SizedBox(height: 40),
                Consumer<AuthenticationService>(
                  builder: (context, provider, child) => provider.isLoding
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (value.formKey1.currentState!.validate()) {
                              await provider.registerWithEmailPassword(context,
                                  email: value.emailController.text.trim(),
                                  password:
                                      value.passwordController!.text.trim());
                            }
                          },
                          child: const Text('Register'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
