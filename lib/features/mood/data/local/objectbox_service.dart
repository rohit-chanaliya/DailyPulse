import 'package:path_provider/path_provider.dart';
import 'package:dailypulse/objectbox.g.dart';
import '../models/mood_entry.dart';

class ObjectBoxService {
  static late final Store store;
  static late final Box<MoodEntry> moodBox;

  static Future<void> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    store = await openStore(directory: '${docsDir.path}/objectbox');
    moodBox = Box<MoodEntry>(store);
  }
}
