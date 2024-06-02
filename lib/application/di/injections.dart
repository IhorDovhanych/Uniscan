import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uniscan/application/data/repository/auth_repository_impl.dart';
import 'package:uniscan/application/data/repository/geo_position_repository_impl.dart';
import 'package:uniscan/application/data/repository/qr_code_repository.impl.dart';
import 'package:uniscan/application/data/services/auth_service.dart';
import 'package:uniscan/application/data/services/camera_service.dart';
import 'package:uniscan/application/data/services/geo_position_service.dart';
import 'package:uniscan/application/data/services/qr_code_service.dart';
import 'package:uniscan/application/data/services/user_service.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';
import 'package:uniscan/application/domain/repository/geo_position_repository.dart';
import 'package:uniscan/application/domain/repository/qr_code_repository.dart';
import 'package:uniscan/application/domain/usecase/get_qr_codes_stream_use_case.dart';
import 'package:uniscan/application/domain/usecase/get_user_stream_use_case.dart';
import 'package:uniscan/application/domain/usecase/log_in_with_google_use_case.dart';
import 'package:uniscan/application/domain/usecase/log_out_use_case.dart';
import 'package:uniscan/application/presentation/cubit/auth_cubit.dart';
import 'package:uniscan/application/presentation/features/login/cubit/login_cubit.dart';
import 'package:uniscan/application/presentation/features/main/cubit/main_cubit.dart';
import 'package:uniscan/application/presentation/features/main/features/home/cubit/home_cubit.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/cubit/qr_code_cubit.dart';
import 'package:uniscan/core/firebase/firebase_keys.dart';
import 'package:uniscan/firebase_options.dart';

final getIt = GetIt.instance;

const appScope = 'appScope';

void _initAppScope(final GetIt getIt) {
  //region services
  getIt.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(
        clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
      ));
  //endregion

  // region Services
  getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl(
        getIt<FirebaseAuth>(),
        getIt<GoogleSignIn>(),
        getIt<UserService>(),
      ));
  getIt.registerLazySingleton<UserService>(() => UserServiceImpl(
        getIt<FirebaseFirestore>().collection(FirestoreKeys.collection_name_users),
        getIt<FirebaseAuth>(),
      ));
  getIt.registerLazySingleton<QrCodeService>(() => QrCodeServiceImpl(
        getIt<UserService>(),
        getIt<GeoPositionService>(),
        getIt<FirebaseFirestore>().collection(FirestoreKeys.collection_qr_codes),
      ));
  getIt.registerLazySingleton<GeoPositionService>(() => GeoPositionServiceImpl());
  getIt.registerLazySingleton<CameraService>(() => CameraServiceImpl());
  //endregion

  //region Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        getIt<AuthService>(),
        getIt<UserService>(),
      ));
  getIt.registerLazySingleton<QrCodeRepository>(() => QrCodeRepositoryImpl(getIt<QrCodeService>()));
  getIt.registerLazySingleton<GeoPositionRepository>(() => GeoPositionRepositoryImpl(getIt<GeoPositionService>()));
  //endregion

  //region Use cases
  getIt.registerFactory<GetUserStreamUseCase>(() => GetUserStreamUseCase(getIt<AuthRepository>()));
  getIt.registerFactory<GetQrCodesStreamUseCase>(() => GetQrCodesStreamUseCase(getIt<QrCodeRepository>()));
  getIt.registerFactory<LogInWithGoogleUseCase>(() => LogInWithGoogleUseCase(getIt<AuthRepository>()));
  getIt.registerFactory<LogOutUseCase>(() => LogOutUseCase(getIt<AuthRepository>()));
  //endregion

  //region Cubits
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(
        getIt<GetUserStreamUseCase>(),
        getIt<LogOutUseCase>(),
      ));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LogInWithGoogleUseCase>()));
  getIt.registerFactory<MainCubit>(() => MainCubit());
  getIt.registerFactory<HomeCubit>(() => HomeCubit(
        getIt<GetQrCodesStreamUseCase>(),
        getIt<QrCodeRepository>(),
        getIt<GeoPositionRepository>(),
      ));
  getIt.registerFactory<QrCodeCubit>(() => QrCodeCubit(getIt<QrCodeRepository>()));
  //endregion
}

final Map<String, ScopeBuilder> _registeredScopes = {
  appScope: _initAppScope,
};

void pushScope(final String scope) {
  if (getIt.currentScopeName == scope) return;
  if (!_registeredScopes.containsKey(scope)) return;
  getIt.pushNewScope(scopeName: scope, init: _registeredScopes[scope]);
}

Future<void> pushScopeAsync(final String scope) async {
  if (getIt.currentScopeName == scope) return;
  if (!_registeredScopes.containsKey(scope)) return;
  getIt.pushNewScope(scopeName: scope, init: _registeredScopes[scope]);
  return getIt.allReady();
}

Future<bool> popScope([final String? scope]) async {
  if (getIt.currentScopeName == appScope) return false;
  if (scope != null) return getIt.popScopesTill(scope);
  await getIt.popScope();
  return true;
}

typedef ScopeBuilder = void Function(GetIt getIt);
