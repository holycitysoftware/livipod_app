import 'package:flutter/material.dart';
import 'package:livipod_app/views/devices_view.dart';

class HomTabView extends StatefulWidget {
  const HomTabView({super.key});

  @override
  State<HomTabView> createState() => _HomTabViewState();
}

class _HomTabViewState extends State<HomTabView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LiviPod')),
      body: _getPage(),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Devices')
        ],
        selectedIndex: _index,
        onDestinationSelected: (value) {
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
        return DevicesView();
      default:
        return Placeholder();
    }
  }
}
