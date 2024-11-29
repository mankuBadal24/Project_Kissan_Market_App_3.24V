import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kissan_market_app/AddCropScreen.dart';
import 'package:kissan_market_app/AppDrawerMenuScreen.dart';
import 'package:kissan_market_app/SaveUserData/SaveUserData.dart';
import 'package:kissan_market_app/ViewCropsScreen.dart';
import 'package:http/http.dart' as http;

import 'Api/ApiURL.dart';
import 'Theme/AppColors.dart';

class FarmerHomeScreen extends StatefulWidget{
  SaveUserData saveUserData=SaveUserData();
  FarmerHomeScreen({super.key,required this.saveUserData});
  @override
  State<FarmerHomeScreen> createState()=>_FarmerHomeScreenState();
  
}
class _FarmerHomeScreenState extends State<FarmerHomeScreen>{
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isLoading=false;
  String URL =ApiURL.getURL();
  List farmerData=[];
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getFarmers();
  }


  Widget _buildDotIndicator(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (dotIndex) {
        bool isActive = (index % 2) == dotIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isActive ? 12: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : AppColors.borderColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }


  Future getFarmers() async{
    setState(() {
      _isLoading=true;
    });
    const  timeoutDuration= Duration(seconds: 10);

    String uri = '${URL}api/buyers';
    final addCropRequest =  http.post(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json', // Set to JSON
      },
      body: jsonEncode({

      }),
    );

    try{
      final response= await Future.any([addCropRequest,Future.delayed(timeoutDuration)]);
      if(response!=null){
        if(response.statusCode==200){
          setState(() {
            farmerData = jsonDecode(response.body);
            print(farmerData);
          });
        }
      }
      else{
        // QuickAlert.show(
        //   context: context,
        //   type: QuickAlertType.error,
        //   text: 'Server Unreachable...',
        //   // autoCloseDuration: const Duration(seconds: 2)
        // );

      }

    }
    catch(e){
      print("catch is running ");
      // QuickAlert.show(
      //   context: context,
      //   type: QuickAlertType.error,
      //   text: "Some Exception Occurred....$e",
        // autoCloseDuration: const Duration(seconds: 2)
      // );
      // showSuccesAlert("Some Exception Running");
    }
    setState(() {
      _isLoading=false;
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:  const Text('FarmerHomeScreen',
        style: TextStyle(color: AppColors.secondaryColor),),
        backgroundColor: AppColors.primaryColor,
      ),

      drawer: AppDrawerMenuScreen(saveUserData: widget.saveUserData,),
      body: Column(
        children: [
          Expanded(
            child:PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
               Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [

                       Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: FloatingActionButton.large(
                               backgroundColor: AppColors.primaryColor,
                               heroTag: 'Add Crop',
                               onPressed: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=> AddCropScreen(saveUserData: widget.saveUserData,)));
                               },
                               tooltip: 'Add Crops',
                               shape:const CircleBorder(),
                               child:  const Icon(Icons.add_a_photo_outlined,color: AppColors.secondaryColor,),),
                           ),
                           const Text('Add Crops'),
                         ],
                       ),


                       Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: FloatingActionButton.large(
                               backgroundColor: AppColors.primaryColor,
                               onPressed: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewCropsScreen(saveUserData: widget.saveUserData,)));
                               },
                               heroTag: "View Added Crops",
                               tooltip: 'View Added crops',
                               shape: const CircleBorder(),
                               child: const Icon(Icons.remove_red_eye_outlined,color: AppColors.secondaryColor,),),
                           ),
                           const Text('View Added Crops')
                         ],
                       ),
                     ],
                   ),

                   Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: FloatingActionButton.large(
                               backgroundColor: AppColors.primaryColor,
                               onPressed: (){},
                               heroTag:"Transportation" ,
                               tooltip: 'Transportation',
                               shape: const CircleBorder(),
                               child: const Icon(Icons.fire_truck_outlined,color: AppColors.secondaryColor,),),
                           ),
                           const Text('Transportation'),
                         ],
                       ),

                       Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: FloatingActionButton.large(
                               onPressed: (){},
                               backgroundColor: AppColors.primaryColor,
                               heroTag: 'Send to WareHouse',
                               tooltip: 'Send to WareHouse',
                               shape: const CircleBorder(),
                               child: const Icon(Icons.warehouse_outlined,color: AppColors.secondaryColor,),),
                           ),
                           const Text('Send to WareHouse'),
                         ],
                       ),
                     ],
                   ),
                 ],
               )

              ],
            ),

          ),
          // _buildDotIndicator(_currentIndex), // Call the function here
          const Divider(height: 1,thickness:2,color: AppColors.borderColor,),
         const  Center(child: Text('Available Buyers List',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: AppColors.primaryColor),),),
          Expanded(
              child:  ListView.builder(
                  shrinkWrap: true,
                  itemCount: farmerData.length,
                  itemBuilder: (context, index) {
                    int count = index;
                    return Card(
                      color:  AppColors.listTileColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                              color: AppColors.boxShadowColor,
                              width: 1
                          )
                      ),
                      child: ListTile(
                        onTap: () {

                        },
                        dense: true,
                        leading: Column(children: [
                          Text((index + 1).toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),),
                          const Icon(Icons.person)
                        ],),
                        title: Text(
                            "Buyer Name : ${farmerData[index]['name']}"),
                        subtitle: Text(
                            "Phone Number : ${farmerData[index]['phoneNumber']}"),


                      ),
                    );
                  }

              ),
          )
        ],
      ),
    );
  }
  

  
}
