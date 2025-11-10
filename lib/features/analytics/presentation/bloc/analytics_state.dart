import 'package:equatable/equatable.dart';
import '../../domain/entities/analytics_data.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsData data;
  final bool isRefreshing;

  const AnalyticsLoaded(this.data, {this.isRefreshing = false});

  @override
  List<Object?> get props => [data, isRefreshing];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}