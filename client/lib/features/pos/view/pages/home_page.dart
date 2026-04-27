import 'package:client/features/pos/view/pages/analytics_page.dart';
import 'package:client/features/pos/view/pages/pos_page.dart';
import 'package:client/features/pos/view/pages/products_page.dart';
import 'package:client/features/pos/view/pages/today_report_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final pages = const [
    PosPage(),
    ProductsPage(),
    AnalyticsPage(),
    TodayReportPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale), label: "POS"),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory), label: "Products"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "Today"), //
        ],
      ),
    );
  }
}
