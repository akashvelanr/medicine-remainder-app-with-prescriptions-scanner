// ignore_for_file: unused_import




import 'dart:convert';
import 'dart:ffi';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_alarm_background_trigger/flutter_alarm_background_trigger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med_remainder/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:system_alert_window/utils/constants.dart';
import 'package:timezone/data/latest.dart' as tz ;
import 'package:image_picker/image_picker.dart';
import 'package:med_remainder/pages/edit_medicine.dart';
import 'package:med_remainder/pages/scan/scanpage.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

import 'package:camera/camera.dart';
import 'package:med_remainder/functions.dart';
import 'package:med_remainder/source/med_details.dart';
import './pages/add_med.dart';
import 'package:timezone/timezone.dart' as tz;







String namef=r'(?:Tab|cap|syp)|(\d+mg)|(?:\d+%)';
String dosagef=r'.(?: (morn|mom|morm|nigh|night|noon|eve)(\w+)?(?: \w+)?)|\d+ (tab|cap)';
String timef=r'(?:once|twice|\d+ times) (?:a|every) (\w+(?: \w+)*)|(?:(before|after) food)';
String durationf=r'(for (\d+)|\d+ (days|day|davs|week)|\d+( )?d)(?: (\w+))?';
String uwantf=r'tot';

List<Medicine> scanmedicines=[];





String _setname(line) {
 String set='';

 set = line;

 return set.toString();
}



String? _setdosage(String line) {

 String set='';
 RegExp regExp =RegExp(r'\d+|\d+/\d+');
 RegExpMatch match = regExp.firstMatch(line)!;
 print (match[0]);
 set= '${match[0]}';
 return set;
}



String _setduration(String line) {
 String set='';
 RegExp regExp=RegExp(r'\d+');
 RegExpMatch match = regExp.firstMatch(line)!;
 if(line.toLowerCase().contains('week'))
 {
  set='${int.parse(match[0]!)*7} days';}
 else
 {set='${match[0]} days';}
 
 return set;
}


List<Medicine> parseMedicines(String text) {

  int mn = 0;
  int md = 0;
  int mf = 0;
  int mdu = 0;
 
 
  List<String> lines = text.split('\n');
  //int startIndex = lines.indexOf('Medicine Name');
    RegExp medicationNamePattern = RegExp(namef, caseSensitive: false);
    RegExp dosagePattern = RegExp(dosagef, caseSensitive: false);
    RegExp frequencyPattern = RegExp(timef, caseSensitive: false);
    RegExp durationPattern = RegExp(durationf, caseSensitive: false);
    RegExp unwantPattern = RegExp(uwantf, caseSensitive: false);
    
    int startIndex = lines.indexWhere((note) => note.toLowerCase().startsWith('medicine')||note.toLowerCase().startsWith('dosage'));
   if (startIndex == -1){ startIndex=0;};
    //print(startIndex);
    for (int i=startIndex ; i<lines.length;i++)
    {
      
      Iterable<RegExpMatch> medicationNameMatches = medicationNamePattern.allMatches(lines[i]);
      Iterable<RegExpMatch> dosageMatches = dosagePattern.allMatches(lines[i]);
      Iterable<RegExpMatch> frequencyMatches = frequencyPattern.allMatches(lines[i]);
      Iterable<RegExpMatch> durationMatches = durationPattern.allMatches(lines[i]);
      Iterable<RegExpMatch> unwantMatches = unwantPattern.allMatches(lines[i]);


      print(lines[i]);
      // print(medicationNameMatches);
      try {
       
      if (medicationNameMatches.isNotEmpty && lines[i].length<30 && 
      durationMatches.isEmpty&& dosageMatches.isEmpty&&unwantMatches.isEmpty&&
      lines[i].toLowerCase()!='capsule'&&lines[i].toLowerCase()!='tablet'&&lines[i].startsWith(RegExp(r'\d+'))) {
        //print('mn $mn');
       //print(lines[i]);
        if(mn>=md &&mn>=mf&&mn>=mdu)
        {
         // print(2);
        scanmedicines.add(Medicine(name:_setname(lines[i]), dosage: '', time: '', duration: '',startdate: null));
        mn++;
        }
        else{
          //print(3);
          scanmedicines[mn].name=_setname( lines[i]);
          mn++;
        }
       // print('ml nam :${medicines.length}');
      }} catch(e){print("error:$e");}

      try {
       if (dosageMatches.isNotEmpty&&unwantMatches.isEmpty) {
        // print('md $md');
        //print(medicationNameMatches);
        if(md>=mn &&md>=mf&&md>=mdu)
        {
          //print('finded');
        scanmedicines.add(Medicine(name:'', dosage:lines[i], time: '', duration: '',startdate: null));
        md++;
        }
        else{
        //   print('add finded');
        //  print(dosageMatches.first.group(1));
          scanmedicines[md].dosage=lines[i];
          md++;
        }

       // print('ml dos :${scanmedicines.length}');
      
      }} catch(e){print("error:$e");}


      try {
       
      if (frequencyMatches.isNotEmpty) {
        //print('mn $mn');
       // print(lines[i]);
        if(mf>=mn &&mf>=md&&mf>=mdu)
        {
         // print(2);
        scanmedicines.add(Medicine(name:'', dosage: '', time:lines[i], duration: '',startdate: null));
        mf++;
        }
        else{
          //print(3);
          scanmedicines[mf].time=lines[i];
          mf++;
        }
       // print('ml nam :${scanmedicines.length}');
      }} catch(e){print("error:$e");}


       try {
       
      if (durationMatches.isNotEmpty&&lines[i].length<20) {
        print('mn $mn');
        print(lines[i]);
        if(mdu>=mn &&mdu>=md&&mdu>=mf)
        {
         // print(2);
         scanmedicines.add(Medicine(name:'', dosage: '', time:'', duration: _setduration( lines[i]),startdate: null));
         mdu++;
        }
        else{
          //print(3);
          scanmedicines[mdu].duration= _setduration(lines[i]);
          mdu++;
        }
       // print('ml nam :${scanmedicines.length}');
      }} catch(e){print("error:$e");}




    }
    
    
    for ( var medicine in scanmedicines) {
        try{
         
        medicine.time=_settime(medicine.dosage!,medicine.time!);
        medicine.dosage=_setdosage(medicine.dosage!);
        medicine.startdate= DateTime.now();
        } catch  (e) {print(e);}
    }


  // print('ml ret :${scanmedicines.length}');
  return scanmedicines;
}


String? _settime(String dosage,String time){

  print(dosage);print(time);
  String set='';
  if(dosage.toLowerCase().contains('mo')){set+='Morning ';}
  if(dosage.toLowerCase().contains('aft')){set+='Afternoon ';}
  if(dosage.toLowerCase().contains('nig')){set+='Night ';}
  if(time.toLowerCase().contains('bef')||time.toLowerCase().contains('ter fo')){set+='\n';}
  if(time.toLowerCase().contains('bef')){set+='BeforeFood ';}
  if(time.toLowerCase().contains('ter fo')){set+='AfterFood';}
  

  return set;
}




void initializeNotifications() {
  AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  
  InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();

}




Future<void> scheduleNotification(String title, String body, DateTime dateTime) async {
 try{
  int id= '${title}_${dateTime.month}_${dateTime.day}_${dateTime.hour}'.hashCode;
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '$title ${dateTime.month} ${dateTime.day} ${dateTime.hour}',
    'your_channel_name',
     channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    
  );
  print(id);
  print(dateTime);
  print(DateTime.now());
  tz.initializeTimeZones();
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,

    
    tz.TZDateTime.from(dateTime, tz.local),
    platformChannelSpecifics,
    // ignore: deprecated_member_use
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    
  );} catch (e){ print('error:$e');}

  print("tz time ${tz.TZDateTime.from(dateTime,tz.local)}");
  print(tz.local);
}


Future<void> scheduleMedicineNotification(Medicine medicine, {Medicine? oldMedicine}) async {
  if (oldMedicine != null) {
    await cancelOldNotifications(oldMedicine);
  }
  
  DateTime? startDate = medicine.startdate;
  int days = medicine.duration == 'everyday' ? 30 : int.parse(medicine.duration!.split(' ')[0]);
     print('schdule med ${medicine.name}');
     int c= 0;
  for (int i = 0; i < days; i++) {
    if (medicine.time!.contains('Morning')) { 
      DateTime notificationDateTime = DateTime(startDate!.year, startDate.month, startDate.day + i, morningTime.hour,morningTime.minute);
      
      String? food =medicine.time!.contains('food')? medicine.time!.split('\n')[1]:null;
      String ftext = food==null? '':'at $food';
      
      await scheduleNotification(medicine.name!, 'Take ${medicine.dosage} $ftext', notificationDateTime);
      c++; print('No $c');
    }
    if (medicine.time!.contains('Afternoon')) { 
      DateTime notificationDateTime = DateTime(startDate!.year, startDate.month, startDate.day + i, afternoonTime.hour,afternoonTime.minute);
      String? food =medicine.time!.contains('food')? medicine.time!.split('\n')[1]:null;
      String ftext = food==null? '':'at $food';
      await scheduleNotification(medicine.name!, 'Take ${medicine.dosage} $ftext', notificationDateTime);     
      c++; print('No $c');
    }
    if (medicine.time!.contains('Night')) { 
      DateTime notificationDateTime = DateTime(startDate!.year, startDate.month, startDate.day + i, nightTime.hour,nightTime.minute);
       String? food =medicine.time!.contains('food')? medicine.time!.split('\n')[1]:null;
      String ftext = food==null? '':'at $food';
      await scheduleNotification(medicine.name!, 'Take ${medicine.dosage} $ftext', notificationDateTime);
      c++; print('No $c');
    }
  }
}

Future<void> cancelOldNotifications(Medicine oldMedicine) async {
  try{
  print('cancel med ${oldMedicine.name}');
  DateTime? startDate = oldMedicine.startdate;
  int days = oldMedicine.duration == 'everyday' ? 30 : int.parse(oldMedicine.duration!.split(' ')[0]);
  int c=0;
  for (int i = 0; i < days; i++) {
    if (oldMedicine.time!.contains('Morning')) { 
        DateTime dateT = DateTime(startDate!.year, startDate.month, startDate.day + i, morningTime.hour,morningTime.minute);
        int id= '${oldMedicine.name}_${dateT.month}_${dateT.day}_${dateT.hour}'.hashCode;
        print(id);
        await flutterLocalNotificationsPlugin.cancel(id);
        c++; print('No $c');
      }
    if (oldMedicine.time!.contains('Afternoon')) { 
      DateTime dateT = DateTime(startDate!.year, startDate.month, startDate.day + i, afternoonTime.hour,afternoonTime.minute);
        int id= '${oldMedicine.name}_${dateT.month}_${dateT.day}_${dateT.hour}'.hashCode;
        print(id);
        await flutterLocalNotificationsPlugin.cancel(id);
        c++; print('No $c');
       }
    if (oldMedicine.time!.contains('Night')) { 
      DateTime dateT = DateTime(startDate!.year, startDate.month, startDate.day + i, nightTime.hour,nightTime.minute);
        int id= '${oldMedicine.name}_${dateT.month}_${dateT.day}_${dateT.hour}'.hashCode;
        print(id);
        await flutterLocalNotificationsPlugin.cancel(id);
        c++; print('No $c');
     }
  }
  } catch(e){print('cancel noti error:$e');}
}





 Future<void> saveMedicines() async {
  print ('saving med');
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  List<String> medicineJsonList = [];

  // Convert each Medicine object to JSON and add to the list
  for (Medicine medicine in medicines) {
    String json = jsonEncode(medicine.toJson());
    medicineJsonList.add(json);
  }

  // Save the list of JSON strings to SharedPreferences
  prefs.setStringList('medicines', medicineJsonList);
  print("""----------------------------
    saving medicines
    ${medicines.length}
    """);
}







Future<void> saveTimes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Save morningTime
  await prefs.setString(
      'morningTime', '${morningTime.hour}:${morningTime.minute}');

  // Save afternoonTime
  await prefs.setString(
      'afternoonTime', '${afternoonTime.hour}:${afternoonTime.minute}');

  // Save nightTime
  await prefs.setString(
      'nightTime', '${nightTime.hour}:${nightTime.minute}');

      print('----------saved time ${prefs.getString('morningTime')}');
}


Future<void> loadTimes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Load morningTime
  String? morningTimeString = prefs.getString('morningTime');
  if (morningTimeString != null) {
    List<String> parts = morningTimeString.split(':');
    morningTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Load afternoonTime
  String? afternoonTimeString = prefs.getString('afternoonTime');
  if (afternoonTimeString != null) {
    List<String> parts = afternoonTimeString.split(':');
    afternoonTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Load nightTime
  String? nightTimeString = prefs.getString('nightTime');
  if (nightTimeString != null) {
    List<String> parts = nightTimeString.split(':');
    nightTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}



void ScheduleAlarm(Medicine medicine,message,DateTime time) async{
  int id= '${medicine.name}_${time.month}_${time.day}_${time.hour}'.hashCode;
  print(id.toString());
  no=medicines.indexOf(medicine);

  callback;
  
  await AndroidAlarmManager.oneShotAt(time, id,showFloatingWindow);
  print (no);

  
}

 
void showFloatingWindow() async {
    await SystemAlertWindow.showSystemWindow(
      gravity: SystemWindowGravity.CENTER,
      width: Constants.MATCH_PARENT,
      height: Constants.WRAP_CONTENT,
      prefMode : SystemWindowPrefMode.OVERLAY,
      
      );
     await SystemAlertWindow.sendMessageToOverlay("Hello from the other side");
     Future.delayed(Duration(seconds: 5), () async {
    await SystemAlertWindow.closeSystemWindow(
      prefMode: SystemWindowPrefMode.OVERLAY,
    );
  });
  }


typedef callback = Future<void> Function();



// class callback {
//   callback() {
//     _initializeCallback();
//   }

//   Future<void> _initializeCallback() async {
//     SharedPreferences? prefs = await SharedPreferences.getInstance();
//     List<String>? medicineStrings = prefs.getStringList('medicines');
//     if (medicineStrings != null) {
//       // Convert each string to a Medicine object using map()
//       medicines = medicineStrings.map((jsonString) {
//         // Parse the JSON string into a Medicine object
//         return Medicine.fromJson(jsonDecode(jsonString));
//       }).toList();

//       print("""----------------------------
//       loading medicines
//       ${medicineStrings.length}
//       """);
//     }
//     if (medicines.isNotEmpty) {
//       print('${medicines.first.name}');
//     }
//     print('Alarm triggered for medicineName');
//   }
// }

 Future<void> loadMedicinesout() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  List<String>? medicineStrings = prefs.getStringList('medicines');
  if (medicineStrings != null) {

    
    
      

      // Convert each string to a Medicine object using map()
      medicines = medicineStrings.map((jsonString) {
        // Parse the JSON string into a Medicine object
        return Medicine.fromJson(jsonDecode(jsonString));
      }).toList();

       
    

    print("""----------------------------
    loading medicines
    ${medicineStrings.length}
    """);
    
  }
  }


Future<void> scheduleMedicineAlarm(Medicine medicine, {Medicine? oldMedicine}) async {
  if (oldMedicine != null) {
    await cancelAlarm(oldMedicine);
  }

  DateTime? startDate = medicine.startdate;
  int days = medicine.duration == 'everyday' ? 30 : int.parse(medicine.duration!.split(' ')[0]);
     print('schdule med ${medicine.name}');
     int c= 0;

    for (int i = 0; i < days; i++) {
      if (medicine.time!.contains('Morning')) { 
      DateTime notificationDateTime = DateTime(startDate!.year, startDate.month, startDate.day + i, morningTime.hour,morningTime.minute);
      
      String? food =medicine.time!.contains('food')? medicine.time!.split('\n')[1]:null;
      String ftext = food==null? '':'at $food';
      
      ScheduleAlarm(medicine, 'Take ${medicine.dosage} $ftext', notificationDateTime);
      c++; print('No $c');
     }

     if (medicine.time!.contains('Afternoon')) { 
      DateTime notificationDateTime = DateTime(startDate!.year, startDate.month, startDate.day + i, afternoonTime.hour,afternoonTime.minute);
      
      String? food =medicine.time!.contains('food')? medicine.time!.split('\n')[1]:null;
      String ftext = food==null? '':'at $food';
      
      ScheduleAlarm(medicine, 'Take ${medicine.dosage} $ftext', notificationDateTime);
      c++; print('No $c');
     }

     if (medicine.time!.contains('Night')) { 
      DateTime notificationDateTime = DateTime(startDate!.year, startDate.month, startDate.day + i, nightTime.hour,nightTime.minute);
      
      String? food =medicine.time!.contains('food')? medicine.time!.split('\n')[1]:null;
      String ftext = food==null? '':'at $food';
      
      ScheduleAlarm(medicine, 'Take ${medicine.dosage} $ftext', notificationDateTime);
      c++; print('No $c');
     }
      



     }


}




Future<void> cancelAlarm(Medicine oldMedicine) async{
  print('cancel med ${oldMedicine.name}');
  DateTime? startDate = oldMedicine.startdate;
  int days = oldMedicine.duration == 'everyday' ? 30 : int.parse(oldMedicine.duration!.split(' ')[0]);
  int c=0;
  for (int i = 0; i < days; i++) {
    if (oldMedicine.time!.contains('Morning')) { 
        DateTime dateT = DateTime(startDate!.year, startDate.month, startDate.day + i, morningTime.hour,morningTime.minute);
        int id= '${oldMedicine.name}_${dateT.month}_${dateT.day}_${dateT.hour}'.hashCode;
        print(id);
        await AndroidAlarmManager.cancel(id);
        c++; print('No $c');
      }
    if (oldMedicine.time!.contains('Afternoon')) { 
      DateTime dateT = DateTime(startDate!.year, startDate.month, startDate.day + i, afternoonTime.hour,afternoonTime.minute);
        int id= '${oldMedicine.name}_${dateT.month}_${dateT.day}_${dateT.hour}'.hashCode;
        print(id);
        await AndroidAlarmManager.cancel(id);
        c++; print('No $c');
       }
    if (oldMedicine.time!.contains('Night')) { 
      DateTime dateT = DateTime(startDate!.year, startDate.month, startDate.day + i, nightTime.hour,nightTime.minute);
        int id= '${oldMedicine.name}_${dateT.month}_${dateT.day}_${dateT.hour}'.hashCode;
        print(id);
       await AndroidAlarmManager.cancel(id);
        c++; print('No $c');
     }
  }



}



var alarmPlugin = FlutterAlarmBackgroundTrigger();

void addalram(){
alarmPlugin.addAlarm(
      // Required
      DateTime.now().add(Duration(seconds: 10)),

      //Optional
      uid: "YOUR_APP_ID_TO_IDENTIFY",
      payload: {"YOUR_EXTRA_DATA":"FOR_ALARM"},

      // screenWakeDuration: For how much time you want 
      // to make screen awake when alarm triggered
      screenWakeDuration: Duration(minutes: 1)
  );
}
