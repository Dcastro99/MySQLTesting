import 'package:flutter/material.dart';
import 'package:login/helperWidgets/my_textfield.dart';
import 'package:login/services/login_api.dart';
import 'package:velocity_x/velocity_x.dart';
import '../components/errorHandlers /signup_errors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final empNumController = TextEditingController();
  final nameController = TextEditingController();
  final branchIdController = TextEditingController();
  String? emailError;
  String? passwordError;
  String? empNumError;
  String? branchIdError;

  String? validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  void signUp() async {
    String? newemailError = validateField(emailController.text, 'email');
    String? newpasswordError =
        validateField(passwordController.text, 'password');
    String? newempNumError =
        validateField(empNumController.text, 'employee number');
    String? newbranchIdError =
        validateField(branchIdController.text, 'branch ID');

    if (newemailError == null &&
        newpasswordError == null &&
        newempNumError == null &&
        newbranchIdError == null) {
      showDialog(
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      try {
        Map<String, dynamic> user = await createUser(
            emailController.text,
            passwordController.text,
            int.parse(empNumController.text),
            int.parse(branchIdController.text));

        if (user['statusCode'] == 201) {
          Navigator.pop(context);

          emailController.clear();
          passwordController.clear();
          empNumController.clear();
          branchIdController.clear();

          Navigator.pushReplacementNamed(context, '/');
        } else if (user['statusCode'] == 400 || user['statusCode'] == 500) {
          singupErrors(user, context);
        }
      } catch (e) {
        print('error $e');
        showErrorMesg('Something went wrong');
      }
    } else if (newemailError != '' ||
        newpasswordError != '' ||
        newempNumError != '' ||
        newbranchIdError != '') {
      setState(() {
        emailError = newemailError;
        passwordError = newpasswordError;
        empNumError = newempNumError;
        branchIdError = newbranchIdError;
      });
      return;
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
    return Scaffold(
      backgroundColor: Vx.hexToColor("#faf7f2"),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              width: 500,
              height: 725,
              child: Card(
                color: Vx.hexToColor("#ebe5dd"),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    const SizedBox(
                      height: 100,
                      width: 300,
                      child: Card(
                          elevation: 12,
                          child: Center(
                            child: Text('Create a User',
                                style: TextStyle(
                                    fontFamily: 'DancingScript',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 70, 70, 70)),
                                textAlign: TextAlign.center),
                          )),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 230,
                          child: Column(
                            children: [
                              MyTextfeild(
                                controller: emailController,
                                hintText: 'email',
                                obscuerText: false,
                                errorText: emailError,
                              ),
                              const SizedBox(height: 25),
                              MyTextfeild(
                                controller: passwordController,
                                hintText: 'Password',
                                obscuerText: true,
                                errorText: passwordError,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 230,
                          child: Column(
                            children: [
                              MyTextfeild(
                                controller: empNumController,
                                hintText: 'Employee Number',
                                obscuerText: false,
                                errorText: empNumError,
                              ),
                              const SizedBox(height: 15),
                              MyTextfeild(
                                controller: branchIdController,
                                hintText: 'Branch',
                                obscuerText: false,
                                errorText: branchIdError,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: signUp,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Create User',
                          style: TextStyle(
                              color: Colors.white,
                              // fontFamily: 'NotoSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: Builder(builder: (context) {
      //   return SizedBox(
      //     width: 200,
      //     // margin: const EdgeInsets.fromLTRB(190, 0, 0, 0),
      //     child: FloatingActionButton(
      //       backgroundColor: const Color.fromARGB(69, 82, 81, 81),
      //       onPressed: () {
      //         Navigator.pushNamed(context, '/live');
      //       },
      //       child: const Text(
      //         'LIVE',
      //         style: TextStyle(fontWeight: FontWeight.bold),
      //       ),
      //     ),
      //   );
      // }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
