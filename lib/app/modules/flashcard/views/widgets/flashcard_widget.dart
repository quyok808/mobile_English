import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashcardWidget extends StatelessWidget {
  final String word;
  final String description;
  final String pronounce;
  // final VoidCallback onDelete;

  FlashcardWidget({
    Key? key,
    required this.word,
    required this.description,
    required this.pronounce,
    // required this.onDelete,
  }) : super(key: key);

  final FlutterTts flutterTts = FlutterTts(); // Khởi tạo đối tượng FlutterTts
  // Hàm để phát âm từ
  void _speak() async {
    await flutterTts.setLanguage("en-US"); // Ngôn ngữ tiếng Anh
    await flutterTts.setPitch(1.0); // Độ cao giọng
    await flutterTts.speak(word); // Phát âm từ
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 220),
      child: SizedBox(
        child: FlipCard(
          front: _buildFrontCard(),
          back: _buildBackCard(),
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return SizedBox(
      width: 300, // Đảm bảo chiều rộng bằng với parent
      //height: 200, // Đảm bảo chiều cao bằng với parent
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Căn giữa nội dung trong thẻ
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _speak, // Khi nhấn loa, phát âm từ
                    child: Container(
                      padding: const EdgeInsets.all(
                          10.0), // Padding bên trong vòng tròn
                      decoration: BoxDecoration(
                        color: Colors.blue[300], // Màu nền vòng tròn
                        shape: BoxShape.circle, // Đảm bảo vòng tròn
                      ),
                      child: Icon(Icons.volume_up, // Biểu tượng loa
                          size: 30, // Kích thước biểu tượng
                          color: Colors.white // Màu biểu tượng
                          ),
                    ),
                  ),
                  // Thêm biểu tượng loa phía trên từ

                  const SizedBox(height: 8), // Khoảng cách giữa loa và từ
                  Text(
                    word,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Color.fromARGB(255, 0, 125, 227),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8), // Khoảng cách giữa từ và phát âm
                  Text(
                    '(${description.split(RegExp(r':'))[0]}) /$pronounce/',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 111, 111, 111),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return SizedBox(
      width: 300, // Đảm bảo chiều rộng bằng với parent
      //height: 200, // Đảm bảo chiều cao bằng với parent
      child: Card(
        elevation: 4,
        color: Color(0xFFC5FFF8),
        child: Center(
          // Dùng Center để căn giữa nội dung
          child: Padding(
            padding: EdgeInsets.all(8.0), // Đặt padding trong thẻ
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Căn giữa nội dung trong thẻ
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    description.contains(':')
                        ? description
                                .split(RegExp(r':'))[1]
                                .substring(1, 2)
                                .toUpperCase() +
                            description.split(RegExp(r':'))[1].substring(2)
                        : description.substring(0, 1).toUpperCase() +
                            description.substring(1),
                    style: GoogleFonts.itim(fontSize: 40),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
