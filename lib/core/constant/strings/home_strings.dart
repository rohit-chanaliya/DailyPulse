abstract final class HomeStrings {
  static const greetingPrefix = 'Hi, ';
  static const defaultUserName = 'Friend';
  static const noValue = '--';

  // Header badges
  static const dayStreak = 'Day Streak';
  static const startStreak = 'Start a streak';
  static const moodNotLogged = 'Not logged';
  static const checkInTooltip = 'Log how you feel';

  // Metrics
  static const metricsTitle = 'Mental Health Metrics';
  static const scoreTitle = 'Mood Score';
  static const scoreNoData = 'No data';
  static const scoreExcellent = 'Excellent';
  static const scoreHealthy = 'Healthy';
  static const scoreBalanced = 'Balanced';
  static const scoreLow = 'Low';
  static const scoreStruggling = 'Struggling';
  static const mood = 'Mood';
  static const healthJournal = 'Health Journal';

  // Mindful tracker
  static const trackerTitle = 'Mindful Tracker';
  static const mindfulJournal = 'Mindful Journal';
  static const journalEmpty = 'No entries yet';
  static const stressLevel = 'Stress Level';
  static const stressNoData = 'Not enough data yet';
  static const stressLow = 'Low';
  static const stressNormal = 'Normal';
  static const stressHigh = 'High';

  /// e.g. `Level 2 (Low)`.
  static String stressLabel(int level, String name) => 'Level $level ($name)';
  static const moodTracker = 'Mood Tracker';
  static const moodTrackerEmpty = 'Log a mood to see your trend';

  // Recent entries
  static const recentTitle = 'Recent Entries';
  static const seeAll = 'See All';

  // Mood picker
  static const moodPickerTitle = 'How are you feeling today?';
  static const moodPickerSubtitle = 'Tap a mood to log it';
  static const signInToLogMood = 'Please sign in to log your mood';
}
