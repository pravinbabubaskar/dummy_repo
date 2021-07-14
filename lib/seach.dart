import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField) {
    var result =FirebaseFirestore.instance
        .collection('hotel')
        .where('name',
        isEqualTo: searchField.substring(0, 1).toUpperCase())
        .snapshots();
    print(result);
    return result.toList();
  }
}