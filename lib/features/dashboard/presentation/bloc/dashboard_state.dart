import 'package:equatable/equatable.dart';
import '../../../../core/interfaces/i_module.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<IModule> modules;
  final IModule? selectedModule;

  const DashboardLoaded({
    required this.modules,
    this.selectedModule,
  });

  @override
  List<Object?> get props => [modules, selectedModule];
}
