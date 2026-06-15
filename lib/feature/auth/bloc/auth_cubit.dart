

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit({required AuthRepository authRepository}) : _authRepository = authRepository, super(AuthInitial());



  void login({required String phone, required bool rememberMe}) {}

  void register({required String phone}) {}

  void logout() {}

  void verify({required String code}) {}
        
}
