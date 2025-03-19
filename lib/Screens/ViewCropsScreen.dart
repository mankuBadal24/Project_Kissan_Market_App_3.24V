import 'dart:convert';
import 'package:kissan_market_app/SharedPreferences/UserSharedPreferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';
import 'package:kissan_market_app/Providers/CropUpdateNotifier.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import 'package:kissan_market_app/Screens/UpdateCropScreen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Api/ApiURL.dart';
class ViewCropsScreen extends StatefulWidget{
 ViewCropsScreen({super.key});
 @override
  State<ViewCropsScreen>createState()=>_ViewCropsScreenState();
}
class _ViewCropsScreenState extends State<ViewCropsScreen> {
  UserSharedPreferences pref=UserSharedPreferences();
  Map<String,String?>userData={};
  bool _isLoading=false;
  String URL =ApiURL.getURL();
  List cropData=[];
  
  
  Future viewCrops() async{
    userData=await pref.loadUserData();
    print('----------XXXX  ${userData['userId'].toString()}');
    setState(() {
      _isLoading=true;
    });
    const  timeoutDuration= Duration(seconds: 10);

    String uri = '${URL}api/crops/getAll';
    final addCropRequest =  http.post(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json', // Set to JSON
      },
      body: jsonEncode({
        "farmerId":userData['userId'].toString()
      }),
    );

    final response= await Future.any([addCropRequest,Future.delayed(timeoutDuration)]);
    try{
      if(response!=null){
        if(response.statusCode==200){
          setState(() {
            cropData = jsonDecode(response.body);
          });
        }
      }
      else{
       showQuickAlert('Data Fetch Error', 'error');

      }

    }
    catch(e){
      print("catch is running ");
     showQuickAlert('Some Exception Occurred $e','error');
      // showSuccesAlert("Some Exception Running");
    }
    setState(() {
      _isLoading=false;
    });
  }


  showQuickAlert(String message ,String type){
    AlertType _type=AlertType.error;
    if(type=='success'){
      _type =AlertType.success;

    }
    else if(type=='warning'){
      _type=AlertType.warning;
    }
    else if(type=='error'){
      _type=AlertType.error;
    }

    Alert(context: context,
        title: message,
        type: _type,
        buttons: [
          DialogButton(child: CustomWidgets.textNormal('Okay'),
              color: AppColors.primaryColor,
              onPressed: (){
                Navigator.of(context).pop();
              })
        ]
    ).show();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop(); // Close the alert after 3 seconds
    });

  }



  Future deleteCrops(String cropId) async{
    setState(() {
      _isLoading=true;
    });
    const  timeoutDuration= Duration(seconds: 10);

    String uri = '${URL}api/crops/delete';
    final addCropRequest =  http.post(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json', // Set to JSON
      },
      body: jsonEncode({
        "cropId":cropId
      }),
    );

    final response= await Future.any([addCropRequest,Future.delayed(timeoutDuration)]);
    print("response ------$response");
    try{
      if(response!=null){
        print("statis code-----------------${response.statusCode}");
        if(response.statusCode==200){
         showQuickAlert("Crop deleted successfully", "success");
          setState(() {
            viewCrops();
          });
        }
      }
      else{
      showQuickAlert("Server Unreachable...", "warning");

      }

    }
    catch(e){
     showQuickAlert("Some Exception Occurred", "error");
    }
    finally{

      setState(() {
        _isLoading=false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    viewCrops();
  }


  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: CustomWidgets.appBar("View Crops Screen"),
      body: Stack(
        children: [
          Padding(
            padding:const  EdgeInsets.all(5),
            child:
            Consumer<CropUpdateNotifier>(
              builder: (context, cropUpdateNotifier, child) {
                return
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: cropData.length,
                      itemBuilder: (context, index) {
                        int count = index;
                        return Card(
                          // color: AppColors.listTileColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(

                                  color: AppColors.primaryColor,
                                  width: 1
                              )
                          ),
                          child:Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(("${index + 1}").toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),),
                                Text((" Crop Details").toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),),
                                InkWell(child: Icon(Icons.edit,color:AppColors.primaryColor,),
                                  onTap: (){

                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) =>
                                            UpdateCropScreen(
                                              cropCode: cropData[index]['cropCode'],
                                              name: cropData[index]['name'],
                                              type: cropData[index]['type']
                                                  .toString(),
                                              quantity: cropData[index]['quantity']
                                                  .toString(),
                                              farmerId: cropData[index]['farmerId']
                                                  .toString(),
                                              price: cropData[index]['price']
                                                  .toString(),
                                              cropId: cropData[index]['id']
                                                  .toString(),

                                            )
                                        ));
                                  },),
                              ],),
                              Divider(),

                              Row(
                                children: [
                                  Icon(Icons.grass,color:Colors.green ,),
                                  SizedBox(width: 8,),
                                  Expanded(child:  Text("Crop Name : ${cropData[index]['name']}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))

                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Icon(Icons.currency_rupee,color: AppColors.primaryColor,),
                                  SizedBox(width: 8,),
                                  Expanded(child:  Text("Price : ${cropData[index]['price']} ₹",style: TextStyle(fontSize: 16,)))

                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Icon(Icons.shopping_bag,color: AppColors.primaryColor,),
                                  SizedBox(width: 8,),
                                  Expanded(child:  Text("Quantity : ${cropData[index]['quantity']} ton",style: TextStyle(fontSize: 16,)))

                                ],
                              ),


                            ],),
                          )
                        );
                      }

                  );
              })

            ),

          if(_isLoading)
            Container(
              height: 700,
              width: 500,
              color: Colors.blue.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}












