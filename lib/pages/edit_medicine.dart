import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:med_remainder/functions.dart';
import 'package:med_remainder/pages/homepage.dart';
import 'package:med_remainder/source/med_details.dart';


class edit_med_page extends StatefulWidget {
  final Medicine medicine;

  const edit_med_page( {required this.medicine, Key? key}) : super(key: key);
 
 
  @override
  State<edit_med_page> createState() => _edit_med_pageState();
}

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

bool _morningChecked =false;
bool _afternoonChecked =false;
bool _nightChecked =false;
bool _beforefood =false;
bool _afterfood =false;
bool _isEveryDay =false;

late DateTime _selectedDate;

String durationPattern = r'\d+'; // Regular expression pattern to match the number of days
 RegExp regExp = RegExp(durationPattern);
 

class _edit_med_pageState extends State<edit_med_page> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dosageController = TextEditingController();
  TextEditingController _noofdays = TextEditingController();



  late Medicine med;

   String _durationset() {
  if (_isEveryDay){ return 'everyday';}
  else {return '${_noofdays.text} days';}
 }

 
 @override
  void initState() {
    super.initState();
    med = widget.medicine;
    _selectedDate = DateTime.now();
    _morningChecked = med.time!.contains('Morning');
    _afternoonChecked = med.time!.contains('Afternoon');
    _nightChecked = med.time!.contains('Night');
    _beforefood = med.time!.contains('BeforeFood');
    _afterfood = med.time!.contains('AfterFood');
    _isEveryDay = med.duration!.contains('everyday');

    _nameController.text=med.name!;
    _dosageController.text=med.dosage!;

     RegExpMatch? match = regExp.firstMatch(med.duration!);

    _noofdays.text = regExp.hasMatch(med.duration!) ? '${match![0]}' : '';
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

   void _deleteMedicine() {
    
    setState(() {
    
      medicines.remove(widget.medicine);

    });

    saveMedicines();
   
    Navigator.pop(context);

   
    displayError('Medicine Deleted Successfully');
  }
  
  @override
  Widget build(BuildContext context) {
      print(med.name);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        title: Text('Edit Medicine'),
         backgroundColor: Color.fromARGB(255, 94, 253, 73),

          actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              cancelOldNotifications(widget.medicine);
              _deleteMedicine(); // Call the method to delete the medicine
            },
          ),
        ],

      ),

      body:SingleChildScrollView(
        
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

            
            med = Medicine(
              name: _nameController.text,
              dosage: _dosageController.text,
              time: _settime(),
              duration: _durationset(),
              startdate: _selectedDate,
           );

           
            Medicine oldMed =widget.medicine;

            widget.medicine.name=med.name;
            widget.medicine.dosage=med.dosage;
            widget.medicine.time=med.time;
            widget.medicine.duration=med.duration;
          
           

            Navigator.pop(context,);

            displayError('Medicine Edited Successfully');

            saveMedicines();

            await scheduleMedicineNotification(med, oldMedicine: oldMed);
          


          }
          )
          )
          ],

          
        ),
      
      
      )
    );
  
  }
}