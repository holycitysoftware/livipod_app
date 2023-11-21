import 'package:flutter/material.dart';
import 'package:livipod_app/views/devices_view.dart';

import 'livi_pods_view.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LiviPod')),
      body: _getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: 'Pods'),
          BottomNavigationBarItem(
              icon: Icon(Icons.wifi_find), label: 'Discover')
        ],
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
      ),
    );
  }

  Widget _getPage() {
    switch (_index) {
      case 0:
        return Placeholder();
      case 1:
        return LiviPodsView();
      case 2:
        return DevicesView();
      default:
        return Placeholder();
    }
  }
}
