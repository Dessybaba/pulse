sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure()
    : super('No internet connection. Check your network and try again.');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('The request timed out. Please try again.');
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure() : super('That expense could not be found.');
}

class ServerFailure extends Failure {
  const ServerFailure()
    : super('Something went wrong on our end. Please try again.');
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super('An unexpected error occurred.');
}
