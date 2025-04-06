import 'dart:convert';

import 'package:dapple/features/expert_talk/data/models/meeting_model.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../init_dependencies.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<AppointmentModel>> getAllAppointments();
  Future<MeetingModel> bookAppointment(String timeSlotId);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final String serverUrl = "${dotenv.env["BACKEND_URL"]!}/api";
  final EncryptedSharedPreferences encryptedSharedPreferences =
      serviceLocator();

  @override
  Future<List<AppointmentModel>> getAllAppointments() async {
    final String? token = encryptedSharedPreferences.getString("token");
    if (token == null) {
      throw ServerException("Token not found");
    }

    try {
      final response = await http.get(
        Uri.parse("$serverUrl/appointment"), // Adjust endpoint as needed
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      var json = jsonDecode(response.body);
      debugPrint("Appointments - ${json.toString()}");
      debugPrint("Response Code - ${response.statusCode}");
      if (response.statusCode == 200) {
        json = json["data"];
        // Assuming the response wraps appointments in a "data" field or similar
        if(json == null){
          return [];
        }
        if (json is List) {
          return (json).map((item) => AppointmentModel.fromJson(item)).toList();
        } else {
          throw ServerException("Invalid response format");
        }
      } else {
        throw ServerException(json["error"] ?? "Failed to load appointments");
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MeetingModel> bookAppointment(String timeSlotId) async {
    debugPrint("Booking appointment with timeSlotId: $timeSlotId");
    final String? token = encryptedSharedPreferences.getString("token");
    if (token == null) {
      throw ServerException("Token not found");
    }

    try {
      final response = await http.post(
        Uri.parse("$serverUrl/appointment/create"), // Adjust endpoint as needed (e.g., "/appointment/book")
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'timeSlotId': timeSlotId}), // Send timeSlotId in the request body
      );
      debugPrint("Response Code - ${response.statusCode}");



      var json = jsonDecode(response.body);
      debugPrint("Book Appointment Response - ${json.toString()}");
      if (response.statusCode == 200 || response.statusCode == 201) { // 201 for created
         // Assuming the response wraps the meeting data in a "data" field
        if (json == null) {
          throw ServerException("No data returned from booking");
        }
        return MeetingModel.fromJson(json); // Convert JSON to MeetingModel
      } else {
        throw ServerException(json["error"] ?? "Failed to book appointment");
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

}
