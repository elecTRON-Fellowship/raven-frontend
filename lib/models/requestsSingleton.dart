import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:raven/models/user_singleton.dart';

class RequestsSingleton {
  var userSingleton = UserDataSingleton();

  RequestsSingleton._internal();

  static final RequestsSingleton _singleton = RequestsSingleton._internal();

  factory RequestsSingleton() {
    return _singleton;
  }

  Future<http.Response> createWallet() async {
    var url = Uri.parse('https://raven.herokuapp.com/cwallet');

    var response = await http.post(
      url,
      headers: {
        "user_id": userSingleton.getUserUid,
        "Content-Type": "application/json"
      },
      body: json.encode(userSingleton.toJson()),
    );

    return response;
  }

  Future<http.Response> fetchWalletBalance() async {
    var url = Uri.parse('https://raven.herokuapp.com/gbalance');

    CollectionReference _userCollection =
        FirebaseFirestore.instance.collection('users');

    FirebaseAuth _auth = FirebaseAuth.instance;

    final snapshot = await _userCollection.doc(_auth.currentUser!.uid).get();
    final data = snapshot.data() as Map;

    final _eWalletID = data['walletID'];

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"ewallet": _eWalletID}),
    );

    return response;
  }

  Future<http.Response> addMoneyToWallet(String amount) async {
    var url = Uri.parse('https://raven.herokuapp.com/afunds');

    CollectionReference _userCollection =
        FirebaseFirestore.instance.collection('users');

    FirebaseAuth _auth = FirebaseAuth.instance;

    final snapshot = await _userCollection.doc(_auth.currentUser!.uid).get();
    final data = snapshot.data() as Map;

    final _eWalletID = data['walletID'];

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "ewallet": _eWalletID,
        "amount": amount,
        "currency": "INR",
        "metadata": {"merchant_defined": true}
      }),
    );

    return response;
  }

  Future<http.Response> transferFunds(String amount, String friendID) async {
    var url = Uri.parse('https://raven.herokuapp.com/ctransfer');

    CollectionReference _userCollection =
        FirebaseFirestore.instance.collection('users');

    FirebaseAuth _auth = FirebaseAuth.instance;

    final senderSnapshot =
        await _userCollection.doc(_auth.currentUser!.uid).get();
    final senderData = senderSnapshot.data() as Map;
    final _senderEWalletID = senderData['walletID'];

    final receiverSnapshot = await _userCollection.doc(friendID).get();
    final receiverData = receiverSnapshot.data() as Map;
    final _receiverEWalletID = receiverData['walletID'];

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "source_ewallet": _senderEWalletID,
        "amount": amount,
        "currency": "INR",
        "destination_ewallet": _receiverEWalletID,
        "metadata": {"merchant_defined": true}
      }),
    );

    return response;
  }
}
