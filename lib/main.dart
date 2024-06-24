// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_alarm_background_trigger/flutter_alarm_background_trigger.dart';
import 'package:med_remainder/source/med_details.dart';
import 'dart:core';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';



import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:timezone/timezone.dart' as tz;


import 'pages/homepage.dart';
import 'functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemAlertWindow.requestPermissions;

  //await SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
  FlutterAlarmBackgroundTrigger.initialize();

  await AndroidAlarmManager.initialize();
  
  runApp( MyApp());
}



class MyApp extends StatefulWidget {
   

    const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
     super.initState();
     
    
     
  }





  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
         // navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Med Reminder',
          home: HomePage(),
        );
  }
}