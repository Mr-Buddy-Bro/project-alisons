import 'package:flutter/material.dart';
import 'package:project_alisons/config/routes/router.dart';
import 'package:project_alisons/config/theme/app_theme.dart';

void main(){
  runApp(const MachineTask());
}


class MachineTask extends StatelessWidget {
  const MachineTask({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Machine Task',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}