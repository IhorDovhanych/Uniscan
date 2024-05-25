import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:uniscan/application/data/models/user.dart';

abstract class UserService extends Disposable {
  Stream<UserModel?> get currentUserStream;
  Future<UserModel?> get currentUser;
  Future<void> createUser(final UserModel user);
  Future<void> addQrCodeToUser(String docID);
  Future<void> getUsersQrCodes();
  Future<void> deleteQrCodeFromUser(String docID);
}

class UserServiceImpl extends UserService {
  UserServiceImpl(
    this._users,
    this._firebaseAuth,
  ) {
    _subscribeToFirebaseUserChanges();
  }

  final CollectionReference _users;
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

  Future<UserModel?> _getUserFromFirestore(final String? id) async {
    final doc = await _users.doc(id).get();
    if (doc.exists) {
      final snapData = doc.data() as Map<String, dynamic>;
      return UserModel.fromJson(snapData);
    } else {
      return null;
    }
  }

  Future<void> createUser(final UserModel user) async {
    final doc = await _users.doc(user.id).get();
    if (!doc.exists) {
      await _users.doc(user.id).set(user.toJson());
    } else {
      print('User already exists');
    }
  }

  Future<void> addQrCodeToUser(String docID) async {
    // final querySnapshot = await _users.where('id', isEqualTo: user.id).get();
    // if (querySnapshot.docs.isNotEmpty) {
    //   var documentSnapshot = querySnapshot.docs.first;
    //   await documentSnapshot.reference.update({
    //     'qrCodes': FieldValue.arrayUnion([docID]),
    //   });
    //   print('QR code added successfully');
    // } else {
    //   print('User document not found');
    // }
  }

  Future<List<String>> getUsersQrCodes() async {
    return [];
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
  }

  Future<void> deleteQrCodeFromUser(String docID) async {
    // UserEntity? u = await _userStream.first;
    // if (u != null) {
    //   var querySnapshot = await _users.where('id', isEqualTo: u.id).get();
    //   if (querySnapshot.docs.isNotEmpty) {
    //     var documentSnapshot = querySnapshot.docs.first;
    //     List<String> qrCodes = List<String>.from(documentSnapshot['qrCodes']);
    //     qrCodes.remove(docID); // Remove the specified docID from qrCodes array
    //     await documentSnapshot.reference.update({
    //       'qrCodes': qrCodes,
    //     });
    //     print('QR code deleted successfully');
    //   } else {
    //     print('User document not found');
    //   }
    // } else {
    //   print('Empty user data');
    // }
  }

  @override
  FutureOr onDispose() {
    _subscriptionStream.cancel();
    _userStreamController.close();
  }
}
