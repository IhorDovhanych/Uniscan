import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:uniscan/application/data/models/user.dart';

abstract class UserService extends Disposable {
  Stream<UserModel?> get currentUserStream;
  Future<UserModel?> get currentUser;
  String? get currentUserId;
  Future<void> createUser(final UserModel user);
  Future<void> addQrCodeToUser(final String docID);
  // Future<void> getUsersQrCodes();
  Future<void> deleteQrCodeFromUser(final String docID);
}

class UserServiceImpl extends UserService {
  UserServiceImpl(
    this._users,
    this._firebaseAuth,
  ) {
    _subscribeToFirebaseUserChanges();
  }

  final CollectionReference<Map<String, dynamic>> _users;
  final FirebaseAuth _firebaseAuth;
  final _userStreamController = StreamController<UserModel?>.broadcast();
  late StreamSubscription<User?> _subscriptionStream;

  @override
  Stream<UserModel?> get currentUserStream async* {
    final user = await currentUser;
    yield user;
    yield* _userStreamController.stream;
  }

  void _subscribeToFirebaseUserChanges() {
    _subscriptionStream = _firebaseAuth.authStateChanges().listen((final firebaseUser) async {
      final user = await _getUserFromFirestore(firebaseUser?.uid);
      _userStreamController.add(user);
    });
  }

  @override
  Future<UserModel?> get currentUser => _getUserFromFirestore(_firebaseAuth.currentUser?.uid);

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  Future<UserModel?> _getUserFromFirestore(final String? id) async {
    final doc = await _users.doc(id).get();
    if (doc.exists) {
      final snapData = doc.data()!;
      return UserModel.fromJson(snapData);
    } else {
      return null;
    }
  }

  @override
  Future<void> createUser(final UserModel user) async {
    final doc = await _users.doc(user.id).get();
    if (!doc.exists) {
      await _users.doc(user.id).set(user.toJson());
      _userStreamController.add(user);
    } else {
      print('User already exists');
    }
  }

  @override
  Future<void> addQrCodeToUser(final String docID) async {
    final user = await currentUser;
    if (user == null) {
      return;
    }
    final doc = await _users.doc(user.id).get();
    if (doc.exists) {
      await doc.reference.update({
        'qrCodes': FieldValue.arrayUnion([docID]),
      });
      print('QR code added successfully');
    } else {
      print('User document not found');
    }
  }

  // @override
  // Future<List<String>> getUsersQrCodes() async {
  //   return [];
  // UserEntity? u = await _userStream.first;
  // if (u != null) {
  //   var querySnapshot = await _users.where('id', isEqualTo: u.id).get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     var documentSnapshot = querySnapshot.docs.first;
  //     List<String> qrCodes = List<String>.from(documentSnapshot['qrCodes']);
  //     return qrCodes;
  //   } else {
  //     print('User document not found');
  //     return [];
  //   }
  // } else {
  //   print('Empty user data');
  //   return [];
  // }
// }

  @override
  Future<void> deleteQrCodeFromUser(final String docID) async {
    final user = await currentUser;
    if (user != null) {
      final querySnapshot = await _users.where('id', isEqualTo: user.id).get();
      if (querySnapshot.docs.isNotEmpty) {
        final documentSnapshot = querySnapshot.docs.first;
        final List<String> qrCodes = List<String>.from(documentSnapshot['qrCodes']);
        qrCodes.remove(docID);
        await documentSnapshot.reference.update({
          'qrCodes': qrCodes,
        });
        print('QR code deleted successfully');
      } else {
        print('User document not found');
      }
    } else {
      print('Empty user data');
    }
  }

  @override
  FutureOr onDispose() {
    _subscriptionStream.cancel();
    _userStreamController.close();
  }
}
