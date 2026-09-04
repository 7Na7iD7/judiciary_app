import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/person.dart';
import '../models/case.dart';
import '../models/case_person.dart';
import '../models/court.dart';
import '../models/prosecutor.dart';

class DatabaseService {
  static String get _baseUrl {
    if (kIsWeb || !Platform.isAndroid) {
      return "http:";
    } else {
      return "http:";
    }
  }

  static Future<List<Court>> getCourts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/courts'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Court.fromMap(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<Case>> getCases() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/cases'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Case.fromMap(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Person?> getPersonByNationalCode(String nationalCode) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/persons/by-nationalcode/$nationalCode'),
      );
      if (response.statusCode == 200) {
        return Person.fromMap(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> addPerson(Person person) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/persons'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(person.toMap()),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<String> addPersonToCase(
      int personID, int caseID, String role, String? notes) async {
    try {
      final Map<String, dynamic> data = {
        'PersonID': personID,
        'CaseID': caseID,
        'Role': role,
        'JoinDate': DateTime.now().toIso8601String(),
        'Notes': notes ?? ''
      };
      final response = await http.post(
        Uri.parse('$_baseUrl/casepersons'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return "اطلاعات با موفقیت ثبت شد";
      } else {
        return "خطا در ثبت: ${response.body}";
      }
    } catch (e) {
      return "خطا در ارتباط با سرور";
    }
  }

  static Future<List<CasePerson>> getAllCasePersons() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/casepersons'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => CasePerson.fromMap(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, int>> getDashboardStats() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/dashboard-stats'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'totalCases': data['TotalCases'] ?? 0,
          'activeCases': data['ActiveCases'] ?? 0,
          'closedCases': data['ClosedCases'] ?? 0,
          'totalPersons': data['TotalPersons'] ?? 0,
          'totalProsecutors': data['TotalProsecutors'] ?? 0,
          'totalHearings': data['TotalHearings'] ?? 0,
        };
      }
      return {
        'totalCases': 0,
        'activeCases': 0,
        'closedCases': 0,
        'totalPersons': 0,
        'totalProsecutors': 0,
        'totalHearings': 0
      };
    } catch (ex) {
      return {
        'totalCases': 0,
        'activeCases': 0,
        'closedCases': 0,
        'totalPersons': 0,
        'totalProsecutors': 0,
        'totalHearings': 0
      };
    }
  }

  static Future<List<Prosecutor>> getProsecutors() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/prosecutors'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Prosecutor.fromMap(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
