// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_core/firebase_core.dart' as _i982;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:moneyapp/common/cubit/login_cubit.dart' as _i814;
import 'package:moneyapp/common/cubit/signup_cubit.dart' as _i534;
import 'package:moneyapp/common/cubit/transactions_cubit.dart' as _i392;
import 'package:moneyapp/common/firebase/firebase_module.dart' as _i567;
import 'package:moneyapp/features/transactions/source/transaction_source.dart'
    as _i448;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    await gh.factoryAsync<_i982.FirebaseApp>(
      () => firebaseModule.initializeFirebaseApp(),
      preResolve: true,
    );
    gh.lazySingleton<_i448.ApiDataSource>(() => _i448.ApiDataSource());
    gh.factory<_i392.TransactionsCubit>(
        () => _i392.TransactionsCubit(gh<_i448.ApiDataSource>()));
    gh.singleton<_i59.FirebaseAuth>(
        () => firebaseModule.firebaseAuth(gh<_i982.FirebaseApp>()));
    gh.factory<_i814.LoginCubit>(
        () => _i814.LoginCubit(gh<_i59.FirebaseAuth>()));
    gh.factory<_i534.SignupCubit>(
        () => _i534.SignupCubit(gh<_i59.FirebaseAuth>()));
    return this;
  }
}

class _$FirebaseModule extends _i567.FirebaseModule {}
