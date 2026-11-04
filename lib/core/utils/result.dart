/// Outcome of a domain operation that can fail with a user-facing message.
///
/// Prefer this over returning `bool` plus a side-channel error signal: callers
/// are forced to handle both branches.
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

/// A failure. [message] is `null` when the operation was cancelled and should
/// not surface an error to the user.
final class Err<T> extends Result<T> {
  const Err([this.message]);

  final String? message;
}
