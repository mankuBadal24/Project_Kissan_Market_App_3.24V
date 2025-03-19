import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kissan_market_app/Screens/AppDrawerMenuScreen.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';
import 'package:kissan_market_app/Screens/FarmerDetailsScreen.dart';
import 'package:kissan_market_app/SaveUserData/SaveUserData.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import 'package:http/http.dart' as http;

import '../Api/ApiURL.dart';

class BuyerHomeScreen extends StatefulWidget{
 BuyerHomeScreen({super.key});
 @override
 State<BuyerHomeScreen>createState()=>_BuyerHomeScreenState();
}
class _BuyerHomeScreenState extends State<BuyerHomeScreen>{
  late ValueNotifier<int> cropDataLength= ValueNotifier<int>(0);
  List cropData=[];
  late String cropCode;
  bool _isLoading = false;
  bool _isDisposed = false;
  String URL = ApiURL.getURL();
  String headingText='';
  final double avatarRadius=40;
  Future<void> getCrops() async {
    setState(() {
      _isLoading = true;
    });

    try {
      const timeoutDuration = Duration(seconds: 5);
      String uri = '${URL}api/crops/details';

      final updateRequest = http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json', // Set to JSON
        },
        body: jsonEncode(
          {
            "cropCode":cropCode

          },
        ),
      );

      final response = await Future.any([updateRequest, Future.delayed(timeoutDuration)]);

      if (_isDisposed) return;  // If widget is disposed, exit the function early.

      if (response != null) {
        if (response.statusCode == 200) {
          cropData = jsonDecode(response.body);
          // cropDataLength=cropData.length as ValueNotifier<int>;
          print(cropData);
          // showQuickAlert(responseMsg, 'success');
          // Future.delayed(const Duration(seconds: 2));
        } else {
          // showQuickAlert(response.statusCode, 'warning');
        }
      } else {
        // showQuickAlert('Some Exception Occurred!', 'error');
      }
    } catch (e) {
      if (!_isDisposed) {
      }
    } finally {
      if (!_isDisposed) {
        setState(() {
          _isLoading = false;
        });

      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomWidgets.appBar("Buyer Home Screen"),
      drawer:  AppDrawerMenuScreen(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
              child: Container(color: Color.fromRGBO(218, 215, 215, 1.0),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 2,color: AppColors.primaryColor),
                      color:  Color.fromRGBO(248, 246, 246, 1.0)),
                    child: GridView.count(
                      padding: const EdgeInsets.only(top: 25),
                      shrinkWrap: true,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 0,
                      crossAxisCount: 2,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: AppColors.primaryColor,

                              ),
                              margin: const EdgeInsets.all(0),
                              child: GestureDetector(
                                onTap: () {
                                  cropCode='RCE';
                                  getCrops();
                                  headingText="Rice";
                                },
                                child: CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundImage: const AssetImage(
                                      'assets/images/sack-rice-with-rice-plant-place-wooden-floor (1).jpg'),
                                ),
                              ),
                            ),

                                const Text('Rice'),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: AppColors.primaryColor,

                              ),
                              margin: const EdgeInsets.all(0),
                              child: GestureDetector(
                                onTap: () {
                                  cropCode='WHT';
                                  getCrops();
                                  headingText="Wheat";
                                },
                                child:  CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundImage: AssetImage(
                                      'assets/images/wheat_grain_image.png'),
                                ),
                              ),
                            ),

                            const Text('Wheat'),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: AppColors.primaryColor,

                              ),
                              margin: const EdgeInsets.all(0),
                              child: GestureDetector(
                                onTap: () {
                                  cropCode='SGC';
                                  getCrops();
                                  headingText="SugarCane";
                                },
                                child:  CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundImage: AssetImage(
                                      'assets/images/Sugarcane.jpg'),
                                ),
                              ),
                            ),
                            const Text('Sugarcane'),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: AppColors.primaryColor,

                              ),
                              margin: const EdgeInsets.all(0),
                              child: GestureDetector(
                                onTap: () {
                                  cropCode='MZE';
                                  getCrops();
                                  headingText="Maize";
                                },
                                child:  CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundImage: AssetImage(
                                      'assets/images/Maize.jpg'),
                                ),
                              ),
                            ),
                            const Text('Maize'),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              ),
              const Divider(color: Colors.green,height:1,),
                Text('Available ${headingText} Crop List ',style: const TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),),
              // CustomWidgets.divider(),

              Expanded(
                child: ValueListenableBuilder(
                  /// When the length of list changes it auto rebuilds the LIStview Builder
                  valueListenable: cropDataLength,
                  builder: ( context, int listSize, child) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: cropData.length,
                        itemBuilder: (context, index) {
                          return Card(
                            // color:const Color.fromRGBO(164, 199, 250, 1.0) ,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(
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
                                   IconButton(onPressed: (){   Navigator.push(context,
                                       MaterialPageRoute(builder: (context) =>FarmerDetailsScreen(farmerId: cropData[index]['farmerId'].toString())));
                                   }, icon: Icon(Icons.remove_red_eye_outlined,color: AppColors.primaryColor,))
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
                                    Expanded(child:  Text("Price : ₹ ${cropData[index]['price']} ",style: TextStyle(fontSize: 16,)))

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
                                Divider(),
                                Row(
                                  children: [
                                    Icon(Icons.person,color: AppColors.primaryColor,),
                                    SizedBox(width: 8,),
                                    Expanded(child:  Text("Farmer name:${cropData[index]['farmerName']}",style: TextStyle(fontSize: 16,)))

                                  ],
                                ),


                              ],),
                            )
                          );
                        }

                    );
                  },
                ),

              ),
            ],
          ),
          if(_isLoading)
            Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),

        ],

      ),
    );
  }
}


