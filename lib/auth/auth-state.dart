
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:note/note/http/app-http-client.dart';

class AuthState extends ChangeNotifier {
  bool loading;
  get getLoading => loading;
  get getUser=>user;
  UserCredential user;
  final AppHttpClient httpClient;

  AuthState(this.httpClient);

  void toggleLoading(bool value) {
    loading = value;
    notifyListeners();
  }
void setUser(UserCredential _user){
    user=_user;

    notifyListeners();
}
  logIn(Map<String, String> payload) async {
    toggleLoading(true);
    UserCredential userCredential=await httpClient.LoginPost(payload);
    setUser(userCredential);
    toggleLoading(false);
    try {

    } catch(e){print(e);}finally {
    }
  }

  register(Map<String, String> payload) async{
    toggleLoading(true);
    try {
      setUser(await httpClient.RegisterPost(payload));
      addUser(payload);
    } finally {
      toggleLoading(false);
    }

  }
  signOut() async{
    toggleLoading(true);
    try {
      await FirebaseAuth.instance.signOut();
    } finally {
      toggleLoading(false);
    }

  }
  addUser(Map<String, String> payload) async{
    toggleLoading(true);
    try {
      //setUser(await httpClient.RegisterPost(payload));
      await httpClient.addUserPost(payload);
    } finally {
      toggleLoading(false);
    }

  }
}
