import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import 'package:http/http.dart' as http;
import '../Api/ApiURL.dart';
import '../CustomWidgets/CustomWidgets.dart';

class DriverListScreen extends StatefulWidget{
  const DriverListScreen({super.key});
  @override
  State<StatefulWidget> createState()=>_DriverListScreenState();

}
class _DriverListScreenState extends State<DriverListScreen>{

   late Future<List<dynamic>> driverData;
  bool _isLoading=false;
  String URL =ApiURL.getURL();
  late Uint8List bytes;



   // Fetch driver data and return as Future<List>
   Future<List<dynamic>> getDriverData() async {
     setState(() {
       _isLoading = true;
     });

     const timeoutDuration = Duration(seconds: 10);
     String uri = '${URL}api/drivers/all';

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
       throw Exception('Failed to load driver data');
     }
   }

  @override
  void initState() {
    super.initState();
    driverData = getDriverData(); // Initialize the future

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
      appBar: CustomWidgets.appBar('Drivers List Screen'),
      body: Stack(
            children: [
              Padding(padding: const EdgeInsets.all(5),
              child: FutureBuilder<List<dynamic>>(
                  future:driverData,
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
                          var wholeDriverData = snapshot.data!;
                          // Example of decoding base64 image and displaying it
                          if (wholeDriverData.isNotEmpty) {
                      return ListView.builder(
                        itemCount: wholeDriverData.length,
                          itemBuilder: (context,index){
                        return Card(
                          color: AppColors.listTileColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                children: [
                                   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            'assets/images/agriculture-working-men-talking-phone.jpg'),
                                      ),
                                      Text(wholeDriverData[index]['driverName'].toUpperCase(),style:const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),// Change the image as needed
                                     Row(
                                       children: [
                                         Text('Verified',style: TextStyle(color:  Colors.grey[600]),),
                                         const Icon(Icons.verified,color: Colors.green,)
                                       ],
                                     )
                                    ],
                                  ),
                                  customTextRow('Address',wholeDriverData[index]['address']),
                                  customTextRow('VehicleNo',wholeDriverData[index]['vehicleNo']),
                                  customTextRow('Rate per 100 Km','${wholeDriverData[index]['ratePer100Km'].toString()} Rs'),
                                  customTextRow('Max Capacity','${wholeDriverData[index]['maxCapacity'].toString()} Tons'),
                                  customTextRow('Experience','${wholeDriverData[index]['drivingExperience'].toString()} years'),
                                  customTextRow('Phone Number','+91-${wholeDriverData[index]['phoneNo']}'),
                                  customTextRow('Ratings',wholeDriverData[index]['rating'].toString()),


                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    }
                          else {
                            return  const Center(child: Text('No drivers available.'));
                          }
                  }
                  }),
              )
            ],
      ),
    );
  }
}