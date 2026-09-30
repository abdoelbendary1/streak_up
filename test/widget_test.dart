import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';
import 'package:streak_up/main.dart';

void main() {
  testWidgets('StreakUpShellApp smoke test renders four primary destinations', (
    WidgetTester tester,
  ) async {
    final logger = RedactedAppLogger();
    final shellCubit = ShellCubit();
    final statusCubit = ShellStatusCubit();
    final feedbackCoordinator = FeedbackCoordinator(logger);

    await tester.pumpWidget(
      StreakUpShellApp(
        shellCubit: shellCubit,
        statusCubit: statusCubit,
        feedbackCoordinator: feedbackCoordinator,
        routeHosts: const FeatureRouteHosts(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Habits'), findsOneWidget);
    expect(find.text('Challenges'), findsOneWidget);
    expect(find.text('Friends'), findsOneWidget);
  });
}
