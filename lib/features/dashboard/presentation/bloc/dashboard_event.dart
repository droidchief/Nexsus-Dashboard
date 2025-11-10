import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class SelectModule extends DashboardEvent {
  final String moduleId;

  const SelectModule(this.moduleId);

  @override
  List<Object?> get props => [moduleId];
}