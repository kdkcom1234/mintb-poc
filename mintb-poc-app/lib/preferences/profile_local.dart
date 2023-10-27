import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileLocal {
  final String nickname;
  final int age;
  final int gender;
  final List<String> images;
  final List<int> languages;

  ProfileLocal(
      {required this.nickname,
      required this.age,
      required this.gender,
      required this.images,
      required this.languages});

  factory ProfileLocal.fromJson(Map<String, dynamic> json) {
    return ProfileLocal(
        nickname: json['nickname'],
        age: json['age'],
        gender: json['gender'],
        images: List<String>.from(json['images']),
        languages: List<int>.from(json['languages']));
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'age': age,
      'gender': gender,
      'images': images,
      'languages': languages
    };
  }
}

Future<void> saveProfileLocal(ProfileLocal profile) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonData = jsonEncode(profile.toJson());
  await prefs.setString('profile_data', jsonData);
}

Future<ProfileLocal?> getProfileLocal() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonData = prefs.getString('profile_data');
  if (jsonData != null) {
    final Map<String, dynamic> data = jsonDecode(jsonData);
    return ProfileLocal.fromJson(data);
  }
  return null;
}
