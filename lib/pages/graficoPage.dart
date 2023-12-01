import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Despesas por Categoria'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<DocumentSnapshot>>(
            future: getExpenseDataFromFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Nenhum dado de despesa disponível.');
              } else {
                List<DocumentSnapshot> expenseData = snapshot.data!;
                Map<String, double> categoryPercentages =
                    calculateCategoryPercentages(expenseData);

                return ExpenseChart(categoryPercentages);
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> getExpenseDataFromFirebase() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('despesas').get();
    return querySnapshot.docs;
  }

  Map<String, double> calculateCategoryPercentages(
      List<DocumentSnapshot> expenseData) {
    Map<String, double> categoryPercentages = {};

    for (var expense in expenseData) {
      String category = expense['categoria'] ?? 'Outra';
      double valor = (expense['valor'] ?? 0.0).toDouble();

      if (categoryPercentages.containsKey(category)) {
        categoryPercentages[category] = categoryPercentages[category]! + valor;
      } else {
        categoryPercentages[category] = valor;
      }
    }
    double total =
        categoryPercentages.values.reduce((value, element) => value + element);
    categoryPercentages.forEach((key, value) {
      categoryPercentages[key] = (value / total) * 100;
    });

    return categoryPercentages;
  }
}

class ExpenseChart extends StatelessWidget {
  final Map<String, double> categoryPercentages;

  ExpenseChart(this.categoryPercentages);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: getCategorySections(),
          centerSpaceRadius: 40,
          sectionsSpace: 0,
          pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {}),
        ),
      ),
    );
  }

  List<PieChartSectionData> getCategorySections() {
    List<PieChartSectionData> sections = [];
    double total =
        categoryPercentages.values.reduce((value, element) => value + element);

    int index = 0;
    categoryPercentages.forEach((category, percentage) {
      sections.add(
        PieChartSectionData(
          color: getColor(index),
          value: percentage,
          title: '$percentage%',
          radius: 100,
          titleStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
      index++;
    });

    return sections;
  }

  Color getColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple
    ];
    return colors[index % colors.length];
  }
}
