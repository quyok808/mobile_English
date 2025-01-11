import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class LessonDetailPage extends StatefulWidget {
  final Map<String, dynamic> lesson;

  const LessonDetailPage({required this.lesson, Key? key}) : super(key: key);

  @override
  _LessonDetailPageState createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int currentIndex = 0;
  bool _showTranscript = false;
  bool _showTranslation = false;

  Map<int, TextEditingController> _controllers = {};
  Map<int, bool> _isAnswerChecked = {};
  Map<int, bool> _isAnswerCorrect = {};

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sections = widget.lesson['sections'] as List<dynamic>;
    final currentSection = sections[currentIndex] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Câu hỏi
            if (currentSection['questions'] != null)
              _buildQuestions(currentSection['questions']),
            // Audio và Transcript
            _buildAudioPlayer(currentSection),
            const SizedBox(height: 16),
            // Điều hướng giữa các phần
            _buildNavigationButtons(sections.length),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestions(List<dynamic> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: questions.asMap().entries.map((entry) {
        final index = entry.key;
        final question = entry.value as Map<String, dynamic>;

        _controllers.putIfAbsent(index, () => TextEditingController());

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question['question'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _controllers[index],
                decoration: InputDecoration(
                  hintText: 'Enter your answer...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isAnswerChecked[index] == true
                          ? (_isAnswerCorrect[index] == true
                          ? Colors.green
                          : Colors.red)
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isAnswerChecked[index] = true;
                    _isAnswerCorrect[index] =
                        question['answer'].toLowerCase() ==
                            _controllers[index]!.text.trim().toLowerCase();
                  });
                },
                child: const Text('Check Answer'),
              ),
              if (_isAnswerChecked[index] != null)
                Text(
                  _isAnswerCorrect[index] == true ? 'Correct!' : 'Incorrect',
                  style: TextStyle(
                    color: _isAnswerCorrect[index] == true
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              if (_isAnswerChecked[index] == true &&
                  _isAnswerCorrect[index] == false)
                Text(
                  'Correct Answer: ${question['answer']}',
                  style: const TextStyle(color: Colors.blue),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAudioPlayer(Map<String, dynamic> section) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<Duration?>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final total = _audioPlayer.duration ?? Duration.zero;

                return Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble(),
                      max: total.inSeconds.toDouble(),
                      onChanged: (value) {
                        _audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position)),
                        Text(_formatDuration(total)),
                      ],
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () async {
                    await _audioPlayer.setAsset(
                        "assets/audio/${section['audio']}");
                    _audioPlayer.play();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    _audioPlayer.stop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!_showTranscript)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showTranscript = true;
                  });
                },
                child: const Text('Show Transcript'),
              ),
            if (_showTranscript) ...[
              Text(
                section['transcript'],
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showTranslation = !_showTranslation;
                  });
                },
                child: Text(
                  _showTranslation ? 'Hide Translation' : 'Show Translation',
                ),
              ),
              if (_showTranslation)
                Text(
                  section['Translation'],
                  style: const TextStyle(fontSize: 16),
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showTranscript = false;
                    _showTranslation = false;
                  });
                },
                child: const Text('Hide Transcript'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(int totalSections) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: currentIndex > 0
              ? () {
            setState(() {
              currentIndex--;
              _audioPlayer.stop();
              _clearControllers();
              _resetViewStates(); // Reset trạng thái hiển thị
            });
          }
              : null,
          child: const Text('Previous'),
        ),
        ElevatedButton(
          onPressed: currentIndex < totalSections - 1
              ? () {
            setState(() {
              currentIndex++;
              _audioPlayer.stop();
              _clearControllers();
              _resetViewStates(); // Reset trạng thái hiển thị
            });
          }
              : null,
          child: const Text('Next'),
        ),
      ],
    );
  }
  void _resetViewStates() {
    _showTranscript = false;
    _showTranslation = false;
  }

  void _clearControllers() {
    _controllers.forEach((key, controller) {
      controller.clear();
    });
    _isAnswerChecked.clear();
    _isAnswerCorrect.clear();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
