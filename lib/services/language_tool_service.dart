import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/essay_model.dart';

class LanguageToolService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> analyzeEssay(String text) async {
    final uri = Uri.parse("https://api.languagetool.org/v2/check");
    final response = await http.post(uri, body: {
      "text": text,
      "language": "en-US",
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final matches = jsonResponse["matches"];
      String feedback = "";

      for (var match in matches) {
        feedback +=
            "Error: ${match['message']}\nSuggestion: ${match['replacements'].map((e) => e['value']).join(', ')}\n\n";
      }

      return feedback.isNotEmpty ? feedback : "Your essay has no errors!";
    } else {
      throw Exception("Failed to analyze essay");
    }
  }

  Future<void> saveEssayToFirestore(Essay essay) async {
    await _firestore.collection('essays').add(essay.toMap());
  }

  Stream<List<Essay>> getEssaysStream() {
    String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      //feedback.value = 'Error: User is not logged in!';
      return Stream.value([]); // Trả về một danh sách rỗng nếu không có userId
    }
    return _firestore
        .collection('essays')
        .where('userId', isEqualTo: userId)
        //.orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Essay.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
