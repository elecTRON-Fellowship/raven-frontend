import 'package:uuid/uuid.dart';

class UserDataSingleton {
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _phoneNumber;
  late String _mothersName;
  late String _addressLine1;
  late String _addressLine2;
  late String _addressLine3;
  late String _city;
  late String _state;
  late String _country;
  late String _zip;
  late String _dob;
  late String _nationality;
  late String _idNumber;

  final _ewallet_reference_id = Uuid().v4();

  final _instance = UserDataSingleton();

  get getInstance {
    return _instance;
  }

  set firstName(String firstName) {
    this._firstName = firstName;
  }

  set latName(String lastName) {
    this._lastName = lastName;
  }

  set email(String email) {
    this._email = email;
  }

  set phoneNumber(String phoneNumber) {
    this._phoneNumber = phoneNumber;
  }

  set mothersName(String mothersName) {
    this._mothersName = mothersName;
  }

  set addressLine1(String addressLine1) {
    this._addressLine1 = addressLine1;
  }

  set addressLine2(String addressLine2) {
    this._addressLine2 = addressLine2;
  }

  set addressLine3(String addressLine3) {
    this._addressLine3 = addressLine3;
  }

  set city(String city) {
    this._city = city;
  }

  set state(String state) {
    this._state = state;
  }

  set country(String country) {
    this._country = country;
  }

  set zip(String zip) {
    this._zip = zip;
  }

  set dob(String dob) {
    this._dob = dob;
  }

  set nationality(String nationality) {
    this._nationality = nationality;
  }

  set idNumber(String idNumber) {
    this._idNumber = idNumber;
  }

  Map<String, dynamic> toJson() => {
        "first_name": _firstName,
        "last_name": _lastName,
        "email": _email,
        "ewallet_reference_id": _ewallet_reference_id,
        "metadata": {"merchant_defined": true},
        "phone_number": _phoneNumber,
        "type": "person",
        "contact": {
          "phone_number": _phoneNumber,
          "email": _email,
          "first_name": _firstName,
          "last_name": _lastName,
          "mothers_name": _mothersName,
          "contact_type": "personal",
          "address": {
            "name": _firstName + " " + _lastName,
            "line_1": _addressLine1,
            "line_2": _addressLine2,
            "line_3": _addressLine3,
            "city": _city,
            "state": _state,
            "country": _country,
            "zip": _zip,
            "phone_number": _phoneNumber,
            "metadata": {},
            "canton": "",
            "district": ""
          },
          "identification_type": "PA",
          "identification_number": _idNumber,
          "date_of_birth": _dob,
          "country": _country,
          "nationality": _nationality,
          "metadata": {"merchant_defined": true}
        }
      };

  void printData() {
    print(toJson());
  }

  Map<String, dynamic> get map {
    return toJson();
  }
}
