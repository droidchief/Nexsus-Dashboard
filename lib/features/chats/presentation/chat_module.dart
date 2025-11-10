import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/interfaces/i_module.dart';
import '../../../core/di/injection.dart';
import 'bloc/chat_bloc.dart';
import 'bloc/chat_event.dart';
import 'pages/chat_page.dart';

class ChatModule implements IModule {
  @override
  String get id => 'chat';

  @override
  String get title => 'AI Chat';

  @override
  IconData get icon => Icons.chat_bubble_outline;

  @override
  Color get color => const Color(0xFF2196F3);

  @override
  String getRoute() => '/chat';

  @override
  int get priority => 2;

  @override
  Widget getWidget() {
    return BlocProvider(
      create: (_) => getIt<ChatBloc>()..add(LoadMessages()),
      child: const ChatPage(),
    );
  }
}