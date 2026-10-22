import '../support/test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';

void main() {
  late ShellCubit shell;
  late ConnectivityCubit connectivity;
  late FeedbackCoordinator feedback;

  setUp(() {
    shell = ShellCubit();
    connectivity = ConnectivityCubit();
    feedback = FeedbackCoordinator(AppLogger());
  });

  tearDown(() async {
    await shell.close();
    await connectivity.close();
    await feedback.close();
  });

  test('startup does not assert unverified reachability', () {
    expect(connectivity.state, NetworkState.unknown);
  });

  testWidgets('offline/reconnecting notices have localized text and icons', (
    tester,
  ) async {
    await tester.pumpWidget(
      TestApp(
        shellCubit: shell,
        connectivityCubit: connectivity,
        feedbackCoordinator: feedback,
        simulatedDeviceLocale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text("You're offline"), findsNothing);

    connectivity.setNetworkState(NetworkState.offline);
    await tester.pumpAndSettle();
    expect(find.text("You're offline"), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);

    connectivity.setNetworkState(NetworkState.reconnecting);
    await tester.pumpAndSettle();
    expect(find.text('Reconnecting'), findsOneWidget);

    connectivity.setNetworkState(NetworkState.online);
    await tester.pumpAndSettle();
    expect(find.text('Reconnecting'), findsNothing);
    expect(find.text("You're offline"), findsNothing);
  });
}
