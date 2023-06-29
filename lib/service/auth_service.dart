
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> createAuth(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = FirebaseAuth.instance.currentUser;

    if (user!= null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      return 'Mật khẩu quá yếu';
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      return 'Tài khoản đã tồn tại';
    }
  } catch (e) {
    print(e);
    return e.toString();
  }
  return null;
}

Future<String?> login(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    User? user = credential.user;
    if (!user!.emailVerified) {
      logout();
      return 'Tài khoản chưa được xác nhận';
    }
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
  return 'Email hoặc tài khoản không đúng';
}

void logout() async {
  await FirebaseAuth.instance.signOut();
}