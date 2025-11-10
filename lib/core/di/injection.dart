import 'package:get_it/get_it.dart';
import 'package:nexus_dashboard/features/chats/data/repositories/chat_repository_impl.dart';
import 'package:nexus_dashboard/features/chats/domain/repositories/chat_repository.dart';
import 'package:nexus_dashboard/features/chats/presentation/bloc/chat_bloc.dart';
import '../../features/notes/domain/repositories/note_repository.dart';
import '../../features/notes/data/repositories/note_repository_impl.dart';
import '../../features/notes/presentation/bloc/notes_bloc.dart';

import '../../features/analytics/domain/repositories/analytics_repository.dart';
import '../../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../../features/analytics/presentation/bloc/analytics_bloc.dart';
import '../../features/dashboard/data/module_registry.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../storage/local_storage.dart';
import '../storage/sync_manager.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core
  final localStorage = LocalStorage();
  await LocalStorage.init();
  getIt.registerSingleton<LocalStorage>(localStorage);

  final syncManager = SyncManager(localStorage);
  await syncManager.init();
  getIt.registerSingleton<SyncManager>(syncManager);

  // Module Registry
  getIt.registerSingleton<ModuleRegistry>(ModuleRegistry());

  // Repositories
  getIt.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(getIt()),
  );

  // BLoCs
  getIt.registerFactory(() => NotesBloc(getIt()));
  getIt.registerFactory(() => ChatBloc(getIt()));
  getIt.registerFactory(() => AnalyticsBloc(getIt()));
  getIt.registerFactory(() => DashboardBloc(getIt()));
}
