// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:med_remainder/functions.dart';
import 'package:med_remainder/main.dart';
import 'package:med_remainder/source/med_details.dart';
import 'package:med_remainder/pages/homepage.dart';

import 'package:med_remainder/pages/scan/CapturePictureScreen.dart';

class scanpage extends StatefulWidget {
  const scanpage({super.key});

  @override
  State<scanpage> createState() => _scanpageState();
}





class _scanpageState extends State<scanpage> {
  final picker = ImagePicker();
  late List<CameraDescription> cameras;
  XFile? _image;
  String _text = '';
  bool _Loading = false;


  Future<void> _getImage() async {
  try {
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  } catch (e) {
    // Handle the error here
    print('Error occurred while picking image: $e');
   
  }
 } 


   @override
  void initState() {
    super.initState();
    try{_initializeCamera();} catch(e){print(e);}
  }

  Future<void> _initializeCamera() async {
    //super.initState();
    cameras = await availableCameras();
  }



  Future<void> _takePicture() async {
  

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CapturePictureScreen(camera: cameras.first),
    ),
    );
    if (result != null) {
    setState(() {
      _image = XFile(result);
    });
    }
 }

  Future<void> _recognizeText() async {
     
     

    if (_image == null) return;

    final GoogleVisionImage visionImage =
        GoogleVisionImage.fromFilePath(_image!.path);

    final TextRecognizer textRecognizer =
        GoogleVision.instance.textRecognizer();
    
    try {
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);


      List<TextBlock> sortedBlocks = List.from(visionText.blocks);
       sortedBlocks.sort((a, b) {
      if (a.boundingBox == null || b.boundingBox == null) return 0;
      final aTop = a.boundingBox!.top;
      final bTop = b.boundingBox!.top;
      if (aTop != bTop) {
        return aTop.compareTo(bTop); // Sort by top-left y-coordinate (top to bottom)
      } else {
        return a.boundingBox!.left.compareTo(b.boundingBox!.left); // Sort by top-left x-coordinate (left to right)
      }
    });




      String text = '';
     
      for (TextBlock block in sortedBlocks) {
      //  final Rect? boundingBox = block.boundingBox;
        //print(boundingBox);
      // print("block:${block.text}");
        for (TextLine line in block.lines) {
           
          text += '${line.text}\n' ;
          //print("line :${line.text!.trim()}");
        }
        text += '\n' ;
      }



    
      
          _text = text;
          scanmedicines.clear();
          scanmedicines = parseMedicines(_text);
         
      
    //  print(_text);

     
      for (var medicine in scanmedicines) {
    print('Medicine Name: ${medicine.name}');
    print('Dosage: ${medicine.dosage}');
    print('Duration: ${medicine.duration}');
    print('-----------------------');
     }

     for (var medicine in scanmedicines) {
               print(2);
               
                medicines.add(medicine);
                }

      


      Navigator.pop(context,true);
      saveMedicines();
                
      for( var med in scanmedicines){
        scheduleMedicineNotification(med);
      }

     



      
    } catch (e) {
      print('Error occurred while recognizing text: $e');
    
    ;
    
    } 
    
    
    finally {
      textRecognizer.close();
    }
  }


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(appBar: AppBar(
        title: Text('Scanpage'),
        backgroundColor: Color.fromARGB(255, 94, 253, 73),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               if (_image != null)
              Image.file(File(_image!.path)),
            ],
          ),
        ),
      ),

      

      bottomNavigationBar: Container(
      height: 150,
      
      child:BottomAppBar(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           
          children:<Widget> [
            
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed:  _getImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Take Picture'),
            ),
             
          ],
        ),
          const SizedBox(height: 5),
          ElevatedButton(
            
             onPressed: () {
              setState(() {
                _Loading=true;
              });
               _recognizeText();
                
                
               
               
               
             },
             
              child: Text(_Loading?'Loading....':'Get Medicine Details'),
            ),
          ]
        )
      ),
      )
      );
      
      
      
  }
}