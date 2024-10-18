import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'signup_state.dart';

@injectable
class SignupCubit extends Cubit<SignupState> {
  final FirebaseAuth _auth;

  SignupCubit(this._auth) : super(SignupInitial());

  Future<void> signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupError(e.toString()));
      throw Exception('Signup failed');
    }
  }
}
