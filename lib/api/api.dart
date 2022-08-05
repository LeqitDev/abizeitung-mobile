import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;

enum ReturnState { timeout, successful, error, login }

class RequestResults {
  final ReturnState state;
  final http.Response? response;

  RequestResults({required this.state, required this.response});
}

class AuthResult {
  final ReturnState state;
  final int code;

  AuthResult({required this.state, required this.code});
}

class API {
  String _token = '';

  final _storage = const FlutterSecureStorage();

  final _devIp = '10.0.2.2:8000';
  final _prodIp = 'api.cc-web.cloud';

  final _ioClient = HttpClient();
  late final http.IOClient _client;

  API() {
    _ioClient.connectionTimeout = const Duration(seconds: 30);
    _client = http.IOClient(_ioClient);
  }

  void dispose() {
    _client.close();
  }

  String get token {
    return _token;
  }

  Map<String, String> _getHeader(
      {String? content_type, String? accept_type, String? token}) {
    return <String, String>{
      'Content-Type':
          'application/${content_type != null ? '$content_type+' : ''}json',
      'Accept': 'application/${accept_type != null ? '$accept_type+' : ''}json',
      'Authorization': 'BEARER ${token ?? _token}',
    };
  }

  Uri _getUri(String endpoint, {String? forceEndpoint}) {
    String mainEndpoint = forceEndpoint ?? 'api/$endpoint';
    String unencodedPath = mainEndpoint.split('?')[0];
    Map<String, dynamic> params = <String, dynamic>{};
    if (mainEndpoint.contains('?')) {
      endpoint.split('?')[1].split('&').forEach((element) {
        params.addAll({element.split('=')[0]: element.split('=')[1]});
      });
    }
    return Uri.http(_devIp, unencodedPath, params);
  }

  Future<RequestResults> request(String type, String endpoint,
      {Map<String, dynamic>? body, String? token, bool? authenticate}) async {
    http.Response res;
    try {
      switch (type.toLowerCase()) {
        case 'post':
          res = await _client.post(
              _getUri(endpoint,
                  forceEndpoint: authenticate != null ? endpoint : null),
              headers:
                  _getHeader(accept_type: authenticate != null ? null : 'ld'),
              body: jsonEncode(body!));
          break;
        case 'get':
          res = await _client.get(
              _getUri(endpoint,
                  forceEndpoint: authenticate != null ? endpoint : null),
              headers: _getHeader(
                  accept_type: authenticate != null ? null : 'ld',
                  token: token));
          break;
        case 'delete':
          res = await _client.delete(_getUri(endpoint),
              headers: _getHeader(accept_type: 'ld'));
          break;
        case 'patch':
          res = await _client.patch(_getUri(endpoint),
              headers:
                  _getHeader(content_type: 'merge-patch', accept_type: 'ld'),
              body: jsonEncode(body!));
          break;
        default:
          return RequestResults(state: ReturnState.error, response: null);
      }
      return RequestResults(state: ReturnState.successful, response: res);
    } on TimeoutException catch (e) {
      return RequestResults(state: ReturnState.timeout, response: null);
    } catch (e) {
      print(e.toString());
      return RequestResults(state: ReturnState.error, response: null);
    }
  }

  Future<AuthResult> authenticate(AppStore appStore) async {
    final token = await _storage.read(key: 'jwt');

    if (token == null) {
      return _authenticateFromStorage(appStore);
    }

    final tokenReq = await request('get', 'users/0',
        token: token,
        authenticate:
            true); // will throw api error but only test if token is not exceeded

    if (tokenReq.response?.statusCode != 401) {
      _token = token;
      final username = await _storage.read(key: 'username');
      final userReq = await request('get', 'users/noid/$username');

      if (userReq.response?.statusCode == 200) {
        final res = userReq.response!;

        appStore.setAppUser(jsonDecode(res.body));
        return AuthResult(state: ReturnState.successful, code: 0);
      } else {
        if (userReq.state == ReturnState.successful) {
          return AuthResult(state: ReturnState.login, code: 0);
        }
        return AuthResult(state: userReq.state, code: 1);
      }
    } else {
      if (tokenReq.response?.statusCode == 401) {
        return _authenticateFromStorage(appStore);
      }
      return AuthResult(state: tokenReq.state, code: 2);
    }
  }

  Future<AuthResult> authenticateWithUsernameAndPassword(
      AppStore appStore, String username, String password,
      {bool? storeCredentials}) async {
    storeCredentials = storeCredentials ?? false;
    final authReq = await request('post', 'authentication/api',
        authenticate: true, body: {'username': username, 'password': password});
    if (authReq.response?.statusCode == 200) {
      final res = authReq.response!;
      final jsonRes = jsonDecode(res.body);
      _token = jsonRes['token'];
      final userReq = await request('get', 'users/noid/$username');
      if (userReq.response?.statusCode == 200) {
        appStore.setAppUser(jsonDecode(userReq.response!.body));
        await _storage.write(key: 'jwt', value: token);
        if (storeCredentials) {
          await _storage.write(key: 'username', value: username);
          await _storage.write(key: 'password', value: password);
        }
        return AuthResult(state: ReturnState.successful, code: 0);
      } else {
        if (userReq.state == ReturnState.successful) {
          return AuthResult(
              state: ReturnState.login,
              code: userReq.response?.statusCode ?? -1);
        }
        return AuthResult(state: userReq.state, code: 3);
      }
    } else {
      if (authReq.state == ReturnState.successful) {
        return AuthResult(
            state: ReturnState.login,
            code: (authReq.response?.statusCode ?? -1) * 10);
      }
      return AuthResult(state: authReq.state, code: 4);
    }
  }

  Future<AuthResult> _authenticateFromStorage(AppStore appStore) async {
    final username = await _storage.read(key: 'username');
    final password = await _storage.read(key: 'password');
    if (username != null && password != null) {
      return authenticateWithUsernameAndPassword(appStore, username, password);
    } else {
      return AuthResult(state: ReturnState.login, code: 5);
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
