import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';
import 'package:kissan_market_app/Providers/CropUpdateNotifier.dart';
import 'package:kissan_market_app/SaveUserData/SaveUserData.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import 'package:kissan_market_app/UpdateCropScreen.dart';
import 'package:http/http.dart' as http;
import 'Api/ApiURL.dart';
import 'package:provider/provider.dart';
class ViewCropsScreen extends StatefulWidget{
  SaveUserData saveUserData=SaveUserData();
 ViewCropsScreen({super.key,required this.saveUserData});
 @override
  State<ViewCropsScreen>createState()=>_ViewCropsScreenState();
}
class _ViewCropsScreenState extends State<ViewCropsScreen> {
  bool _isLoading=false;
  String URL =ApiURL.getURL();
  List cropData=[];
  
  
  Future viewCrops() async{
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
        "farmerId":widget.saveUserData.getUserId().toString()
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
                          color: AppColors.listTileColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                  color: AppColors.boxShadowColor,
                                  width: 1
                              )
                          ),
                          child: ListTile(
                            onTap: () {
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
                                        saveUserData: widget.saveUserData,
                                      )
                                  ));
                            },
                            dense: true,
                            leading: Column(children: [
                              Text((index + 1).toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),),
                              Icon(Icons.grass)
                            ],),
                            title: Text(
                                "Crop Name : ${cropData[index]['name']}\n Price : ${cropData[index]['price']}\n"),
                            subtitle: Text(
                                "Quantity : ${cropData[index]['quantity']} cropId:${cropData[index]['id']}"),
                            trailing: IconButton(onPressed: () {
                              deleteCrops(cropData[index]['id'].toString());
                            }, icon: const Icon(Icons.delete_outline)),

                          ),
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