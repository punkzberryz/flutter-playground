import 'dart:async';
import 'package:flutter_playground/features/auth/auth_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final authStateProvider = StreamProvider<CognitoUserSession?>((ref) {
  final repo = ref.read(authRepositoryProvider);
  final stream = repo.authStateChange();
  repo.initializer();
  return stream;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final userPoolId = dotenv.env['USER_POOL_ID'];
  final clientId = dotenv.env['USER_POOL_CLIENT_ID'];
  if (userPoolId == null || clientId == null) {
    throw Exception("ENV VAR not found..");
  }
  final storage = AuthStorage('auth:');
  final userPool = CognitoUserPool(userPoolId, clientId, storage: storage);

  return AuthRepository(userPool: userPool);
});

class AuthRepository {
  AuthRepository({
    required this.userPool,
  });
  final CognitoUserPool userPool;
  CognitoUser? _auth;
  final _authStateController = StreamController<CognitoUserSession?>();

  Stream<CognitoUserSession?> authStateChange() => _authStateController.stream;

  Future<void> initializer() async {
    print('initializing auth');
    _auth = await userPool.getCurrentUser();
    if (_auth == null) {
      print('current user = null');
      return;
    }
    try {
      final session = await _auth!.getSession();
      _authStateController.add(session);
      if (session != null) {
        print('got session!');
        _setRefreshTokenInterval(session);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> signUpWithEmail(
      {required String email, required String password}) async {
    try {
      await userPool.signUp(email, password);
    } catch (e) {
      print(e);
    }
  }

  Future<void> confirmRegistration(
      {required String email, required String otp}) async {
    try {
      _auth = CognitoUser(email, userPool);
      final isConfirm = await _auth!.confirmRegistration(otp);
      if (!isConfirm) {
        throw "Not confirmed...";
      }
      final session = await _auth!.getSession();
      if (session == null) {
        throw "Unauth...";
      }
      _authStateController.add(session);
      _setRefreshTokenInterval(session);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    _auth = CognitoUser(email, userPool);

    try {
      final session = await _auth!.authenticateUser(
          AuthenticationDetails(username: email, password: password));
      _authStateController.add(session);
      if (session == null) {
        _auth = null;
        throw "Session is NULL";
      }
      _setRefreshTokenInterval(session);
    } on CognitoUserNewPasswordRequiredException catch (e) {
      // handle New Password challenge
      print(e);
    } on CognitoUserMfaRequiredException catch (e) {
      // handle SMS_MFA challenge
      print(e);
    } on CognitoUserSelectMfaTypeException catch (e) {
      // handle SELECT_MFA_TYPE challenge
      print(e);
    } on CognitoUserMfaSetupException catch (e) {
      // handle MFA_SETUP challenge
      print(e);
    } on CognitoUserTotpRequiredException catch (e) {
      // handle SOFTWARE_TOKEN_MFA challenge
      print(e);
    } on CognitoUserCustomChallengeException catch (e) {
      // handle CUSTOM_CHALLENGE challenge
      print(e);
    } on CognitoUserConfirmationNecessaryException catch (e) {
      // handle User Confirmation Necessary
      print(e);
    } on CognitoClientException catch (e) {
      // handle Wrong Username and Password and Cognito Client
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    if (_auth != null) {
      try {
        await _auth!.signOut();
        _authStateController.add(null);
        return _auth = null;
      } catch (error) {
        print(error);
      }
    }
  }

  Future<void> authenticate() async {
    if (_auth == null) {
      return print('Unauth!');
    }
    final session = _auth!.getSignInUserSession();
    final token = session?.accessToken.jwtToken;
    if (token != null) {
      final exp = JwtDecoder.getRemainingTime(token);

      print(exp.toString());
      print(exp.inSeconds);
    }
    if (session?.isValid() == true) {
      print('is valid!!');
      return;
    }
    print('token is invalid!!');
  }

  void _setRefreshTokenInterval(CognitoUserSession session) {
    final token = session.accessToken.jwtToken;
    final refreshToken = session.refreshToken;
    if (token == null || refreshToken == null) {
      return;
    }
    int expiredInSeconds = JwtDecoder.getRemainingTime(token).inSeconds;
    if (expiredInSeconds < 2) expiredInSeconds = 2;

    print('set new interval with duration of ${expiredInSeconds - 5} seconds');
    Future.delayed(Duration(seconds: expiredInSeconds - 5), () async {
      print('refreshing token..');

      if (_auth == null) {
        return;
      }

      final session = await _auth!.refreshSession(refreshToken);
      _authStateController.add(session);
      if (session == null) {
        //session is invalid, let's remove _auth too
        return _auth = null;
      }
      _setRefreshTokenInterval(session);
    });

    return;
  }
}
