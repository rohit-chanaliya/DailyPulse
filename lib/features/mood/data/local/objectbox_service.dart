import 'package:dailypulse/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/mood_entry.dart';


class ObjectBoxService {
  static late final Store store;
  static late final Box<MoodEntry> moodBox;

  ObjectBoxService._();

  static Future<void> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    store = await openStore(
      directory: p.join(docsDir.path, "my-app-db"),
    );
    moodBox = store.box<MoodEntry>();
  }
}

