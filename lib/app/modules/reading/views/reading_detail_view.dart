import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/themes/theme.dart';

class ReadingDetailView extends StatefulWidget {
  final Map<String, dynamic> reading;

  const ReadingDetailView({Key? key, required this.reading}) : super(key: key);

  @override
  _ReadingDetailViewState createState() => _ReadingDetailViewState();
}

class _ReadingDetailViewState extends State<ReadingDetailView> {
  final Map<int, String?> _selectedAnswers =
      {}; // Store selected answers for each question
  final Map<int, bool?> _answerStatus =
      {}; // Store answer status: correct or incorrect
  bool _showTranslation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reading['title'],
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: Get.back,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: AppTheme.color_appbar,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.reading['content'],
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showTranslation = !_showTranslation;
                });
              },
              child: Text(
                  _showTranslation ? 'Hide Translation' : 'Show Translation'),
            ),
            const SizedBox(height: 20),
            // Conditionally render translation
            if (_showTranslation)
              Text(
                widget.reading['translation'],
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
            const SizedBox(height: 20),
            _buildSectionTitle('Questions'),
            const SizedBox(height: 10),
            ...widget.reading['questions'].asMap().entries.map<Widget>((entry) {
              final int index = entry.key;
              final Map<String, dynamic> question = entry.value;
              final List<String> options =
                  List<String>.from(question['options']);
              final String correctAnswer = question['answer'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question['question'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...options.map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option, style: TextStyle(fontSize: 16)),
                            value: option,
                            groupValue: _selectedAnswers[index],
                            activeColor: Colors.blue,
                            tileColor: _selectedAnswers[index] != null
                                ? option == correctAnswer
                                    ? Colors.green.withOpacity(0.3)
                                    : _selectedAnswers[index] == option
                                        ? Colors.red.withOpacity(0.3)
                                        : null
                                : null,
                            onChanged: _selectedAnswers[index] != null
                                ? null // Disable changing answer after selection
                                : (value) {
                                    setState(() {
                                      _selectedAnswers[index] = value;
                                      _answerStatus[index] =
                                          value == correctAnswer;
                                    });
                                  },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            _buildSectionTitle('Vocabulary'),
            const SizedBox(height: 10),
            ...widget.reading['vocabulary'].map<Widget>((vocab) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    vocab['word'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meaning: ${vocab['meaning']}',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      if (vocab['example'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Example: ${vocab['example']}',
                            style:
                                TextStyle(fontSize: 14, color: Colors.blueGrey),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Helper method to build section title with styling
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.blue[600],
      ),
    );
  }
}
