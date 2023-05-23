import 'package:flutter/material.dart';
import 'package:test_task/bloc/tasks_data_bloc.dart';
import 'package:test_task/widgets/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => TasksDataBloc(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
