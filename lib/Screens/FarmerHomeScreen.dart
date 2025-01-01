import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kissan_market_app/Screens/AddCropScreen.dart';
import 'package:kissan_market_app/Screens/AppDrawerMenuScreen.dart';
import 'package:kissan_market_app/SaveUserData/SaveUserData.dart';
import 'package:kissan_market_app/Screens/DriverListScreen.dart';
import 'package:kissan_market_app/SessionManagement//SessionManagement.dart';
import 'package:http/http.dart' as http;
import '../Api/ApiURL.dart';
import '../SecureStorage/UserTokenSaver.dart';
import '../SharedPreferences/UserSharedPreferences.dart';
import '../Theme/AppColors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'ViewCropsScreen.dart';

class FarmerHomeScreen extends StatefulWidget{
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  FarmerHomeScreen({super.key});
  @override
  State<FarmerHomeScreen> createState()=>_FarmerHomeScreenState();
  
}
class _FarmerHomeScreenState extends State<FarmerHomeScreen>{
  final UserSharedPreferences pref = UserSharedPreferences();
  final SessionManagement sessionProvider=SessionManagement();
  final PageController _pageController = PageController();
  bool _isLoading=false;
  String URL =ApiURL.getURL();
  List farmerData=[];
  Map<String,String?>userData={};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // saveUserCredentials();
    getFarmers();
  }



  showSnackBarMessage(String message ) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: AppColors.primaryColor, fontSize: 16),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: AppColors.backgroundColor,
      closeIconColor: AppColors.secondaryColor,
    ));
  }
  // saveUserCredentials()async{
  //   userData= await pref.loadUserData();
  //   SaveUserData saveUserData=SaveUserData();
  //   saveUserData.saveUserId(userData['userId']!);
  //   saveUserData.saveName(userData['name']!);
  //   saveUserData.savePhoneNumber(userData['phoneNumber']!);
  //   saveUserData.saveTypeOfUser(userData['typeOfUser']!);
  //   print("${saveUserData.getUserId()}${saveUserData.getName()}");
  //
  // }

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

      drawer: AppDrawerMenuScreen(),
      body: Column(
        children: [
          Expanded(
            child:Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddCropScreen()));
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewCropsScreen()));
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
                            onPressed: () async{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const DriverListScreen()));
                            },
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
                            onPressed: ()async{

                            },
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
