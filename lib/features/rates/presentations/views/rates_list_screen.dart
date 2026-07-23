import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:egp_rate_tracker/core/router/routes.dart';
import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/core/widgets/empty_view.dart';
import 'package:egp_rate_tracker/core/widgets/error_view.dart';
import 'package:egp_rate_tracker/core/widgets/skeleton_loading.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_state.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_list_item.dart';

/// Main screen displaying the list of currency exchange rates against EGP.
class RatesListScreen extends StatelessWidget {
  const RatesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('rates_list_title'.tr()),
      ),
      body: BlocBuilder<RatesCubit, RatesState>(
        builder: (context, state) {
          return state.when(
            initial: () => const RatesListSkeleton(),
            loading: () => const RatesListSkeleton(),
            empty: () => const EmptyView(),
            error: (message) => ErrorView(
              message: message,
              onRetry: () => context.read<RatesCubit>().fetchRates(),
            ),
            success: (rates, isRefreshing) {
              return RefreshIndicator(
                onRefresh: () => context.read<RatesCubit>().fetchRates(isRefresh: true),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  itemCount: rates.length,
                  itemBuilder: (context, index) {
                    final rate = rates[index];
                    return RateListItem(
                      rate: rate,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.rateDetail,
                          arguments: rate,
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
