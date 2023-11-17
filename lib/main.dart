import 'package:flutter/material.dart';
import 'package:livipod_app/views/devices_view.dart';
import 'package:livipod_app/views/home_tab_view.dart';
import 'package:provider/provider.dart';

import 'controllers/devices_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final DevicesController devicesController = DevicesController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => devicesController,
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomTabView(),
        ));
  }
}
