import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

class UpdateAttendanceStats extends HomeEvent {
  final DateTime date;

  const UpdateAttendanceStats({required this.date});

  @override
  List<Object?> get props => [date];
}