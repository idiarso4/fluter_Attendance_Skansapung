import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../models/attendance_stats.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) => _onLoadHomeData(event, emit));
    on<RefreshHomeData>((event, emit) => _onRefreshHomeData(event, emit));
    on<UpdateAttendanceStats>((event, emit) => _onUpdateAttendanceStats(event, emit));
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading());
      
      // Initialize with empty stats until data is loaded from repository
      final monthlyStats = AttendanceStats.empty();
      final weeklyStats = AttendanceStats.empty();
      
      emit(HomeLoaded(
        monthlyStats: monthlyStats,
        weeklyStats: weeklyStats,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onRefreshHomeData(RefreshHomeData event, Emitter<HomeState> emit) async {
    await _onLoadHomeData(LoadHomeData(), emit);
  }

  Future<void> _onUpdateAttendanceStats(UpdateAttendanceStats event, Emitter<HomeState> emit) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeLoading());
        
        // TODO: Update stats based on the new attendance date
        // For now, keeping the current stats
        emit(HomeLoaded(
          monthlyStats: currentState.monthlyStats,
          weeklyStats: currentState.weeklyStats,
        ));
      }
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}