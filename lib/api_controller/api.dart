import 'dart:developer';
import 'package:api/model/item_model.dart';
import 'package:dio/dio.dart';

class DigimonApi {
  final dio = Dio();

  Future<List<DigimonModel>> fetchDigimonApi() async {
    List<DigimonModel> digimonList = [];
    try {
      final response = await dio.get(
        'https://digimon-api.vercel.app/api/digimon',
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final List<dynamic> rawData = response.data;
        digimonList = rawData
            .map((json) => DigimonModel.fromJson(json))
            .toList();
      }
      log("Digimonn list in Api= ${digimonList.length} done");
      return digimonList;
    } catch (e, st) {
      log("Error in Digimon Api: $e ,$st");
      rethrow;
    }
  }

  Future<List<DigimonModel>> fetchDigimonByName(String name) async {
    List<DigimonModel> digimonList = [];
    try {
      final response = await dio.get(
        'https://digimon-api.vercel.app/api/digimon/name/$name',
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final List<dynamic> rawData = response.data;
        digimonList = rawData
            .map((json) => DigimonModel.fromJson(json))
            .toList();
      }
      log("Digimonn by name in Api= ${digimonList.length} done");
      return digimonList;
    } catch (e, st) {
      log("Error in Digimon Api (name): $e ,$st");
      rethrow;
    }
  }

  Future<List<DigimonModel>> fetchDigimonByLevel(String level) async {
    List<DigimonModel> digimonList = [];
    try {
      final response = await dio.get(
        'https://digimon-api.vercel.app/api/digimon/level/$level',
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final List<dynamic> rawData = response.data;
        digimonList = rawData
            .map((json) => DigimonModel.fromJson(json))
            .toList();
      }
      log("Digimonn by level in Api= ${digimonList.length} done");
      return digimonList;
    } catch (e, st) {
      log("Error in Digimon Api (level): $e ,$st");
      rethrow;
    }
  }
}
