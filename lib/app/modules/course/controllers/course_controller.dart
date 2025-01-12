// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlya_english/models/course.dart';
import 'package:onlya_english/models/lesson.dart';
import 'package:onlya_english/models/speaking_topic%20.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CourseController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterTts flutterTts = FlutterTts();

  RxList<CourseModel> dbCourses = <CourseModel>[].obs;
  RxList<LessonModel> lessons = <LessonModel>[].obs;
  RxList<SpeakingTopicModel> speakingTopics = <SpeakingTopicModel>[].obs;

  var courses = [
    {
      "title": "Nghe",
      "description": "Khóa học luyện nghe",
      "imageUrl": "assets/images/listen.png",
      "type": "nghe"
    },
    {
      "title": "Nói",
      "description": "Khóa học luyện nói",
      "imageUrl": "assets/images/talk.png",
      "type": "nói"
    },
    {
      "title": "Đọc",
      "description": "Khóa học luyện đọc",
      "imageUrl": "assets/images/read.png",
      "type": "đọc"
    },
    {
      "title": "Viết",
      "description": "Khóa học luyện viết",
      "imageUrl": "assets/images/write.png",
      "type": "viết"
    },
  ].obs;

  RxBool isLoading = false.obs;
  RxString selectedType = "".obs;
  Rx<SpeakingTopicModel> speakingTopicData = SpeakingTopicModel(
    topicId: '',
    topicName: '',
    vocabulary: [],
    sentences: [],
    paragraph: '',
    imageUrl: '',
  ).obs;
  RxInt currentSpeakingPart = 1.obs;
  RxInt currentQuestionIndex = 0.obs;

  // Biến lưu trữ kết quả nhận dạng giọng nói và điểm số
  RxString recognizedText = "".obs;
  RxString incorrectWords = "".obs;
  RxDouble pronunciationScore = 0.0.obs;

  // Fetch courses by type
  Future<void> getCoursesByType(String type) async {
    isLoading.value = true;
    selectedType.value = type;
    try {
      QuerySnapshot courseSnapshot = await _firestore
          .collection('courses')
          .where('type', isEqualTo: type)
          .get();
      dbCourses.value = courseSnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error fetching courses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch lessons by courseId
  Future<void> getLessonsByCourseId(String courseId) async {
    isLoading.value = true;
    try {
      QuerySnapshot lessonSnapshot = await _firestore
          .collection('lessons')
          .where('courseId', isEqualTo: courseId)
          .orderBy('order')
          .get();
      lessons.value = lessonSnapshot.docs
          .map((doc) => LessonModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error fetching lessons: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Lấy danh sách chủ đề speaking topics
  Future<void> getSpeakingTopics() async {
    isLoading.value = true;
    try {
      QuerySnapshot topicSnapshot =
          await _firestore.collection('speaking_topics').get();
      speakingTopics.value = topicSnapshot.docs
          .map((doc) => SpeakingTopicModel.fromFirestore(doc))
          .toList();
      print("Speaking topics fetched: ${speakingTopics.value.length}");
    } catch (e) {
      print("Error fetching speaking topics: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Lấy dữ liệu SpeakingTopicModel từ Firestore
  Future<void> getSpeakingTopicData(String topicId) async {
    isLoading.value = true;
    try {
      DocumentSnapshot topicSnapshot =
          await _firestore.collection('speaking_topics').doc(topicId).get();
      if (topicSnapshot.exists) {
        speakingTopicData.value =
            SpeakingTopicModel.fromFirestore(topicSnapshot);
        currentSpeakingPart.value = 1; // Bắt đầu từ phần luyện từ
        currentQuestionIndex.value = 0; // Bắt đầu từ câu đầu tiên
        // Reset lại các biến lưu trữ kết quả
        recognizedText.value = "";
        incorrectWords.value = "";
        pronunciationScore.value = 0.0;
      } else {
        print("Speaking topic not found for ID: $topicId");
      }
    } catch (e) {
      print("Error fetching speaking topic data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Phát âm từ/câu/đoạn văn hiện tại
  Future<void> speakCurrentSentence() async {
    String textToSpeak = "";

    if (currentSpeakingPart.value == 1) {
      textToSpeak =
          speakingTopicData.value.vocabulary[currentQuestionIndex.value];
    } else if (currentSpeakingPart.value == 2) {
      textToSpeak =
          speakingTopicData.value.sentences[currentQuestionIndex.value];
    } else if (currentSpeakingPart.value == 3) {
      textToSpeak = speakingTopicData.value.paragraph;
    }

    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(textToSpeak);
  }

  // Chuyển đến câu hỏi tiếp theo
  void nextQuestion() {
    if (currentSpeakingPart.value == 1) {
      if (currentQuestionIndex.value <
          speakingTopicData.value.vocabulary.length - 1) {
        currentQuestionIndex.value++;
      } else {
        // Chuyển sang phần luyện câu
        currentSpeakingPart.value = 2;
        currentQuestionIndex.value = 0;
      }
    } else if (currentSpeakingPart.value == 2) {
      if (currentQuestionIndex.value <
          speakingTopicData.value.sentences.length - 1) {
        currentQuestionIndex.value++;
      } else {
        // Chuyển sang phần luyện đoạn
        currentSpeakingPart.value = 3;
        currentQuestionIndex.value = 0; // Chỉ có 1 đoạn văn
      }
    } else {
      // Kết thúc bài luyện nói
      print("Speaking practice completed!");
      Get.back(); // Quay lại màn hình trước đó
    }
    // Reset kết quả
    recognizedText.value = "";
    incorrectWords.value = "";
    pronunciationScore.value = 0.0;
  }

  // Chuyển đến câu hỏi trước đó
  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    } else if (currentSpeakingPart.value > 1) {
      currentSpeakingPart.value--;
      // Chuyển đến câu cuối cùng của phần trước
      if (currentSpeakingPart.value == 1) {
        currentQuestionIndex.value =
            speakingTopicData.value.vocabulary.length - 1;
      } else if (currentSpeakingPart.value == 2) {
        currentQuestionIndex.value =
            speakingTopicData.value.sentences.length - 1;
      }
    } else {
      // currentSpeakingPart.value == 1 && currentQuestionIndex.value == 0
      // Người dùng đang ở câu đầu tiên của phần 1, quay lại màn hình chọn topic
      Get.back();
    }
    // Reset kết quả
    recognizedText.value = "";
    incorrectWords.value = "";
    pronunciationScore.value = 0.0;
  }

  // Reset data khi back về màn hình chọn type
  void resetData() {
    selectedType.value = "";
    dbCourses.clear();
    lessons.clear();
  }

  @override
  void onInit() {
    super.onInit();
    getSpeakingTopics();
  }
}