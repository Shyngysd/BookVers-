abstract class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}

class InvalidEmailException extends AuthException {
  InvalidEmailException(super.message);
}

class WeakPasswordException extends AuthException {
  WeakPasswordException(super.message);
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException(super.message);
}

class UserNotFoundException extends AuthException {
  UserNotFoundException(super.message);
}

class WrongPasswordException extends AuthException {
  WrongPasswordException(super.message);
}

class NetworkException extends AuthException {
  NetworkException(super.message);
}

class AuthenticationFailedException extends AuthException {
  AuthenticationFailedException(super.message);
}
