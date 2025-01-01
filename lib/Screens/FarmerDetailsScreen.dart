import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kissan_market_app/Api/ApiURL.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';

import '../Theme/AppColors.dart';
class FarmerDetailsScreen extends StatefulWidget{
  final String farmerId;
  const FarmerDetailsScreen({super.key,required this.farmerId});
  @override
  State<FarmerDetailsScreen> createState() => FarmerDetailsScreenState();
}

class FarmerDetailsScreenState extends State<FarmerDetailsScreen> {
  bool _isLoading=false;
  String URL= ApiURL.getURL();
  bool _isDisposed=false;
  // List cropData=[];
   late Future<Map <String ,dynamic>>farmerData;




  Future<Map<String, dynamic>> getFarmerDetails() async {
    late Map <String ,dynamic>futureFarmerData;
    setState(() {
      _isLoading = true;
    });

    try{
      const timeoutDuration = Duration(seconds: 5);
      String uri = '${URL}api/farmers/details';

      final updateRequest = http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json', // Set to JSON
        },
        body: jsonEncode(
          {
            "farmerId":int.parse(widget.farmerId)

          },
        ),
      );

      final response = await Future.any([updateRequest, Future.delayed(timeoutDuration)]);


        print(response.statusCode);
      if (response != null) {
        if (response.statusCode == 200) {
          futureFarmerData = jsonDecode(response.body);
          print(futureFarmerData);
          // cropData=farmerData["crops"];
          // showQuickAlert("Data Fetched Successfully", 'success');
          // Future.delayed(const Duration(seconds: 2));
        } else {
          showQuickAlert(response.statusCode.toString(), 'warning');
        }
      } else {
        showQuickAlert('Some Error Occurred!', 'error');
      }
    } catch (e) {
      print("Exception thrown   $e");
      if (!_isDisposed) {

      }
    } finally {

      if (!_isDisposed) {

        setState(() {
          _isLoading = false;
        });

      }
    }
    return futureFarmerData;
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

  @override
  void initState() {
    super.initState();
   farmerData= getFarmerDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appBar("Farmer Details"),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: farmerData, // Pass your async data fetching method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error in fetching data, show an error message
            return Center(child:Text('No data available.')/* Text('Error: ${snapshot.error}')*/);
        }
            else if (!snapshot.hasData || snapshot.data == null) {
            // If there's no data, show a no data message
            return Center(child: Text('No data available.'));
          } else {
            // Data has been fetched, now you can use it
            var wholeData=snapshot.data!;
            print(wholeData);
            var farmerDetails =wholeData['registrationDetails'];
            var cropData= wholeData['crops']; // Access the list of items
            print(" data type---------${cropData}");
            return
                  Column(
                    children: [
                      Expanded(
                          child: Center(
                            child: Column(

                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton.large(
                                    backgroundColor: AppColors.primaryColor,
                                    heroTag: 'Profile',
                                    onPressed: (){
                                    },
                                    tooltip: 'Profile',
                                    shape:const CircleBorder(),
                                    child:  const Icon(Icons.person,color: AppColors.secondaryColor,size: 60,),),
                                ),
                                Text(wholeData['farmerName'].toUpperCase(),style:const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                Card(color: AppColors.listTileColor,
                                    child:SizedBox(
                                      height: 180,
                                      width: 500,
                                      child:  Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [

                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    // height: 20,
                                                      margin: EdgeInsets.zero,
                                                      child: Text(
                                                        'Type Of Farmer:',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(farmerDetails['farmerType'],
                                                      textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                            Divider(color: Colors.grey),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    // height: 12,
                                                      margin: EdgeInsets.zero,
                                                      child: Text(
                                                        'State:',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(farmerDetails['state'] ,
                                                      textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                            Divider(color: Colors.grey),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    // height: 12,
                                                      margin: EdgeInsets.zero,
                                                      child: Text(
                                                        'City:',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(farmerDetails['city'],
                                                      textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                            Divider(color: Colors.grey),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    // height: 12,
                                                      margin: EdgeInsets.zero,
                                                      child: Text(
                                                        'Area:',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(farmerDetails['area'],
                                                      textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                            Divider(color: Colors.grey),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    // height: 12,
                                                      margin: EdgeInsets.zero,
                                                      child: Text(
                                                        'Pincode:',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(farmerDetails['pincode'],
                                                      textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                            Divider(color: Colors.grey),

                                          ],
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          )
                      ),

                      const Divider(height: 1,thickness: 5,color: AppColors.boxShadowColor,),
                      Text("Crop details",style: TextStyle(fontSize: 16,fontWeight:FontWeight.w500,color:Colors.grey[600]),),
                      Expanded(
                        // child: Text('hello'),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              int count = index;

                              return Card(
                                color: Color.fromRGBO(211, 248, 241, 1.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                        color: AppColors.boxShadowColor,
                                        width: 1
                                    )
                                ),
                                child: ListTile(
                                  onTap: () {
                                    // Navigator.pushReplacement(context,
                                    //     MaterialPageRoute(builder: (context) =>
                                    //
                                    //     ));
                                  },
                                  dense: true,
                                  leading: Column(children: [
                                    Text((index + 1).toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),),
                                    const Icon(Icons.grass)
                                  ],),
                                  title: Text(
                                      "Crop Name : ${cropData[index]['name']}\nPrice : ${cropData[index]['price']}Per Quintal"),
                                  subtitle: Text(
                                      "Quantity : ${cropData[index]['quantity']}Quintal  \t\nCrop type :${cropData[index]['type']}"),


                                ),
                              );
                            }

                        ),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }
}