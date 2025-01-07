import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentAvatarUrl;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentAvatarUrl,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _avatarController;
  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _avatarController = TextEditingController(text: widget.currentAvatarUrl);
    _imageUrl = widget.currentAvatarUrl;
  }

  // Hàm chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Tải ảnh lên Cloudinary
      await _uploadImageToCloudinary();
    }
  }

  // Hàm tải ảnh lên Cloudinary
  Future<void> _uploadImageToCloudinary() async {
    try {
      if (_imageFile == null) return;

      // Hiển thị thông báo tải ảnh
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đang tải ảnh lên Cloudinary...')),
      );

      // Đọc tệp ảnh và mã hóa Base64
      final imageBytes = await _imageFile!.readAsBytes();

      // Tạo request tới Cloudinary API
      Uri uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/dscrgyvj0/image/upload?api_key=433815246414856&api_secret=yNW3M7aejZCZEIeawlgvO2Uj0Pw');
      var request = http.MultipartRequest("POST", uri);
      request.fields['upload_preset'] =
          'ml_default'; // Thay bằng upload preset của bạn
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ));

      // Gửi request
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseData);

        setState(() {
          _imageUrl = jsonResponse['secure_url']; // Lấy URL ảnh
        });

        // Cập nhật URL của avatar vào Firestore
        await _updateProfileImageInFirestore(_imageUrl!);

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tải ảnh lên thành công!')),
        );
      } else {
        throw Exception('Lỗi khi tải ảnh lên Cloudinary');
      }
    } catch (e) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  // Hàm cập nhật URL avatar trong Firestore
  Future<void> _updateProfileImageInFirestore(String imageUrl) async {
    // Giả sử bạn đã có FirebaseAuth và Firestore trong dự án của mình
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'avatar': imageUrl,
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  // Hàm cập nhật thông tin người dùng
  Future<void> _updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': _nameController.text,
          'avatar':
              _imageUrl, // Cập nhật URL ảnh (hoặc nếu không thay đổi, thì để nguyên)
        });

        Navigator.pop(context); // Quay lại màn hình Account
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa thông tin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage, // Chọn ảnh khi nhấn vào avatar
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageUrl != null && _imageUrl!.isNotEmpty
                    ? NetworkImage(_imageUrl!)
                    : null,
                backgroundColor: Colors.grey[300],
                child: _imageFile == null &&
                        (_imageUrl == null || _imageUrl!.isEmpty)
                    ? Icon(Icons.camera_alt, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
