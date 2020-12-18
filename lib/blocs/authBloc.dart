import 'package:chatSynergies/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthBloc {
  final authService = AuthService();
  final facebook = FacebookLogin();

  Stream<User> get currentUser => authService.currentUser;

  Future<bool> loginFacebook() async {
    print('staring facebook login...');

    final res = await facebook.logIn(['email']);

    switch (res.status) {
      case FacebookLoginStatus.loggedIn:
        print('It worked');

        //get the token
        final FacebookAccessToken facebookAccessToken = res.accessToken;

        //convert to the auth credential
        final AuthCredential credential =
            FacebookAuthProvider.credential(facebookAccessToken.token);

        //user credential to sign in with firebase
        final result = await authService.signInWithCredential(credential);

        print("${result.user.displayName} is logged in");
        return true;

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Cancelled by user');
        return false;
        break;
      case FacebookLoginStatus.error:
        print('There was some error...');
        return false;
        break;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      print('logging in with email and password');
      final loggedUser =
          await authService.signInWithEmailAndPassword(email, password);
      if (loggedUser.user == null) {
        return false;
      }
    } catch (e) {
      print('login screen error $e');
      return false;
    }
  }

  Future<bool> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final loggedUser =
          await authService.createUserWithEmailAndPassword(email, password);
      if (loggedUser.user == null) {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  logOut() {
    authService.logout();
    print('logging out user');
  }
}
