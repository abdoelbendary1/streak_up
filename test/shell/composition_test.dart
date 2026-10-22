import 'package:streak_up/core/presentation/feedback/widgets/shared_feedback_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/app/theme/app_theme.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/feedback/feedback_models.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/features/shell/presentation/screens/app_shell.dart';

class _Destination extends StatefulWidget {
  const _Destination(this.onMount);
  final VoidCallback onMount;
  @override
  State<_Destination> createState() => _DestinationState();
}

class _DestinationState extends State<_Destination> {
  int edits = 0;
  @override
  void initState() {
    super.initState();
    widget.onMount();
  }

  @override
  Widget build(BuildContext context) => TextButton(
    key: const ValueKey('edit_destination'),
    onPressed: () => setState(() => edits++),
    child: Text('Edits: $edits'),
  );
}

void main() {
  late ConnectivityCubit status;
  late FeedbackCoordinator feedback;
  setUp(() {
    status = ConnectivityCubit();
    feedback = FeedbackCoordinator(AppLogger());
  });
  tearDown(() async {
    await status.close();
    await feedback.close();
  });

  Widget host(Widget child, {Locale locale = const Locale('en')}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: status),
        BlocProvider.value(value: feedback),
      ],
      child: MaterialApp(
        builder: (context, child) =>
            SharedFeedbackHost(child: child ?? const SizedBox.shrink()),
        theme: AppTheme.light,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AppShell(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          onOpenInbox: () {},
          onOpenProfile: () {},
          child: child,
        ),
      ),
    );
  }

  testWidgets(
    'status and feedback updates preserve destination edits and mount lifetime',
    (tester) async {
      var mounts = 0;
      await tester.pumpWidget(host(_Destination(() => mounts++)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('edit_destination')));
      await tester.pumpAndSettle();
      final updates = <VoidCallback>[
        () => status.setNetworkState(NetworkState.offline),
        () => feedback.publish(
          const FeedbackDescriptor(
            id: 'notice',
            kind: FeedbackKind.information,
            message: 'Saved',
          ),
        ),
        () => feedback.publish(
          const FeedbackDescriptor(
            id: 'failure',
            kind: FeedbackKind.recoverableError,
            message: 'Unable to save',
          ),
        ),
        feedback.dismissTransient,
        () => status.setNetworkState(NetworkState.online),
      ];
      for (final update in updates) {
        update();
        await tester.pumpAndSettle();
        expect(mounts, 1);
        expect(find.text('Edits: 1'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
      expect(feedback.state.activeTransient, isNull);
    },
  );

  testWidgets(
    'a scrolling destination gets a bounded independent viewport in compact RTL with large text',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      final controller = ScrollController();
      addTearDown(() async {
        controller.dispose();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
        await tester.binding.setSurfaceSize(null);
      });
      status.setNetworkState(NetworkState.offline);
      await tester.pumpWidget(
        host(
          ListView.builder(
            key: const ValueKey('destination_list'),
            controller: controller,
            itemCount: 50,
            itemBuilder: (_, index) =>
                SizedBox(height: 60, child: Text('Row $index')),
          ),
          locale: const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();
      feedback.publish(
        const FeedbackDescriptor(
          id: 'notice',
          kind: FeedbackKind.information,
          message: 'Saved',
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(const ValueKey('shell_status_banner_offline')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('transient_feedback_card')),
        findsOneWidget,
      );
      await tester.drag(
        find.byKey(const ValueKey('destination_list')),
        const Offset(0, -250),
      );
      await tester.pumpAndSettle();
      expect(controller.offset, greaterThan(0));
      expect(feedback.state.activeTransient?.id, 'notice');
      expect(tester.takeException(), isNull);
    },
  );
}
