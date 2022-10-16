import 'package:app/TabPages/find_doctor_screen.dart';
import 'package:app/TabPages/history_screen.dart';
import 'package:app/TabPages/subscription_screen.dart';
import 'package:app/main_screen/user_dashboard.dart';
import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget
{
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin
{
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index)
  {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children:  const [
          UserDashboard(),
          HistoryScreen(),
          FindDoctor(),
          SubscriptionScreen(),
          UserDashboard(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Find Doctor",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: "Subscription",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "More",
          ),

        ],

        unselectedItemColor: Colors.black12,
        selectedItemColor: Colors.lightBlueAccent,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),

    );
  }
}
