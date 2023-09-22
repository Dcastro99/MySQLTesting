import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body:  Center(
        child: Column(
          children: [
            const Text('Home Page', style: TextStyle(fontSize: 30),),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/login');
          
            },
             child: const Text('login')),
              ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/register');
          
            },
             child: const Text('register')),
          ],
        ),
      ),
      
    );
  }
}