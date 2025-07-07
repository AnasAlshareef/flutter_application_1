import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../DataBase/DataBase_Helper.dart'; // Adjust import path
import '../DataBase/Models/User_Model.dart'; // Adjust import path
import 'Auth_State.dart'; // Adjust import path
import 'Credentials_Storge.dart'; // SaveCredentials, DeleteCredentials, SaveUserName

class AuthCubit extends Cubit<AuthState> {
  final DatabaseHelper _databaseHelper;
  final SaveCredentials _saveCredentials;
  final DeleteCredentials _deleteCredentials;
  final SaveUserName _saveUserName;

  AuthCubit(
    this._databaseHelper,
    this._saveCredentials,
    this._deleteCredentials,
    this._saveUserName,
  ) : super(AuthInitial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      if (email.isEmpty || password.isEmpty) {
        emit(AuthFailure('Email and password are required.'));
        return;
      }

      // Get user by email instead of username
      final user = await _databaseHelper.getUserByEmail(email);

      if (user == null) {
        emit(AuthFailure('Invalid email or password.'));
        return;
      }

      // Hash the input password using SHA256
      final hashedInputPassword =
          sha256.convert(utf8.encode(password)).toString();

      // Compare stored hash with hashed input
      if (user.passwordHash == hashedInputPassword) {
        await _saveCredentials.saveCredentials(email, password);
        await _saveUserName.saveUserName(
          user.username,
        ); // or user.email if you prefer
        emit(AuthSuccess(user)); // Send the full user model
      } else {
        emit(AuthFailure('Invalid email or password.'));
      }
    } catch (e) {
      emit(AuthFailure('Login error: ${e.toString()}'));
    }
  }

  Future<void> registerUser({
    required String username,
    required String password,
    required String email,
  }) async {
    emit(AuthLoading());
    try {
      if (username.isEmpty || password.isEmpty || email.isEmpty) {
        emit(AuthFailure('Username, password and email are required.'));
        return;
      }

      // Check if username or email already exists
      final existingUserByUsername = await _databaseHelper.getUserByUsername(
        username,
      );
      if (existingUserByUsername != null) {
        emit(AuthFailure('Username already exists.'));
        return;
      }

      final existingUserByEmail = await _databaseHelper.getUserByEmail(email);
      if (existingUserByEmail != null) {
        emit(AuthFailure('Email already registered.'));
        return;
      }

      // Hash password before saving
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      // Create new UserModel as per your model (adjust if you have different fields)
      final newUser = UserModel(
        username: username,
        passwordHash: hashedPassword,
        email: email,
        balance: 0, // default balance
        createdAt: DateTime.now().toIso8601String(),
      );

      final id = await _databaseHelper.insertUser(newUser);

      if (id > 0) {
        emit(RegistrationSuccess());

        final newUser = await _databaseHelper.getUserByUsername(username);

        if (newUser != null) {
          await _saveCredentials.saveCredentials(username, password);
          await _saveUserName.saveUserName(newUser.username);
          emit(AuthSuccess(newUser));
        } else {
          emit(AuthFailure('Registration succeeded but failed to fetch user.'));
        }
      } else {
        emit(AuthFailure('Failed to register user.'));
      }
    } catch (e) {
      emit(AuthFailure('Registration error: ${e.toString()}'));
    }
  }

  Future<void> logout() async {
    try {
      await _deleteCredentials.deleteCredentials();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure('Logout error: ${e.toString()}'));
    }
  }

  Future<void> refreshUser() async {
    final currentState = state;

    if (currentState is AuthSuccess) {
      final user = await _databaseHelper.getUserByEmail(
        currentState.user.email,
      );

      if (user != null) {
        emit(AuthSuccess(user)); // Update state with fresh user data
      } else {
        emit(AuthFailure('Failed to refresh user data.'));
      }
    }
  }

  UserModel? get currentUser {
    final currentState = state;
    if (currentState is AuthSuccess) {
      return currentState.user;
    }
    return null;
  }
  
}
