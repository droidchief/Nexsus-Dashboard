import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/analytics_repository.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsBloc(this._repository) : super(AnalyticsInitial()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<RefreshAnalytics>(_onRefreshAnalytics);
  }

  Future<void> _onLoadAnalytics(
    LoadAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final data = await _repository.getAnalytics();
      emit(AnalyticsLoaded(data));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> _onRefreshAnalytics(
    RefreshAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    if (state is AnalyticsLoaded) {
      final currentData = (state as AnalyticsLoaded).data;
      emit(AnalyticsLoaded(currentData, isRefreshing: true));
    }

    try {
      final data = await _repository.refreshAnalytics();
      emit(AnalyticsLoaded(data));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }
}