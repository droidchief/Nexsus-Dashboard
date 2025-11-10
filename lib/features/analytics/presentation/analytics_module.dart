import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/interfaces/i_module.dart';
import '../../../core/di/injection.dart';
import 'bloc/analytics_bloc.dart';
import 'bloc/analytics_event.dart';
import 'pages/analytics_page.dart';

class AnalyticsModule implements IModule {
  @override
  String get id => 'analytics';

  @override
  String get title => 'Analytics';

  @override
  IconData get icon => Icons.analytics_outlined;

  @override
  Color get color => const Color(0xFFFF9800);

  @override
  String getRoute() => '/analytics';

  @override
  int get priority => 3;

  @override  
  Widget getWidget() {
    return BlocProvider(
      create: (_) => getIt<AnalyticsBloc>()..add(LoadAnalytics()),
      child: const AnalyticsPage(),
    );
  }
}