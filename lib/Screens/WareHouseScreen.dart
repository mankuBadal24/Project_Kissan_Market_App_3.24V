import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import 'package:http/http.dart' as http;
import '../Api/ApiURL.dart';
import '../CustomWidgets/CustomWidgets.dart';

class WareHouseScreen extends StatefulWidget{
  const WareHouseScreen({super.key});
  @override
  State<StatefulWidget> createState()=>_WareHouseScreenState();

}
class _WareHouseScreenState extends State<WareHouseScreen>{

  late Future<List<dynamic>> wareHouseData;
  bool _isLoading=false;
  String URL =ApiURL.getURL();

  // Fetch wareHouse data and return as Future<List>
  Future<List<dynamic>> getWareHouseData() async {
    setState(() {
      _isLoading = true;
    });

    const timeoutDuration = Duration(seconds: 10);
    String uri = '${URL}api/warehouses/all';

    final response = await http
        .post(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json', // Set to JSON
      },
      body: jsonEncode({}),
    )
        .timeout(timeoutDuration); // Add timeout here directly

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Successful response
      return jsonDecode(response.body); // Returning the parsed JSON data as a List
    } else {
      // Error occurred, handle it
      throw Exception('Failed to load wareHouse data');
    }
  }

  @override
  void initState() {
    super.initState();
    wareHouseData = getWareHouseData(); // Initialize the future

  }
  Widget customTextRow(String field,String text){
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                // height: 12,
                  margin: EdgeInsets.zero,
                  child: Text(
                    field,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(text,
                  textAlign: TextAlign.right, style:const TextStyle(fontSize: 12)),
            ),

          ],
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return  Scaffold(
      appBar: CustomWidgets.appBar('WareHouse List Screen'),
      body: Stack(
        children: [
          Padding(padding: const EdgeInsets.all(5),
            child: FutureBuilder<List<dynamic>>(
                future:wareHouseData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While waiting for the data, show a loading indicator
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // If there's an error in fetching data, show an error message
                    return const Center(child:
                    const Text('No data available.') /* Text('Error: ${snapshot.error}')*/);
                  }
                  else if (!snapshot.hasData || snapshot.data == null) {
                    // If there's no data, show a no data message
                    return const Center(child: Text('No data available.'));
                  } else {
                    // Data is available
                    var wholeWareHouseData = snapshot.data!;
                    // Example of decoding base64 image and displaying it
                    if (wholeWareHouseData.isNotEmpty) {
                      return ListView.builder(
                          itemCount: wholeWareHouseData.length,
                          itemBuilder: (context,index){
                            return Card(
                              elevation: 5,
                              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
                              side: BorderSide(width: 2,color: AppColors.primaryColor)) ,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                         Icon(Icons.warehouse_outlined,size: 50,color: AppColors.primaryColor,),
                                          Text(wholeWareHouseData[index]['placeName'].toUpperCase(),style:const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),// Change the image as needed
                                          Row(
                                            children: [
                                              Text('Verified',style: TextStyle(color:  Colors.grey[600]),),
                                              const Icon(Icons.verified,color: Colors.green,)
                                            ],
                                          )
                                        ],
                                      ),
                                      customTextRow('Owner',wholeWareHouseData[index]['ownerName']),
                                      customTextRow('Available Crops',wholeWareHouseData[index]['cropsAvailable']),
                                      customTextRow('Purchase Rate','₹ ${wholeWareHouseData[index]['ratePerQuintalPurchase'].toString()} Per Quintal'),
                                      customTextRow('Max Capacity','${wholeWareHouseData[index]['maximumCapacity'].toString()} Tons'),
                                      customTextRow('Current Capacity','${wholeWareHouseData[index]['currentCapacity'].toString()} Tons'),


                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    else {
                      return  const Center(child: Text('No Warehouse available.'));
                    }
                  }
                }),
          )
        ],
      ),
    );
  }
}