// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med_remainder/pages/scan/scanpage.dart';
import 'package:med_remainder/pages/time_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/add_med.dart';
import '../source/med_details.dart';
import '../functions.dart';
import '../pages/edit_medicine.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


import 'package:system_alert_window/system_alert_window.dart';


class HomePage extends StatefulWidget {
  
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

Future<void> setstated() async {
  setstated();
}

List <Medicine> medicines =[];
TimeOfDay morningTime = TimeOfDay(hour: 8, minute: 0);
TimeOfDay afternoonTime =TimeOfDay(hour: 12, minute: 0);
TimeOfDay nightTime = TimeOfDay(hour: 19, minute: 0) ;

class _HomePageState extends State<HomePage> {


  Future<void> loadMedicines() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  List<String>? medicineStrings = prefs.getStringList('medicines');
  if (medicineStrings != null) {

    
    setState(() {
      

      // Convert each string to a Medicine object using map()
      medicines = medicineStrings.map((jsonString) {
        // Parse the JSON string into a Medicine object
        return Medicine.fromJson(jsonDecode(jsonString));
      }).toList();

          });
    

    print("""----------------------------
    loading medicines
    ${medicineStrings.length}
    """);
    
  }
  }


  @override
  void initState() {
    // TODO: implement initState
    
    loadMedicines();
    loadTimes();
    super.initState();
    
    initializeNotifications();
  }

  
  void setstated(){
  setState(() {
    
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Med Reminder'),
        backgroundColor: Color.fromARGB(255, 94, 253, 73),elevation: 20
        ,
         actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> time_setting_page()));
              
            },
      ),
         ],
      ),
      
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if(medicines.isEmpty)
              const Center(
                child:  Text(
                'Scan or Add new medicine',                
                style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w200),
                ),),
              
            
            if(medicines.isNotEmpty)
           
            
            
            
              Text('    Medicines',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
              Container(padding: EdgeInsets.zero,

            child:  ListView.builder(
                 padding: EdgeInsets.zero,
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 itemCount: medicines.length,
                 itemBuilder: (context, index) {
                 Medicine medicine = medicines[index];
                 return Padding(
                     padding: EdgeInsets.zero, // Adjust the vertical padding
                     child: ListTile( 
                      onTap:() {Navigator.push(context, 
                      MaterialPageRoute(builder:(context)=> edit_med_page(medicine: medicine))).then((value) => setState(() {}));},
                        subtitle: Container(

                          
                          
                          padding: EdgeInsets.all(10),
                           decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                 color: Color.fromARGB(255, 202, 245, 204),
                            ),


                          child: Column( 
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget> [ 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child:
                                  Text('${medicine.name!.length <= 25 ? medicine.name : medicine.name?.substring(0, 25)}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500) , ),
                                  ),
                                  Icon(Icons.edit,),
                                ],
                              ),

                              Row(
                                  children: [
                                   const Text(
                                       'Dosage:',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), // Bold style for "Time:"
                                           ),
                                  Expanded(child: Text(
                                       '${medicine.dosage}',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400), // Normal style for medicine.time
                                        ), )
                                           ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   const Text(
                                       'Time:',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), // Bold style for "Time:"
                                           ),
                                   Text(
                                       '${medicine.time}',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400), // Normal style for medicine.time
                                        ),
                                           ],
                                  ),
                                   Row(
                                  children: [
                                   const Text(
                                       'Duration:',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), // Bold style for "Time:"
                                           ),
                                   Text(
                                       '${medicine.duration}',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400), // Normal style for medicine.time
                                        ),
                                           ],
                                  ),

                              
                              ]
                              ),
                         ),
                       ),
                    );
                 },
            ),

               ),
        
          
            
              
          ],
        ),
      ),

      floatingActionButton: Stack(
        
        children: [
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
         
              heroTag: 'camera',
              onPressed: () async { 
                print (2);
               Navigator.push(
                  context,
                 MaterialPageRoute(builder: (context) => scanpage()),).then((value) { 
                  print('bef');
                  setState(() {});
                  print('aff');
                  
                  });
                 
                
                 print (3);
               },
               elevation: 2.0,
              backgroundColor: Color.fromARGB(255, 94, 253, 73),
              shape: CircleBorder(),
              child: Icon(Icons.camera, color: Colors.black),
            ),
          ),
          
          Positioned(
            bottom: 20.0,
            right: 80.0,
            child: FloatingActionButton(
              heroTag: 'add',
              onPressed: () async {

    //             tz.initializeTimeZones();

    //             await flutterLocalNotificationsPlugin.zonedSchedule(
    // 0,
    // 'scheduled title',
    // 'scheduled body',
    // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    // const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //         'your channel id', 'your channel name',
    //         channelDescription: 'your channel description')),
    // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    // uiLocalNotificationDateInterpretation:
    //     UILocalNotificationDateInterpretation.absoluteTime);


         


                
                // DateTime now = DateTime.now();
                //  DateTime futureTime = now.add(Duration(seconds: 5));  
                // scheduleNotification('title', 'body', futureTime);
                addalram();






                Navigator.push(context, 
                MaterialPageRoute(builder: (context)=> new_med_add()),).then((value) {
                  // Update the UI when a new medicine is added
                  setState(() {});
                });
               
               },
                elevation: 2.0,
              backgroundColor: Color.fromARGB(255, 94, 253, 73),
              shape: CircleBorder(),
              child: Icon(Icons.add, color: Colors.black),
            ),
          ),
        ],
      ),
      
    );
  }
}

