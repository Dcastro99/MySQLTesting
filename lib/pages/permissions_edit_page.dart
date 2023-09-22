import 'package:flutter/material.dart';
import 'package:login/services/login_api.dart';

class PermissionsEditPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function getUserPermissions;
  const PermissionsEditPage(
      {super.key, required this.userData, required this.getUserPermissions});

  @override
  State<PermissionsEditPage> createState() => _PermissionsEditPageState();
}

class _PermissionsEditPageState extends State<PermissionsEditPage> {
  final Map<String, dynamic> userData = {};
  dynamic newUserData = {};
  final branchIdController = TextEditingController();
  final roleController = TextEditingController();

  Future<void> sendNewPermissions(Map<String, dynamic> userData) async {
    print('userData in sending $userData');
    await addPermissions(userData);
  }

  void removeBranchId(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Remove Branch ID'),
            content: TextField(
              controller: branchIdController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Branch ID',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  var branchIdInput = int.parse(branchIdController.text);
                  var branchIds = userData['branch_ids'];
                  var branchIdFound = branchIds.contains(branchIdInput);
                  if (!branchIdFound) {
                    showErrorMesg('Branch ID does not match');
                    return;
                  }

                  Navigator.of(context).pop();
                  userData['branch_ids'] = int.parse(branchIdController.text);
                  print('userData in removeBranchId $userData');
                  await removebranchId(userData);
                  branchIdController.clear();
                  var newUserData = await widget.getUserPermissions(userData);
                  setState(() {
                    userData.addAll(newUserData);
                  });
                },
                child: const Text('Remove'),
              ),
            ],
          );
        });
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

  void addBranchId(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print('userData in addBranchId $userData');
        return AlertDialog(
          title: const Text('Add Branch ID'),
          content: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Branch ID',
            ),
            onChanged: (value) {
              userData['branch_ids'] = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                await sendNewPermissions(userData);
                var newUserData = await widget.getUserPermissions(userData);
                setState(() {
                  userData.addAll(newUserData);
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    userData.addAll(widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                color: Colors.grey[200],
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Text('User Permissions'),
                ),
              ),
              SizedBox(
                height: 410,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text('User:'),
                            const SizedBox(width: 10),
                            Text(
                              userData['email'] ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const Divider(height: 20, thickness: 1),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Current Role:'),
                                  const SizedBox(width: 10),
                                  Text(
                                    userData['role'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // width: 50,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: TextField(
                                    controller: roleController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'change role'),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => const Color.fromARGB(
                                                255, 18, 123, 129)),
                                  ),
                                  onPressed: () async {
                                    var roleInput =
                                        int.parse(roleController.text);
                                    if (roleInput < 1 || roleInput > 3) {
                                      showErrorMesg(
                                          'Role must be between 1 and 3');
                                      return;
                                    }

                                    userData['role'] =
                                        int.parse(roleController.text);
                                    await sendNewPermissions(userData);
                                    var newUserData = await widget
                                        .getUserPermissions(userData);
                                    setState(() {
                                      userData.addAll(newUserData);
                                    });
                                  },
                                  child: const Text('Add Role')),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Current Branch ID\'s:'),
                                const SizedBox(width: 10),
                                Text(
                                  userData['branch_ids'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => const Color.fromARGB(
                                                  255, 18, 123, 129)),
                                    ),
                                    onPressed: () {
                                      addBranchId(context);
                                    },
                                    child: const Icon(Icons.add)),
                                const SizedBox(width: 25),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => const Color.fromARGB(
                                                  255, 18, 123, 129)),
                                    ),
                                    onPressed: () {
                                      removeBranchId(context);
                                    },
                                    child: const Icon(Icons.edit)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_ios_new_sharp, color: Colors.red),
                        Text(
                          'Back',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
