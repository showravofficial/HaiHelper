import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetOverviewScreen extends StatelessWidget {
  const BudgetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B6EF6).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF7B6EF6),
                        size: 24.w,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Budget Overview',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: const Color(0xFF7B6EF6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),

            // Budget Charts
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BudgetSection(
                      title: 'Core Supports',
                      data: [
                        BudgetData('Conventions', 40, const Color(0xFF7EE0C4)),
                        BudgetData('Online Advertising', 24, const Color(0xFFFF8080)),
                        BudgetData('Print Advertising', 20, const Color(0xFF808080)),
                        BudgetData('Sales Training', 16, const Color(0xFFFFD699)),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    _BudgetSection(
                      title: 'Capacity Building',
                      data: [
                        BudgetData('Conventions', 40, const Color(0xFF7EE0C4)),
                        BudgetData('Online Advertising', 24, const Color(0xFFFF8080)),
                        BudgetData('Print Advertising', 20, const Color(0xFF808080)),
                        BudgetData('Sales Training', 16, const Color(0xFFFFD699)),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    _BudgetSection(
                      title: 'Capital Supports',
                      data: [
                        BudgetData('Conventions', 40, const Color(0xFF7EE0C4)),
                        BudgetData('Online Advertising', 24, const Color(0xFFFF8080)),
                        BudgetData('Print Advertising', 20, const Color(0xFF808080)),
                        BudgetData('Sales Training', 16, const Color(0xFFFFD699)),
                      ],
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetSection extends StatelessWidget {
  final String title;
  final List<BudgetData> data;

  const _BudgetSection({
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 360.w;
            return Column(
              children: [
                Center(
                  child: SizedBox(
                    height: isSmallScreen ? 150.h : 180.h,
                    width: isSmallScreen ? 150.w : 180.w,
                    child: PieChart(
                      PieChartData(
                        sections: data
                            .map((item) => PieChartSectionData(
                                  value: item.percentage.toDouble(),
                                  color: item.color,
                                  title: '${item.percentage}%',
                                  radius: isSmallScreen ? 70.r : 85.r,
                                  titleStyle: TextStyle(
                                    fontSize: isSmallScreen ? 10.sp : 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  titlePositionPercentageOffset: 0.55,
                                  showTitle: true,
                                  borderSide: BorderSide.none,
                                ))
                            .toList(),
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        startDegreeOffset: 270,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 16.w,
                  runSpacing: 8.h,
                  children: data.map((item) => _buildLegendItem(item)).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLegendItem(BudgetData item) {
    return SizedBox(
      width: 140.w,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.w,
            height: 10.h,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetData {
  final String name;
  final int percentage;
  final Color color;

  const BudgetData(this.name, this.percentage, this.color);
} 