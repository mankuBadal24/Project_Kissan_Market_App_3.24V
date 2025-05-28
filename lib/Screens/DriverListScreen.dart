import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import 'package:http/http.dart' as http;
import '../Api/ApiURL.dart';
import '../CustomWidgets/CustomWidgets.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});
  @override
  State<StatefulWidget> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  late Future<List<dynamic>> driverData;
  bool _isLoading = false;
  String URL = ApiURL.getURL();
  late Uint8List bytes;

  // ✅ FIXED: Properly extract only the 'data' list from the response
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
        .timeout(timeoutDuration);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load driver data');
    }
  }

  @override
  void initState() {
    super.initState();
    driverData = getDriverData();
  }

  Widget customTextRow(String field, String text) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
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
                  textAlign: TextAlign.right, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appBar('Drivers List Screen'),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: FutureBuilder<List<dynamic>>(
                future: driverData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('No data available.'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data available.'));
                  } else {
                    var wholeDriverData = snapshot.data!;
                    if (wholeDriverData.isNotEmpty) {
                      return ListView.builder(
                          itemCount: wholeDriverData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                      width: 2, color: AppColors.primaryColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.grey[300],
                                            child: ClipOval(
                                              child: Image.network(
                                                '${URL}api/drivers/photo/${wholeDriverData[index]['driverId']}', // Use dynamic ID
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Icon(Icons.error, color: Colors.red); // Agar image fail ho
                                                },
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return CircularProgressIndicator(); // Jab tak image load ho
                                                },
                                              ),
                                            ),
                                          ),
                                          Text(
                                            wholeDriverData[index]['driverName']
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Verified',
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                              const Icon(
                                                Icons.verified,
                                                color: Colors.green,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      customTextRow('Address',
                                          wholeDriverData[index]['address']),
                                      customTextRow('VehicleNo',
                                          wholeDriverData[index]['vehicleNo']),
                                      customTextRow(
                                          'Rate per 100 Km',
                                          '₹ ${wholeDriverData[index]['ratePer100Km'].toString()} '),
                                      customTextRow(
                                          'Max Capacity',
                                          '${wholeDriverData[index]['maxCapacity'].toString()} Tons'),
                                      customTextRow(
                                          'Experience',
                                          '${wholeDriverData[index]['drivingExperience'].toString()} years'),
                                      customTextRow(
                                          'Phone Number',
                                          '+91-${wholeDriverData[index]['phoneNo']}'),
                                      customTextRow('Ratings',
                                          wholeDriverData[index]['rating'].toString()),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(child: Text('No drivers available.'));
                    }
                  }
                }),
          )
        ],
      ),
    );
  }
}
