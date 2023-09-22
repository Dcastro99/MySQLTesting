import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/helperWidgets/login_textfield.dart';
import 'package:login/services/login_api.dart';
import 'package:login/services/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      Map<String, dynamic> user = await loginUser(
          context, emailController.text, passwordController.text);

      if (user['statusCode'] == 200) {
        Navigator.pop(context);

        Navigator.pushReplacementNamed(context, '/data');
      } else if (user['statusCode'] == 400) {
        print('user? $user');
        Navigator.pop(context);
        String emailError = user['email'];
print('emailError $emailError');
        String passwordError = user['password'];
        String errorMessage = emailError != '' && passwordError != ''
            ? 'Email: $emailError\nPassword: $passwordError'
            : emailError != ''
                ? '$emailError\n'
                : passwordError != ''
                    ? '$passwordError'
                    : '';
        print('errorMessage $errorMessage');
        showErrorMesg(errorMessage);
      }
    } catch (e) {
      print('error $e');
      Navigator.pop(context);
      showErrorMesg('Something went wrong');
    }
  }

  void showErrorMesg(String mesg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 245, 95, 95),
              title: Center(
                  child: Text(
                mesg,
                style: const TextStyle(color: Colors.white),
              )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.black,
                ),
                const Text(
                  'My Login Page',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'DancingScript',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 25),
                LoginTextfeild(
                    hintText: 'Email',
                    controller: emailController,
                    obscureText: false),
                const SizedBox(height: 15),
                LoginTextfeild(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Text('Forgot Password');
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 40, 164, 247)),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 73, 112, 130)),
                      ),
                      onPressed: () {
                        signUserIn();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Login',
                          style: TextStyle(),
                        ),
                      )),
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey[300],
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ));
  }
}
