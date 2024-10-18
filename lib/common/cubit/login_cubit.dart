import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth;

  LoginCubit(this._auth) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
      throw Exception('Login failed');
    }
  }
}
