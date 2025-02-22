import 'package:equatable/equatable.dart';
import '../models/attendance_stats.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final AttendanceStats monthlyStats;
  final AttendanceStats weeklyStats;

  const HomeLoaded({
    required this.monthlyStats,
    required this.weeklyStats,
  });

  @override
  List<Object?> get props => [monthlyStats, weeklyStats];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}