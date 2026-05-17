// ignore_for_file: use_build_context_synchronously, unnecessary_import

import 'dart:developer';
import 'package:api/api.dart';
import 'package:api/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DigimonController extends ChangeNotifier {
  bool loader = false;
  List<DigimonModel> digimonList = [];
  DigimonApi api = DigimonApi();

  void fetchDigimon(BuildContext context) async {
    try {
      loader = true;
      notifyListeners();

      digimonList = await api.fetchDigimonApi();
      log("digimon list in controller: ${digimonList.length} ");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Success: Data loaded'),
          backgroundColor: Colors.green,
        ),
      );
      loader = false;
      notifyListeners();
    } catch (e) {
      loader = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Data not loaded'),
          backgroundColor: Colors.red,
        ),
      );
      notifyListeners();
    }
  }

  void fetchDigimonByName(BuildContext context, String name) async {
    try {
      loader = true;
      notifyListeners();

      digimonList = await api.fetchDigimonByName(name);
      log("digimon list in controller by name: ${digimonList.length} ");

      loader = false;
      notifyListeners();
    } catch (e) {
      loader = false;
      digimonList = [];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Digimon not found by name'),
          backgroundColor: Colors.red,
        ),
      );
      notifyListeners();
    }
  }

  void fetchDigimonByLevel(BuildContext context, String level) async {
    try {
      loader = true;
      notifyListeners();

      digimonList = await api.fetchDigimonByLevel(level);
      log("digimon list in controller by level: ${digimonList.length} ");

      loader = false;
      notifyListeners();
    } catch (e) {
      loader = false;
      digimonList = [];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Digimons not found by level'),
          backgroundColor: Colors.red,
        ),
      );
      notifyListeners();
    }
  }
}
