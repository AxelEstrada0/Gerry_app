import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

class UserService {

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Future<void> reautenticar(String email, String password) async {
    final user = FirebaseAuth.instance.currentUser!;

    final cred = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(cred);
  }

  // escuchar usuario en tiempo real
  Stream<AppUser> streamUser() {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => AppUser.fromMap(doc.id, doc.data()!));
  }

  // obtener usuario una sola vez
  Future<AppUser> getUser() async {
    final doc = await _db.collection('users').doc(uid).get();
    return AppUser.fromMap(doc.id, doc.data()!);
  }

  // actualizar datos
  Future<void> updateUser(Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // eliminar datos
  Future<void> deleteUser(String email, String password) async {
    final user = FirebaseAuth.instance.currentUser;
    await reautenticar(email, password);
    await _db.collection('users').doc(user!.uid).delete();
    await user.delete();
  }
}