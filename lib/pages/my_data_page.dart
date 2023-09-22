import 'package:flutter/material.dart';
import 'package:login/components/permissions_dialog.dart';
import 'package:login/helperWidgets/my_button.dart';
import 'package:login/helperWidgets/my_textfield.dart';
import 'package:login/pages/permissions_edit_page.dart';
import 'package:login/services/login_api.dart';
import 'package:login/services/user_provider.dart';
import 'package:provider/provider.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  Object data = {};
  final branchIdController = TextEditingController();
  final roleController = TextEditingController();
  final emailController = TextEditingController();
  Map<String, dynamic> usersPermissions = {};

  void getUser(String email) async {
    if (email == '') {
      showErrorMesg('Please enter an email');
      return;
    }
    try {
      Map<String, dynamic> data = {
        'email': email,
      };
      usersPermissions = await getUserPermissions(data);
      print('usersPermissions $usersPermissions');
      if (usersPermissions['statusCode'] == 200) {
        emailController.clear();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PermissionsEditPage(userData: usersPermissions, getUserPermissions: getUserPermissions,);
          },
        );
      } else {
        String emailError = usersPermissions['email'];
        String errorMessage = emailError != '' ? '$emailError\n' : '';
        showErrorMesg(errorMessage);
      }
    } catch (e) {
      print('Failed to fetch data in getUser. Status code: $e');
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

  void addPermissionsData() {
    branchIdController.clear();
    roleController.clear();
    emailController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Search for a user')),
          content: const Text(''),
          actions: <Widget>[
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  obscureText: false,
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      getUser(emailController.text);
                    },
                    child: const Text('Search'))
              ],
            )),
          ],
        );
      },
    );
  }

  void getAllTheUsers() {
    setState(() {
      getAllUsers();
    });
  }

  @override
  void initState() {
    super.initState();
    // getAllTheUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Data Page'),
            Consumer<UserData>(
              builder: (context, userData, child) {
                if (userData.user != null) {
                  return Column(
                    children: [
                      Text('Welcome ${userData.user!['email']}'),
                      ElevatedButton(
                          onPressed: () {
                            addPermissionsData();
                            // Navigator.pushNamed(context, '/permissions');
                          },
                          child: const Text('add permissions'))
                    ],
                  );
                } else {
                  return const CircularProgressIndicator(); // or placeholder widget
                }
              },
            ),
            LogoutButton(
              onTap: () {
                logoutUser();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
