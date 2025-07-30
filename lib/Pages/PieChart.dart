import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Auth/Auth_Cudit.dart';
import '../Auth/Auth_State.dart';

class ExpensePieChart extends StatefulWidget {
  final String period;

  const ExpensePieChart({super.key, required this.period});

  @override
  _ExpensePieChartState createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int? _touchedIndex;
  List<Map<String, dynamic>> _expenseData = [];
  final List<String> _allCategories = [
    'الطعام والشراب',
    'الإيجار أو السكن',
    'المواصلات',
    'الصحة',
    'التسوق والملابس',
    'أخرى',
  ];
  final Map<String, Color> _categoryColors = {
    'الطعام والشراب': Colors.red,
    'الإيجار أو السكن': Colors.blue,
    'المواصلات': Colors.green,
    'الصحة': Colors.orange,
    'التسوق والملابس': Colors.purple,
    'أخرى': Colors.grey,
  };

  @override
  void initState() {
    super.initState();
    _loadExpenseData();
  }

  Future<void> _loadExpenseData() async {
  final authCubit = context.read<AuthCubit>();
  final data = await authCubit.fetchExpenseDataForPeriod(widget.period);

  final Map<String, double> expensesByCategory = {};
  for (var category in _allCategories) {
    expensesByCategory[category] = 0.0;
  }

  for (var entry in data) {
    expensesByCategory[entry['name']] = (entry['total'] as num).toDouble();
  }

  // Filter only categories with total > 0
  final filteredData = expensesByCategory.entries
      .where((entry) => entry.value > 0)
      .map((entry) => {'name': entry.key, 'total': entry.value})
      .toList();

  setState(() {
    _expenseData = filteredData;
  });
}

  List<PieChartSectionData> _generatePieSections() {
  if (_expenseData.isEmpty) return [];

  final total = _expenseData.fold<double>(
    0.0,
    (sum, item) => sum + (item['total'] as num).toDouble(),
  );

  if (total == 0) return [];

  return _expenseData.map((entry) {
    final value = (entry['total'] as num).toDouble();
    final percentage = value / total * 100;
    final color = _categoryColors[entry['name']] ?? Colors.grey;

    return PieChartSectionData(
      color: color,
      value: value,
      title: percentage < 2 ? '' : '${percentage.toStringAsFixed(1)}%',
      radius: _touchedIndex == _expenseData.indexOf(entry) ? 60 : 50,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }).toList();
}
  
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          _loadExpenseData(); 
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 50,
                  sections: _generatePieSections(),
                  sectionsSpace: 4,
                  pieTouchData: PieTouchData(
                    enabled: true,
                    touchCallback: (
                      FlTouchEvent event,
                      PieTouchResponse? response,
                    ) {
                      if (response?.touchedSection == null) {
                        setState(() {
                          _touchedIndex = null;
                        });
                        return;
                      }

                      if (event is FlTapUpEvent) {
                        setState(() {
                          _touchedIndex =
                              response!.touchedSection!.touchedSectionIndex;
                        });
                      } else {
                        setState(() {
                          _touchedIndex = null;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            if (_touchedIndex != null &&
                _touchedIndex! >= 0 &&
                _touchedIndex! < _expenseData.length) ...[
              if (_expenseData[_touchedIndex!]['total'] as num > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    ' ${_expenseData[_touchedIndex!]['name']} - ${_expenseData[_touchedIndex!]['total']} دل',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}
