import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class FilterLocal {
  int ageMin;
  int ageMax;
  int distanceMax;

  FilterLocal({
    required this.ageMin,
    required this.ageMax,
    required this.distanceMax,
  });

  factory FilterLocal.fromJson(Map<String, dynamic> json) {
    return FilterLocal(
        ageMin: json['ageMin'],
        ageMax: json['ageMax'],
        distanceMax: json['distanceMax']);
  }

  Map<String, dynamic> toJson() {
    return {'ageMin': ageMin, 'ageMax': ageMax, 'distanceMax': distanceMax};
  }
}

Future<void> saveFilterLocal(FilterLocal profile) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonData = jsonEncode(profile.toJson());
  await prefs.setString('filter_data', jsonData);

  final savedFilter = await getFilterLocal();
  if (savedFilter != null) {
    log(savedFilter.toJson().toString());
  }
}

Future<FilterLocal?> getFilterLocal() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonData = prefs.getString('filter_data');
  if (jsonData != null) {
    final Map<String, dynamic> data = jsonDecode(jsonData);
    return FilterLocal.fromJson(data);
  }
  return null;
}
