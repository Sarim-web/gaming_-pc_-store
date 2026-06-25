import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_amazon_clone_bloc/src/data/models/user.dart';
import 'package:flutter_amazon_clone_bloc/src/data/repositories/auth_repository.dart';
import 'package:flutter_amazon_clone_bloc/src/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'page_redirection_state.dart';

class PageRedirectionCubit extends Cubit<PageRedirectionState> {
  final AuthRepository authRepository;
  UserRepository userRepository = UserRepository();
  PageRedirectionCubit(this.authRepository) : super(PageRedirectionInitial());

  Future<void> redirectUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('x-auth-token')?.trim() ?? '';

      if (token.isEmpty) {
        emit(const PageRedirectionInvalid(isValid: false, userType: 'invalid'));
        return;
      }

      final bool isValid = await authRepository.isTokenValid(token: token);
      if (!isValid) {
        emit(const PageRedirectionInvalid(isValid: false, userType: 'invalid'));
        return;
      }

      final User user = await userRepository.getUserDataInitial(token);
      emit(PageRedirectionSuccess(isValid: true, userType: user.type));
    } catch (e) {
      emit(const PageRedirectionInvalid(isValid: false, userType: 'invalid'));
    }
  }
}
