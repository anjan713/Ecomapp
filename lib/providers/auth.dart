import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
String _token;
String _userId;
DateTime _expiryDate;

  bool get auth{
      print('flow has entered auth statement');
      print(token != null);
    return token != null;
  } 
  String get token{
      print('flow has entered token statement');
    if(_expiryDate !=null && _expiryDate.isAfter(DateTime.now()) && _token!=null){
      print('flow has entered if statement');
      return _token;

    }
    return null;
  }
    
    String get userId{
      return _userId;
    }

Future<void> authentication(String email,String password,String urlSegment)async{
    try {
    final url='https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBijEwt2ENfrrqAljK8yA8zh3RvXielQw0';
  final response= await http.post(url,body: json.encode({
    'email':email,
    'password':password,
    'returnSecureToken':true
      })
      );
      final responsebody=json.decode(response.body);
      
      if (responsebody['error'] != null) {
        throw HttpException(responsebody['error']['message']);
      }
      _token=responsebody['idToken'];
      _userId=responsebody['localId'];
      _expiryDate=DateTime.now().add(Duration(seconds:int.parse(responsebody['expiresIn'],), ),); 
      notifyListeners();
      // print('token'+_token);
      
    } catch (error) {
        throw error;
    }
    

}

  Future<void> signUp(String email,String password)async{
    return authentication(email, password, 'signUp');
  }
  Future<void> logIn(String email,String password)async{
    return authentication(email, password, 'signInWithPassword');
  }

}