import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAzv3b5Txc0jPkTTBXXq9FqUE5YNXt7p8c",
      appId: "1:4090609795:android:694b1a6f24d9720aec1bb6",
      messagingSenderId: "4090609795",
      projectId: "moneyapp-6d288",
    ),
  );
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
}
