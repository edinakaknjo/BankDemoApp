import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneyapp/common/firebase/firebase_module.dart';
import 'package:moneyapp/common/cubit/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final FirebaseAuth auth = getIt<FirebaseAuth>();
  SignupCubit() : super(SignupInitial());

  Future<void> signup(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Registration failed');
    }
  }
}
