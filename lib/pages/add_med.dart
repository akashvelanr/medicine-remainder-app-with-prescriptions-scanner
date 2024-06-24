// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med_remainder/main.dart';
import 'package:med_remainder/pages/homepage.dart';
//import 'package:med_remainder/pages/scan/scanpage.dart';
import '../functions.dart';
import '../source/med_details.dart';

class new_med_add extends StatefulWidget {
  const new_med_add({super.key});

  @override
  State<new_med_add> createState() => _new_med_addState();
}


Medicine? newmedicine;
bool _morningChecked = false;
bool _afternoonChecked = false;
bool _nightChecked = false;
bool _beforefood = false;
bool _afterfood = false;
bool _isEveryDay = true;

late DateTime _selectedDate;

//late Function(bool) _onChanged;

String _settime(){
  String text="";
  if(_morningChecked){text+='Morning ';}
  if(_afternoonChecked){text+='Afternoon ';}
  if(_nightChecked){text+='Night ';}
   if(_beforefood||_afterfood){text+='\n';}
  if(_beforefood){text+='BeforeFood ';}
  if(_afterfood){text+='AfterFood';}
  
  return text;
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


class _new_med_addState extends State<new_med_add> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _noofdays = TextEditingController();

  String _durationset() {
  if (_isEveryDay){ return 'everyday';}
  else {return '${_noofdays.text} days';}
}
   @override
  void initState() {
    super.initState();
    initializeNotifications();
    

    // Initialize _selectedDate with today's date
    _selectedDate = DateTime.now();
    print(DateTime.now());
    _morningChecked = false;
    _afternoonChecked = false;
    _nightChecked = false;
    _beforefood = false;
    _afterfood = false;
    _isEveryDay = true;
    newmedicine;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _noofdays.dispose();
    super.dispose();
  }
   void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:Color.fromARGB(206, 37, 141, 68),
        content: Text(error),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        title: Text('Add New Medicine'),
        backgroundColor: Color.fromARGB(255, 94, 253, 73),
      ),

      body: SingleChildScrollView(
        
        
        
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget> [

           Container(
            padding: EdgeInsets.all(20), // Adding padding
             decoration: BoxDecoration(
             color: Color.fromARGB(255, 238, 252, 223), // Setting background color to light green
             borderRadius: BorderRadius.circular(10), // Rounding the corners
            ),
            child: Column(
              
              
              children: [
             TextField(
              maxLength: 25,
              
              cursorColor: Colors.green,
              
              controller: _nameController,
               decoration: InputDecoration(labelText: 'Medicine Name*',focusColor: Colors.green),
             ),

            SizedBox(height: 10),
             TextField(
            controller: _dosageController,
            decoration: InputDecoration(labelText: 'Dosage*'),
            ),
             SizedBox(height: 20), 
              ],
            ),

           ),



          SizedBox(height: 20,),
          // time
          Container(
            
            padding: EdgeInsets.all(20), // Adding padding
             decoration: BoxDecoration(
             color: Color.fromARGB(255, 238, 252, 223), // Setting background color to light green
             borderRadius: BorderRadius.circular(10), // Rounding the corners
            ),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
                 Text('Time',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),) ,
             CheckboxListTile(
               controlAffinity: ListTileControlAffinity.leading,
              title: Text('Morning'),
              value: _morningChecked,
              onChanged: (value) {
                setState(() {
                  _morningChecked = value!;
                });
              },
            ),
            CheckboxListTile(
               controlAffinity: ListTileControlAffinity.leading,
              title: Text('Afternoon'),
              value: _afternoonChecked,
              onChanged: (value) {
                setState(() {
                  _afternoonChecked = value!;
                });
              },
            ),
            CheckboxListTile(
               controlAffinity: ListTileControlAffinity.leading,
              value: _nightChecked,
              onChanged: (value) {
                setState(() {
                  _nightChecked = value!;
                });
              },
              title: Text('Night'),
            ),
              ]
            ),
            ),
          SizedBox(height: 20), 


         //food
          Container(
            padding: EdgeInsets.all(20), // Adding padding
             decoration: BoxDecoration(
             color: Color.fromARGB(255, 238, 252, 223), // Setting background color to light green
             borderRadius: BorderRadius.circular(10), // Rounding the corners
            ),
             
              
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
        
              
              children: <Widget>[
                 Text('Choose',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),) ,  
             CheckboxListTile(
               controlAffinity: ListTileControlAffinity.leading,
              title: Text('Before Food'),
              value: _beforefood,
              onChanged: (value) {
                setState(() {
                  _beforefood = value!;
                });
              },
            ),
            CheckboxListTile(
               controlAffinity: ListTileControlAffinity.leading,
              title: Text('After Food'),
              value: _afterfood,
              onChanged: (value) {
                setState(() {
                  _afterfood = value!;
                });
              },
            ),
           
              ]
            ),
            ),
            SizedBox(height: 20,),

        //extra
       Container(
           padding: EdgeInsets.all(20), // Adding padding
             decoration: BoxDecoration(
             color: Color.fromARGB(255, 238, 252, 223), // Setting background color to light green
             borderRadius: BorderRadius.circular(10), // Rounding the corners
            ),

        
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         //start date
        Row(
        children: [
        Text('Start date',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
        SizedBox(width: 10,),
        Container(
          alignment: Alignment.center,
          
          height: 30,width: 100,
          decoration: BoxDecoration(
            border: Border.all(),
            
            borderRadius: BorderRadius.circular(30)
          ),
        child: GestureDetector(
          
          onTap: () => _selectDate(context),
          child: Text(
            
            // ignore: unnecessary_null_comparison
            _selectedDate != null ?'${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}':'select date',
            style: TextStyle(color: const Color.fromARGB(255, 3, 10, 15)),
          ),
        ),),],),


         SizedBox(height: 15,),
         Text('Duration',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
        SizedBox(height: 10,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
         children: [
      RadioListTile<bool>(
      title: Text('Every Day'),
      value: true,
      groupValue: _isEveryDay,
      onChanged: (bool? value) {
        if (value != null) {
          setState(() {
            _isEveryDay = value;
           // _onChanged(_isEveryDay);
          });
        }
      },
    ),
 
    RadioListTile<bool>(
      title: Text('Number of Days'),
      value: false,
      groupValue: _isEveryDay,
      onChanged: (bool? value) {
        if (value != null) {
          setState(() {
            _isEveryDay = value;
            //_onChanged(_isEveryDay);
          });
        }
      },
    ), 
   
    
    if (!_isEveryDay)
          Container(
            
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            width: 100,
            height: 50, // Adjust the width according to your preference
            child: TextField(
              keyboardType: TextInputType.number,
             controller: _noofdays,
              decoration: InputDecoration(
                labelText: 'No. of Days',
                border: OutlineInputBorder(),
              ),
            ),
          ),
      ],
      )
    


      ],
         


        ),
        ),

          //submit
          SizedBox(height: 20,),  
          Align(
              alignment: Alignment.center,
              child: ElevatedButton(
            
            child: const Padding(
             padding: EdgeInsets.all(8.0), // Set the desired padding
             child: Text(
                     'Submit',
                    style: TextStyle(fontSize: 20), // Set the desired font size
                    ),),
             onPressed: () async {
            // Handle form submission
            if (_nameController.text==""){displayError('Enter the Medicine Name'); return;}
            else if (_dosageController.text==""){displayError('Enter Dosage value'); return;}
            else if(!_morningChecked&&!_afternoonChecked&&!_nightChecked){displayError('Select Time');return;}
            //else if(!_beforefood&&!_afterfood){displayError('Select Before food/After food');return;}
            else if(!_isEveryDay&&_noofdays.text==""){displayError('Enter No. of Days');return;}

            
            newmedicine = Medicine(
              name: _nameController.text,
              dosage: _dosageController.text,
              time: _settime(),
              duration: _durationset(),
              startdate: _selectedDate,
            );

            
            //print(newmedicine?.time);
            medicines.add(newmedicine!);
            print('${medicines.last.name}');
            
            saveMedicines();

            Navigator.pop(context,'medicine');
            displayError('Medicine added Successfully');
            
            await scheduleMedicineNotification(newmedicine!);
  
          }
          )
          )
          ],

          
        ),
        


      ),



    );
  }
}
