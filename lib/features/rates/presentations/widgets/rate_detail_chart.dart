import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:egp_rate_tracker/core/theme/app_colors.dart';
import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/core/theme/app_text_styles.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';

/// 7-day historical exchange rate line chart using fl_chart.
///
/// Features:
/// - Curved line with smooth gradient fill fading to transparent
/// - Minimal grid lines
/// - Bottom titles labeled ONLY for first, last, min rate, and max rate points
class RateDetailChart extends StatelessWidget {
  const RateDetailChart({
    super.key,
    required this.points,
    required this.isPositiveChange,
    required this.isNegativeChange,
  });

  final List<HistoricalRatePoint> points;
  final bool isPositiveChange;
  final bool isNegativeChange;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Color Selection ──────────────────────────────────────────────────
    final Color lineColor;
    if (isPositiveChange) {
      lineColor = isDark ? AppColors.negativeDark : AppColors.negative;
    } else if (isNegativeChange) {
      lineColor = isDark ? AppColors.positiveDark : AppColors.positive;
    } else {
      lineColor = isDark ? AppColors.primaryLight : AppColors.primary;
    }

    // ── Find Min & Max Points ────────────────────────────────────────────
    int minIndex = 0;
    int maxIndex = 0;
    for (int i = 1; i < points.length; i++) {
      if (points[i].rate < points[minIndex].rate) minIndex = i;
      if (points[i].rate > points[maxIndex].rate) maxIndex = i;
    }

    // Indices that should show a date label on the X axis
    final labeledIndices = {
      0, // first
      points.length - 1, // last
      minIndex, // min point
      maxIndex, // max point
    };

    // Y axis min/max padding
    final minRate = points[minIndex].rate;
    final maxRate = points[maxIndex].rate;
    final padding = (maxRate - minRate) * 0.15;
    final minY = (minRate - (padding == 0 ? 0.5 : padding));
    final maxY = (maxRate + (padding == 0 ? 0.5 : padding));

    final flSpots = List.generate(
      points.length,
      (i) => FlSpot(i.toDouble(), points[i].rate),
    );

    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.only(
          right: AppSpacing.lg,
          left: AppSpacing.sm,
          top: AppSpacing.md,
          bottom: AppSpacing.xs,
        ),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            minX: 0,
            maxX: (points.length - 1).toDouble(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: (maxY - minY) / 3,
              getDrawingHorizontalLine: (value) => FlLine(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= points.length) return const SizedBox.shrink();

                    // Only show label for first, last, min, max indices
                    if (!labeledIndices.contains(index)) {
                      return const SizedBox.shrink();
                    }

                    final date = points[index].date;
                    final formattedDate = DateFormat('d/M').format(date);

                    return Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        formattedDate,
                        style: AppTextStyles.caption.copyWith(
                          color: index == minIndex || index == maxIndex
                              ? lineColor
                              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          fontWeight: index == minIndex || index == maxIndex
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: flSpots,
                isCurved: true,
                curveSmoothness: 0.35,
                color: lineColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, barData) {
                    final index = spot.x.toInt();
                    // Show dots on min, max, first, and last points
                    return labeledIndices.contains(index);
                  },
                  getDotPainter: (spot, percent, barData, index) {
                    final spotIndex = spot.x.toInt();
                    final isHighlighted = spotIndex == minIndex || spotIndex == maxIndex;

                    return FlDotCirclePainter(
                      radius: isHighlighted ? 5 : 3.5,
                      color: lineColor,
                      strokeWidth: isHighlighted ? 2 : 1,
                      strokeColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      lineColor.withValues(alpha: 0.35),
                      lineColor.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
