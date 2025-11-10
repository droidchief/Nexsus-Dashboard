import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/module_registry.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ModuleRegistry _registry;

  DashboardBloc(this._registry) : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<SelectModule>(_onSelectModule);
  }

  void _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) {
    _registry.registerModules();
    emit(DashboardLoaded(modules: _registry.modules));
  }

  void _onSelectModule(SelectModule event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final module = _registry.getModuleById(event.moduleId);
      
      emit(DashboardLoaded(
        modules: currentState.modules,
        selectedModule: module,
      ));
    }
  }
}