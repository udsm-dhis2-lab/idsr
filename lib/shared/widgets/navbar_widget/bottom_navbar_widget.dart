import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  int currentIndexItem;

  BottomNavBar({Key? key, this.currentIndexItem = 0}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  void onTapNavBarItem(int itemIndex) {
    setState(() {
      currentIndex = itemIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: onTapNavBarItem,
      currentIndex: currentIndex,
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.grey.withOpacity(0.5),
      // elevation: 5,
      items: [
        BottomNavigationBarItem(
            label: 'Tools', icon: Icon(Icons.description_outlined)),
        BottomNavigationBarItem(
            label: 'Summary', icon: Icon(Icons.bar_chart_rounded)),
        BottomNavigationBarItem(
            label: 'Notification', icon: Icon(Icons.notifications_rounded)),
        BottomNavigationBarItem(label: 'Sync', icon: Icon(Icons.sync_rounded))
      ],
    );
  }
}
