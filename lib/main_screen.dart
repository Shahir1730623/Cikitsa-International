import 'package:app/TabPages/history_screen.dart';
import 'package:app/TabPages/subscription_screen.dart';
import 'package:app/common_screens/coundown_screen.dart';
import 'package:app/main_screen/user_dashboard.dart';
import 'package:app/main_screen/user_profile_screen.dart';
import 'package:app/our_services/ci_consultation/ci_consultation_dashboard.dart';
import 'package:app/our_services/doctor_live_consultation/live_consultation_category.dart';
import 'package:app/our_services/doctor_live_consultation/video_consultation_dashboard.dart';
import 'package:app/our_services/online_pharmacy/pharmacy_dashboard.dart';
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
          CIConsultationDashboard(),
          VideoConsultationDashboard(),
          PharmacyDashboard(),
          UserProfileScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              size: 30,
              AssetImage(
                "assets/NavigationBarItem/home.png",
              ),
            ),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: ImageIcon(
              size: 30,
              AssetImage(
                "assets/NavigationBarItem/operator.png",
              ),
            ),
            label: "Consult",
          ),

          BottomNavigationBarItem(
            icon: ImageIcon(
              size: 30,
              AssetImage(
                "assets/NavigationBarItem/doctor.png",
              ),
            ),
            label: "Find Doctor",
          ),

          BottomNavigationBarItem(
            icon: ImageIcon(
              size: 30,
              AssetImage(
                "assets/NavigationBarItem/medicine.png",
              ),
            ),
            label: "Medicine",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              size: 30,
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
