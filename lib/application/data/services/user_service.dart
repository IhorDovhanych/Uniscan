import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:uniscan/application/data/models/user.dart';

abstract class UserService extends Disposable {
  Stream<UserModel?> get currentUserStream;
  Future<UserModel?> get currentUserModel;
  String? get currentUserId;
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

  final CollectionReference<Map<String, dynamic>> _users;
  final FirebaseAuth _firebaseAuth;
  final _userStreamController = StreamController<UserModel?>.broadcast();
  late StreamSubscription<User?> _firebaseUserSubscriptionStream;
  StreamSubscription<Map<String, dynamic>?>? _userSubscriptionStream;

  @override
  Stream<UserModel?> get currentUserStream => _userStreamController.stream;

  void _subscribeToFirebaseUserChanges() {
    _firebaseUserSubscriptionStream = _firebaseAuth.authStateChanges().listen((final firebaseUser) async {
      await _userSubscriptionStream?.cancel();
      if (firebaseUser == null) {
        _userStreamController.add(null);
      } else {
        _subscribeToUserChanges(firebaseUser.uid);
      }
    });
  }

  void _subscribeToUserChanges(final String userId) {
    _userSubscriptionStream = _users.doc(userId).snapshots().map((final e) => e.data()).listen((final data) {
      if (data != null) {
        _userStreamController.add(UserModel.fromJson(data));
      }
    });
  }

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  Future<UserModel?> get currentUserModel async {
    final doc = await _users.doc(_firebaseAuth.currentUser?.uid).get();
    final snapData = doc.data();
    if (doc.exists && snapData != null) {
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
    } else {
      print('User already exists');
    }
  }

  @override
  Future<void> addQrCodeToUser(String docID) async {
    final user = await currentUserModel;
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

  @override
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

  @override
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
    _firebaseUserSubscriptionStream.cancel();
    _userSubscriptionStream?.cancel();
    _userStreamController.close();
  }
}
