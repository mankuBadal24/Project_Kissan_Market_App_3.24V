import 'package:flutter/material.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';

import '../Theme/AppColors.dart';

class AboutUs extends StatelessWidget{
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: CustomWidgets.appBar('About Us'),
     body: SingleChildScrollView(
       child: Column(
            children: [
             Center(
               child: Container(
                 width: 350,
                 height: 400,

                 child: Card(
                   color: const Color(0xc5d0f1c0),
                   shape:  RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(50),
                       side: const BorderSide(
                           color:Color(0xff78aa02),
                           width: 10
                       )
                   ),
                   child: Padding(
                     padding: const EdgeInsets.all(15.0),
                     child: Column(
                       children: [
                         Icon(Icons.description),
                     const ListTile(
                     title: Text('Description',textAlign:TextAlign.center,),
                     subtitle: Text('A mobile application connecting farmers directly with buyers for efficient trade.\n\n Objectives: Eliminate middlemen in agricultural trade.,Empower farmers with better pricing.,Provide buyers with fresh produce.',textAlign:TextAlign.center),
                     ),
                         CustomWidgets.customTextRow('App Name', 'Kisan Market App'),
                         CustomWidgets.customTextRow('Targets', 'Farmers , WholeSaleBuyers'),

                       ]
                     ),
                   ),
                 ),
               ),
             ),
              Center(
                child: Container(
                  width: 350,
                  height: 400,

                  child: Card(
                    color: const Color(0xffbccdfd),
                    shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(
                            color: Color(0xff79acf6),
                            width: 10
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          children: [
                            Icon(Icons.people_sharp),
                            const ListTile(
                              title: Text('Team',textAlign:TextAlign.center,),
                            ),
                            CustomWidgets.customTextRow('Gaurav','Flutter Developer'),
                            CustomWidgets.customTextRow('Mayank Badal', 'Backend Developer'),
                            CustomWidgets.customTextRow('Anjali', 'Database & Backend Developer'),
                            CustomWidgets.customTextRow('Abhin Sharma', 'Documentation & Testing'),
                            CustomWidgets.customTextRow('Technologies', 'Flutter,SpringBoot,MySQL,JDBC'),
                          ]
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 350,
                  height: 450,

                  child: Card(
                    color: const Color(0xc5edcaf3),
                    shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(
                            color:Color(0xc5dc4cf4),
                            width: 10
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          children: [
                            Icon(Icons.info_outline),
                            const ListTile(
                              title: Text('Terms And Conditions',textAlign:TextAlign.center,),
                              subtitle: Text('All content and materials provided by the project, including text, images, logos, code, and designs, are the intellectual property of the developers (i.e., the students or the college) unless otherwise stated. You may not copy, reproduce, distribute, or use any of these materials without prior permission.\n\nIn no event shall the project developers or the institution (college/university) be liable for any direct, indirect, incidental, or consequential damages arising out of the use of this project, even if the developers were advised of the possibility of such damages.'),
                            ),


                          ]
                      ),
                    ),
                  ),
                ),
              ),
            ],
       ),
     ),

   );
  }
}