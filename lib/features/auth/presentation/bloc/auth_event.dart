abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String emailPhone;
  final String password;

  LoginRequested({required this.emailPhone, required this.password});
}
