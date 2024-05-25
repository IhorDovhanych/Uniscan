import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uniscan/application/data/mapper/user_mapper.dart';
import 'package:uniscan/application/data/services/user_service.dart';

abstract class AuthService {
  Stream<User?> get firebaseUserStream;
  User? get firebaseUser;
  Future<void> logInWithGoogle();
  Future<void> logOut();
}

class AuthServiceImpl extends AuthService {
  AuthServiceImpl(
    this._firebaseAuth,
    this._googleSignIn,
    this._userService,
  );

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserService _userService;

  @override
  Stream<User?> get firebaseUserStream => _firebaseAuth.authStateChanges().map((final firebaseUser) => firebaseUser);

  @override
  User? get firebaseUser => _firebaseAuth.currentUser;

  @override
  Future<void> logInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return Future.error('CANCELLED_SIGN_IN');
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    if (_firebaseAuth.currentUser != null) {
      _userService.createUser(_firebaseAuth.currentUser!.toModel());
    }
  }

  @override
  Future<void> logOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
