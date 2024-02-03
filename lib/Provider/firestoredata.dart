import 'package:flutter/foundation.dart';

class FirestoreDataProvider extends ChangeNotifier {
  String ? fieldValue;

  void setFieldValue(String value) {
    fieldValue = value;
    notifyListeners();
  }
}