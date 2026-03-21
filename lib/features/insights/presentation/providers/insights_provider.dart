import 'package:flutter/foundation.dart';
import '../../../mood/data/models/mood_entry.dart';
import '../../../mood/data/repositories/mood_repository.dart';

class InsightsProvider extends ChangeNotifier {
  final MoodRepository _repository = MoodRepository();

  List<MoodEntry> getAllEntries() {
    return _repository.getAllEntries();
  }
}
