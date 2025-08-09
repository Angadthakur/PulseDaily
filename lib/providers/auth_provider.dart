import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isloading = false;
  String? _errormessage;

  //getters
  User? get user => _user;
  bool get isloading => _isloading;
  String? get errorMessage => _errormessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    print("AuthProvider constructor called");

    _user = _auth.currentUser;
    print("Initial user: ${_user?.uid}");

    _auth.authStateChanges().listen((User? user) {
       print("=== Auth State Change ===");
       print("Previous user: ${_user?.uid}");
       print("New user: ${user?.uid}");
       print("========================");
      _user = user;
      notifyListeners();
    });
  }
  //Signup with email and pass
  Future<bool> signUp(String email, String password, String name) async {
    try {
      print("Starting signup for: $email");
      _setLoading(true);
      _clearError();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User created: ${result.user?.uid}");

      await Future.delayed(Duration(milliseconds: 500));
      try{
      await result.user?.updateDisplayName(name);
      print("Display name updated");
      }catch(displayNameError){
        print("Display name update error (non-critical): $displayNameError");
      }

      await result.user?.reload();

      _user = _auth.currentUser;
      print("Current user after reload: ${_user?.uid}");

      _setLoading(false);
      print("Signup successful");
      return true;

    } on FirebaseAuthException catch (e) {
      print("Firebase Auth error: ${e.code} - ${e.message}");
      _setLoading(false);
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      print("Signup error: $e");
      _setLoading(false);
      
      User? currentUser = _auth.currentUser;
      if(currentUser != null){
        print("User was created despite error : ${currentUser.uid}");
        _user = currentUser;
        
        try{
          if(currentUser.displayName == null || currentUser.displayName !. isEmpty){
            await currentUser.updateDisplayName(name);
            await currentUser.reload();
            _user = _auth.currentUser;
          }
        }catch(nameError){
          print("Display name update error: $nameError");
        }
        notifyListeners();
        return true;
      }
      _setError("An unexpected error occured");
       return false;
    }
  }

  //Signin with email and pass
  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = result.user;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setLoading(false);
      _setError("An unexpected error occured");
      return false;
    }
  }

  //signout
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  //resetpassword
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _auth.sendPasswordResetEmail(email: email);

      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setLoading(false);
      _setError("An unexpected error occurred");
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isloading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errormessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errormessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

//firebase error codes to user-friendly messages
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case "user-not-found":
        return "No user found with this email address.";

      case "wrong-password":
        return "Wrong password provided.";

      case 'email-already-in-use':
        return "An account already exists with this email.";

      case "weak-password":
        return "Password should be at least 6 characters.";

      case "invalid-email":
        return "Please enter a valid email address.";

      case "user-disabled":
        return "This user account has been disabled.";

      case "too-many-requests":
        return "Too many attempts. Please try again later.";

      default:
        return "Authentication failed. Please try again.";
    }
  }
}


