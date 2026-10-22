import '../support/test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/app/routing/app_routes.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/feedback/feedback_models.dart';
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
  Widget app({WidgetBuilder? todayBuilder}) => TestApp(
    shellCubit: shell,
    connectivityCubit: connectivity,
    feedbackCoordinator: feedback,
    todayBuilder: todayBuilder,
    simulatedDeviceLocale: const Locale('en'),
  );
  testWidgets(
    'four severities use localized prefix, icon, message and optional action',
    (tester) async {
      var triggered = false;
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      for (final kind in FeedbackKind.values) {
        feedback.publish(
          FeedbackDescriptor(
            id: kind.name,
            kind: kind,
            message: 'Safe notice',
            actionIntent: FeedbackActionIntent(
              label: 'Retry',
              onTriggered: () => triggered = true,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.textContaining('Safe notice'), findsOneWidget);
        expect(find.byType(SnackBarAction), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.byType(Icon),
          ),
          findsWidgets,
        );
      }
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(triggered, isTrue);
      expect(feedback.state.activeTransient, isNull);
    },
  );
  testWidgets('latest temporary notice replaces old notice and expires', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    feedback.publish(
      const FeedbackDescriptor(
        id: 'first',
        kind: FeedbackKind.information,
        message: 'First',
      ),
    );
    await tester.pumpAndSettle();
    feedback.publish(
      const FeedbackDescriptor(
        id: 'second',
        kind: FeedbackKind.success,
        message: 'Second',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('First'), findsNothing);
    expect(find.textContaining('Second'), findsOneWidget);
    expect(feedback.state.activeTransient?.id, 'second');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
    expect(feedback.state.activeTransient, isNull);
  });
  testWidgets('dismissing notice leaves feature inline error and retry', (
    tester,
  ) async {
    var retryCount = 0;
    await tester.pumpWidget(
      app(
        todayBuilder: (_) => Column(
          children: [
            const Text('Unable to load content'),
            TextButton(
              onPressed: () => retryCount++,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    feedback.publish(
      const FeedbackDescriptor(
        id: 'notice',
        kind: FeedbackKind.warning,
        message: 'Attention',
      ),
    );
    await tester.pumpAndSettle();
    feedback.dismissTransient();
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('Unable to load content'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(retryCount, 1);
    expect(find.text('Unable to load content'), findsOneWidget);
  });
  testWidgets(
    'temporary feedback covers global routes and account reset removes outgoing actions',
    (tester) async {
      final router = createTestRouter();
      addTearDown(router.dispose);
      var triggered = false;
      await tester.pumpWidget(
        TestApp(
          router: router,
          shellCubit: shell,
          connectivityCubit: connectivity,
          feedbackCoordinator: feedback,

          simulatedDeviceLocale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();
      const ProfileRouteData().push<void>(
        router.routerDelegate.navigatorKey.currentContext!,
      );
      await tester.pumpAndSettle();
      feedback.publish(
        FeedbackDescriptor(
          id: 'outgoing',
          kind: FeedbackKind.warning,
          message: 'Safe warning',
          actionIntent: FeedbackActionIntent(
            label: 'Retry',
            onTriggered: () => triggered = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      feedback.resetForAccountTransition();
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
      expect(find.text('Retry'), findsNothing);
      expect(triggered, isFalse);
      expect(feedback.state.activeTransient, isNull);
    },
  );
}
