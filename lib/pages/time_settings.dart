// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:med_remainder/functions.dart';
import 'package:med_remainder/pages/homepage.dart';
import '../source/med_details.dart';

class time_setting_page extends StatefulWidget {
  const time_setting_page({super.key});

  @override
  State<time_setting_page> createState() => _time_setting_pageState();
}

class _time_setting_pageState extends State<time_setting_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Setting'),
        backgroundColor: Color.fromARGB(255, 94, 253, 73),
      ),

      body: Container(
        padding: EdgeInsets.all(30),

        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [



          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Morning:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
              SizedBox(width: 10,),
               GestureDetector(
          
          onTap: () { _selecttimemorning(context, morningTime); },
          child:
              Container(
          alignment: Alignment.center,
          
          height: 30,width: 100,
          decoration: BoxDecoration(
            border: Border.all(),
            
            borderRadius: BorderRadius.circular(30)
          ),
         
          child: Text(
            
            // ignore: unnecessary_null_comparison
            morningTime != null ?'${morningTime.hour}:${morningTime.minute}':'select time',
            style: TextStyle(color: const Color.fromARGB(255, 3, 10, 15)),
             ),
             ),),],
            
          ),

          SizedBox(height: 20,),

          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            
            children: [
              Text('Afternoon:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
              SizedBox(width: 10,),
              GestureDetector(
          
          onTap: () { _selecttimeafternoon(context,afternoonTime);},
             child:  Container(
          alignment: Alignment.center,
          
          height: 30,width: 100,
          decoration: BoxDecoration(
            border: Border.all(),
            
            borderRadius: BorderRadius.circular(30)
          ),
           
          child: Text(
            
            // ignore: unnecessary_null_comparison
            afternoonTime != null ?'${afternoonTime.hour}:${afternoonTime.minute}':'select time',
            style: TextStyle(color: const Color.fromARGB(255, 3, 10, 15)),
             ),
             ),),],
            
          ),

          SizedBox(height: 20,),

          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            
            children: [
              Text('Night:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
              SizedBox(width: 10,),
               GestureDetector(
          
          onTap: () { _selecttimenight(context,nightTime); },
          child: 
              Container(
          alignment: Alignment.center,
          
          height: 30,width: 100,
          decoration: BoxDecoration(
            border: Border.all(),
            
            borderRadius: BorderRadius.circular(30)
          ),
       
          child: Text(
            
            // ignore: unnecessary_null_comparison
            nightTime != null ?'${nightTime.hour}:${nightTime.minute}':'select time',
            style: TextStyle(color: const Color.fromARGB(255, 3, 10, 15)),
             ),
             ),),],
            
          ),

          SizedBox(height: 20,),

        


        ],),
      ),



    );
  }


  Future<TimeOfDay> _selecttimemorning (BuildContext context, time) async {
  final TimeOfDay? pickedtime = await showTimePicker(
    context: context, 
    initialTime: time,
    );
    if (pickedtime != null && pickedtime != time) {
      setState(() {
        morningTime = pickedtime;
      });
    }
    saveTimes();
    return time;

}


  Future<TimeOfDay> _selecttimeafternoon (BuildContext context, time) async {
  final TimeOfDay? pickedtime = await showTimePicker(
    context: context, 
    initialTime: time,
    );
    if (pickedtime != null && pickedtime != time) {
      setState(() {
        afternoonTime = pickedtime;
      });
    }
    saveTimes();
    return time;

}

  Future<TimeOfDay> _selecttimenight(BuildContext context, time) async {
  final TimeOfDay? pickedtime = await showTimePicker(
    context: context, 
    initialTime: time,
    );
    if (pickedtime != null && pickedtime != time) {
      setState(() {
        nightTime = pickedtime;
      });
    }
    saveTimes();
    return time;

}

}



