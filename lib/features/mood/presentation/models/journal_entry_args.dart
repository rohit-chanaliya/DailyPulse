/// Values handed from the mood-logging screen to the journal entry screen.
class JournalEntryArgs {
  const JournalEntryArgs({required this.level, this.timestamp});

  final int level;

  /// Back-dated time chosen on the mood screen; `null` means "now".
  final DateTime? timestamp;
}
