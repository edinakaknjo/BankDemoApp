import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseModule {
  @preResolve
  Future<FirebaseApp> initializeFirebaseApp() async {
    return await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAzv3b5Txc0jPkTTBXXq9FqUE5YNXt7p8c",
        appId: "1:4090609795:android:694b1a6f24d9720aec1bb6",
        messagingSenderId: "4090609795",
        projectId: "moneyapp-6d288",
      ),
    );
  }

  @singleton
  FirebaseAuth firebaseAuth(FirebaseApp app) => FirebaseAuth.instance;
}
