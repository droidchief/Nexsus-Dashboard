import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/interfaces/i_module.dart';
import '../../../core/di/injection.dart';
import 'bloc/notes_bloc.dart';
import 'bloc/notes_event.dart';
import 'pages/notes_page.dart';

class NotesModule implements IModule {
  @override
  String get id => 'notes';

  @override
  String get title => 'Notes';

  @override
  IconData get icon => Icons.note_alt_outlined;

  @override
  Color get color => const Color(0xFF4CAF50);

  @override
  String getRoute() => '/notes';

  @override
  int get priority => 1;

  @override
  Widget getWidget() {
    return BlocProvider(
      create: (_) => getIt<NotesBloc>()..add(LoadNotes()),
      child: const NotesPage(),
    );
  }
}