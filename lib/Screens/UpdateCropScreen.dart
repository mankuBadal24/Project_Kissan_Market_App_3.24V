import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import '../Api/ApiURL.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'ViewCropsScreen.dart';
class UpdateCropScreen extends StatefulWidget{
  final String cropCode;
  final String name;
  final String type;
  final String price;
  final String quantity;
  final String farmerId;
  final String cropId;
    UpdateCropScreen({super.key,
    required this.cropCode,required this.name,
    required this.type,required this.price,
    required this.quantity,required this.farmerId,
     required this.cropId,
});

  @override
  State<UpdateCropScreen>createState()=>_UpdateCropScreenState();

}
class _UpdateCropScreenState extends State<UpdateCropScreen> {
  TextEditingController cropNameCtrl = TextEditingController();
  TextEditingController cropPriceCtrl = TextEditingController();
  TextEditingController cropQuantityCtrl = TextEditingController();
  bool _isLoading = false;
  bool _isDisposed = false;  // Track if the widget is disposed

  String URL = ApiURL.getURL();

  @override
  void initState() {
    super.initState();
    cropNameCtrl.text = widget.name;
    cropPriceCtrl.text = widget.price;
    cropQuantityCtrl.text = widget.quantity;
  }

  @override
  void dispose() {
    // Mark the widget as disposed
    _isDisposed = true;

    // Dispose controllers to prevent memory leaks
    cropNameCtrl.dispose();
    cropPriceCtrl.dispose();
    cropQuantityCtrl.dispose();

    super.dispose();
  }

  Future<void> updateCrop() async {
    // Hide the keyboard when updating the crop
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _isLoading = true;
    });

    try {
      const timeoutDuration = Duration(seconds: 5);
      String uri = '${URL}api/crops/update';

      final updateRequest = http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json', // Set to JSON
        },
        body: jsonEncode(
          {
            "cropId": widget.cropId,
            "cropDetails": {
              "cropCode": widget.cropCode,
              "name": cropNameCtrl.text,
              "type": widget.type,
              "price": cropPriceCtrl.text,
              "quantity": cropQuantityCtrl.text,
              "farmerId": widget.farmerId
            }
          },
        ),
      );

      final response = await Future.any([updateRequest, Future.delayed(timeoutDuration)]);

      if (_isDisposed) return;  // If widget is disposed, exit the function early.

      if (response != null) {
        if (response.statusCode == 200) {
          var responseMsg = jsonDecode(response.body);
          await showQuickAlert(responseMsg["message"], 'success');
          textFieldClear();
          // Future.delayed(const Duration(seconds: 1));

        } else {
          showQuickAlert(response.statusCode, 'warning');
        }
      } else {
        showQuickAlert('Some Exception Occurred!', 'error');
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

  void textFieldClear() {
    cropNameCtrl.clear();
    cropPriceCtrl.clear();
    cropQuantityCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appBar("Update Crop"),
      body: Stack(
        children: [
          Column(
            children: [
              CustomWidgets.textField("Crop Name", cropNameCtrl),
              CustomWidgets.textField("Crop Price", cropPriceCtrl),
              CustomWidgets.textField("Crop Quantity", cropQuantityCtrl),
              Container(
                padding: const EdgeInsets.all(10),
                color: AppColors.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomWidgets.textNormal("Crop Code:    ${widget.cropCode}"),
                    CustomWidgets.textNormal("Crop Id:   ${widget.cropId}"),
                  ],
                ),
              ),

      ElevatedButton(
        onPressed: () async {

          updateCrop();
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=> ViewCropsScreen() ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,          // Set the button color
          elevation: 2.0,    // Set the button elevation
        ),
        child: CustomWidgets.textNormal('Update Crop'),         // Set the text of the button
      ),

    ],
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
