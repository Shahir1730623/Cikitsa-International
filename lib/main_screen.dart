import 'package:app/TabPages/history_screen.dart';
import 'package:app/TabPages/subscription_screen.dart';
import 'package:app/common_screens/coundown_screen.dart';
import 'package:app/main_screen/user_dashboard.dart';
import 'package:app/our_services/doctor_live_consultation/live_consultation_category.dart';
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
          LiveConsultationCategory(),
          SubscriptionScreen(),
          CountDownScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 35),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/NavigationBarItem/clipboard.png",
              height: 30,
            ),
            label: "History",
          ),

          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/NavigationBarItem/doctor.png",
              height: 30,
            ),
            label: "Find Doctor",
          ),

          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/NavigationBarItem/subscription.png",
              height: 30,
            ),
            label: "Subscription",
          ),

          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/NavigationBarItem/menu.png",
              height: 30,
            ),
            label: "More",
          ),

        ],

        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.lightBlueAccent,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 13),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),

    );
  }
}
