import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kissan_market_app/AppDrawerMenuScreen.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';
import 'package:kissan_market_app/FarmerDetailsScreen.dart';
import 'package:kissan_market_app/SaveUserData/SaveUserData.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import 'package:http/http.dart' as http;

import 'Api/ApiURL.dart';

class BuyerHomeScreen extends StatefulWidget{
  SaveUserData saveUserData=SaveUserData();
 BuyerHomeScreen({super.key,required this.saveUserData});
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
      drawer:  AppDrawerMenuScreen(saveUserData:widget.saveUserData,),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
              child: Container(
                color: Color(0xFFA3FFD7),
                child: GridView.count(
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  mainAxisSpacing: 40,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 0,
                  crossAxisCount: 2,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(0),
                          child: GestureDetector(
                            onTap: () {
                              cropCode='RCE';
                              getCrops();

                            },
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
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
                          margin: const EdgeInsets.all(0),
                          child: GestureDetector(
                            onTap: () {
                              cropCode='WHT';
                              getCrops();

                            },
                            child: const CircleAvatar(
                              radius: 50,
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
                          margin: const EdgeInsets.all(0),
                          child: GestureDetector(
                            onTap: () {
                              cropCode='SGC';
                              getCrops();
                            },
                            child: const CircleAvatar(
                              radius: 50,
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
                          margin: const EdgeInsets.all(0),
                          child: GestureDetector(
                            onTap: () {
                              cropCode='MZE';
                              getCrops();
                            },
                            child: const CircleAvatar(
                              radius: 50,
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
              // CustomWidgets.divider(),
              const Divider(color: Colors.green,height:1,),
              Expanded(
                child: ValueListenableBuilder(
                  /// When the length of list changes it auto rebuilds the LIStview Builder
                  valueListenable: cropDataLength,
                  builder: ( context, int listSize, child) {
                    return ListView.builder(
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>FarmerDetailsScreen(farmerId: cropData[index]['farmerId'].toString())));
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
                                  "Quantity : ${cropData[index]['quantity']} \t\t Farmer name:${cropData[index]['farmerName']}"),
                              trailing: IconButton(onPressed: () {
                              }, icon: const Icon(Icons.remove_red_eye)),

                            ),
                          );
                        }

                    );
                  },
                ),

              ),
            ],
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
