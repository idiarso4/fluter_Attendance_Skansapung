import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import '../widgets/attendance_stats_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/quick_actions.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeError) {
                return Center(child: Text(state.message));
              }
              if (state is HomeLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(LoadHomeData());
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ProfileHeader(),
                              const SizedBox(height: 24),
                              Text(
                                'Dashboard',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 16),
                              AttendanceStatsCard(
                                monthlyStats: state.monthlyStats,
                                weeklyStats: state.weeklyStats,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Quick Actions',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              const QuickActions(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}