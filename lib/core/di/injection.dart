import 'package:get_it/get_it.dart';
import '../../features/analytics/domain/repositories/analytics_repository.dart';
import '../../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../../features/analytics/presentation/bloc/analytics_bloc.dart';
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

  // Repositories
  getIt.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(getIt()),
  );

  // BLoCs
  getIt.registerFactory(() => AnalyticsBloc(getIt()));
}