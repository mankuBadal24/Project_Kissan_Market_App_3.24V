import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';
import 'package:kissan_market_app/Providers/CropUpdateNotifier.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import 'package:kissan_market_app/UpdateCropScreen.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:http/http.dart' as http;
import 'Api/ApiURL.dart';
import 'package:provider/provider.dart';
class ViewCropsScreen extends StatefulWidget{
 const ViewCropsScreen({super.key});
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
        "farmerId":"1"
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
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Server Unreachable...',
          // autoCloseDuration: const Duration(seconds: 2)
        );

      }

    }
    catch(e){
      print("catch is running ");
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: "Some Exception Occurred....$e",
        // autoCloseDuration: const Duration(seconds: 2)
      );
      // showSuccesAlert("Some Exception Running");
    }
    setState(() {
      _isLoading=false;
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
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Crop deleted successfully',
          );
          setState(() {
            viewCrops();
          });
        }
      }
      else{
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Server Unreachable...',
          // autoCloseDuration: const Duration(seconds: 2)
        );

      }

    }
    catch(e){
      print("catch is running ");
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: "Some Exception Occurred....$e",
        // autoCloseDuration: const Duration(seconds: 2)
      );
      // showSuccesAlert("Some Exception Running");
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
                          color: const Color(0xC5D0F1C0),
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