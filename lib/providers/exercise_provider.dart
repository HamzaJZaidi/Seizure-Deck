import 'package:flutter/material.dart';
import 'package:seizure_deck/data/exercise_data.dart';

class ExerciseProvider extends ChangeNotifier {
  List<Exercise> _exercises = [];

  List<Exercise> get exercises => _exercises;

  void setExercises(List<Exercise> exercises) {
    _exercises = exercises;
    notifyListeners();
  }
}