import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Live Supabase Auth + Edge Function + PostgreSQL Create Habit E2E verification',
    () async {
      final previous = HttpOverrides.current;
      HttpOverrides.global = null;

      final envFile = File('.env.dev.json');
      if (!envFile.existsSync()) {
        markTestSkipped('.env.dev.json not found');
        return;
      }
      final env =
          jsonDecode(envFile.readAsStringSync()) as Map<String, dynamic>;
      final url = env['SUPABASE_URL'] as String;
      final anonKey = env['SUPABASE_ANON_KEY'] as String;

      final credFile = File('.dart_tool/sl02_live_probe_credentials.json');
      if (!credFile.existsSync()) {
        markTestSkipped('Probe credentials not found');
        return;
      }
      final creds =
          jsonDecode(credFile.readAsStringSync()) as Map<String, dynamic>;
      final email = creds['email'] as String;
      final password = creds['password'] as String;

      final supabase = SupabaseClient(url, anonKey);
      try {
        // 1. Sign in with real test user
        final authResponse = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        final session = authResponse.session;
        expect(session, isNotNull);
        final userId = session!.user.id;
        final accessToken = session.accessToken;
        expect(userId, isNotEmpty);
        expect(accessToken, isNotEmpty);

        // 2. Configure Dio
        final dio = Dio(
          BaseOptions(
            baseUrl: '$url/functions/v1/',
            headers: {
              'apikey': anonKey,
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          ),
        );

        final commandId = const Uuid().v4();
        final entityId = const Uuid().v4();

        final payload = {
          'name': 'Drink Water Daily',
          'description': 'Live remote vertical slice verification',
          'category': 'water',
          'targetMinutes': 10,
          'visibility': 'private',
          'schedule': {
            'frequency': 'daily',
            'weekdays': <int>[],
            'timezone': 'Africa/Cairo',
          },
        };

        final requestBody = {
          'commandId': commandId,
          'entityId': entityId,
          'version': 1,
          'payload': payload,
        };

        // 3. Post to create-habit-v1
        final response = await dio.post('create-habit-v1', data: requestBody);
        expect(response.statusCode, 200);
        final data = response.data as Map<String, dynamic>;
        expect(data['outcome'], 'accepted');
        expect(data['commandId'], commandId);
        expect(data['entityId'], entityId);
        expect(data['accountId'], userId);
        final habit = data['habit'] as Map<String, dynamic>;
        expect(habit['id'], entityId);
        expect(habit['accountId'], userId);
        expect(habit['name'], 'Drink Water Daily');
        expect(habit['revision'], 1);
        final createdAt = habit['createdAt'] as String;

        // 4. Duplicate replay with same command ID and same payload
        final replayResponse = await dio.post(
          'create-habit-v1',
          data: requestBody,
        );
        expect(replayResponse.statusCode, 200);
        final replayData = replayResponse.data as Map<String, dynamic>;
        expect(replayData['outcome'], 'accepted');
        expect(
          (replayData['habit'] as Map<String, dynamic>)['createdAt'],
          createdAt,
        );

        // 5. Command reuse with different payload
        final modifiedBody = {
          'commandId': commandId,
          'entityId': entityId,
          'version': 1,
          'payload': {...payload, 'name': 'Different Name Reused Command'},
        };
        final reusedResponse = await dio.post(
          'create-habit-v1',
          data: modifiedBody,
          options: Options(validateStatus: (s) => true),
        );
        expect(reusedResponse.statusCode, 422);
        final reusedData = reusedResponse.data as Map<String, dynamic>;
        expect(reusedData['outcome'], 'rejected');
        expect(reusedData['reason'], 'commandReused');

        // 6. Unauthorized request (invalid token)
        final unauthorizedDio = Dio(
          BaseOptions(
            baseUrl: '$url/functions/v1/',
            headers: {
              'apikey': anonKey,
              'Authorization': 'Bearer invalid-token-12345',
              'Content-Type': 'application/json',
            },
          ),
        );
        final unauthResponse = await unauthorizedDio.post(
          'create-habit-v1',
          data: requestBody,
          options: Options(validateStatus: (s) => true),
        );
        expect(unauthResponse.statusCode, 401);
        expect(
          (unauthResponse.data as Map<String, dynamic>)['outcome'],
          'unauthorized',
        );

        // 7. Unauthorized request (no token)
        final noTokenDio = Dio(
          BaseOptions(
            baseUrl: '$url/functions/v1/',
            headers: {'apikey': anonKey, 'Content-Type': 'application/json'},
          ),
        );
        final noTokenResponse = await noTokenDio.post(
          'create-habit-v1',
          data: requestBody,
          options: Options(validateStatus: (s) => true),
        );
        expect(noTokenResponse.statusCode, 401);
        expect(
          (noTokenResponse.data as Map<String, dynamic>)['outcome'],
          'unauthorized',
        );

        // 8. Forged owner attempt in root envelope: rejected with 400 invalidRequest
        final forgedRootResponse = await dio.post(
          'create-habit-v1',
          data: {
            'commandId': const Uuid().v4(),
            'entityId': const Uuid().v4(),
            'version': 1,
            'accountId': '00000000-0000-0000-0000-000000000000',
            'payload': payload,
          },
          options: Options(validateStatus: (s) => true),
        );
        expect(forgedRootResponse.statusCode, 400);
        expect(
          (forgedRootResponse.data as Map<String, dynamic>)['outcome'],
          'invalidRequest',
        );

        // 9. Forged owner attempt in payload: rejected with 422 invalidPayload
        final forgedPayloadResponse = await dio.post(
          'create-habit-v1',
          data: {
            'commandId': const Uuid().v4(),
            'entityId': const Uuid().v4(),
            'version': 1,
            'payload': {
              ...payload,
              'accountId': '00000000-0000-0000-0000-000000000000',
            },
          },
          options: Options(validateStatus: (s) => true),
        );
        expect(forgedPayloadResponse.statusCode, 422);
        expect(
          (forgedPayloadResponse.data as Map<String, dynamic>)['outcome'],
          'rejected',
        );
        expect(
          (forgedPayloadResponse.data as Map<String, dynamic>)['reason'],
          'invalidPayload',
        );
      } finally {
        supabase.dispose();
        HttpOverrides.global = previous;
      }
    },
  );
}
