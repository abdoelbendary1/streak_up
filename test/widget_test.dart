import 'support/test_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';

void main() {
  testWidgets('StreakUpApp smoke test renders four primary destinations', (
    WidgetTester tester,
  ) async {
    final logger = AppLogger();
    final shellCubit = ShellCubit();
    final connectivityCubit = ConnectivityCubit();
    final feedbackCoordinator = FeedbackCoordinator(logger);

    await tester.pumpWidget(
      TestApp(
        shellCubit: shellCubit,
        connectivityCubit: connectivityCubit,
        feedbackCoordinator: feedbackCoordinator,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Habits'), findsOneWidget);
    expect(find.text('Challenges'), findsOneWidget);
    expect(find.text('Friends'), findsOneWidget);
  });
}
