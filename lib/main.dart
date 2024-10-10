import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp/common/blocs/transactions_bloc.dart';
import 'package:moneyapp/router/go_router.dart'; 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: const FirebaseOptions(
        apiKey: "AIzaSyAzv3b5Txc0jPkTTBXXq9FqUE5YNXt7p8c",
        appId: "1:4090609795:android:694b1a6f24d9720aec1bb6",
        messagingSenderId: "4090609795",
        projectId: "moneyapp-6d288"),
   );
  runApp(
    BlocProvider(
      create: (context) => TransactionsBloc(),
      child: const MoneyApp(),
    ),
  );
}

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MoneyApp',
      routerConfig: AppRouter.router, 
    );
  }
}
