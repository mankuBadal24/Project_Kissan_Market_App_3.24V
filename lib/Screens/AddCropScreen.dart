import 'package:kissan_market_app/SharedPreferences/UserSharedPreferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kissan_market_app/Api/ApiURL.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import 'package:kissan_market_app/json_data_classes/TypeOfCropData.dart';

class AddCropScreen extends StatefulWidget{
   AddCropScreen({super.key});
  @override
  State<AddCropScreen>createState()=>_AddCropScreenState();
}
class _AddCropScreenState extends State<AddCropScreen>{
  bool _isLoading=false;
  String URL= ApiURL.getURL();
  String ? selectedCropCode;
  String ? selectedPulseCode;
  String? selectedCropDesc;
  List<DropdownMenuItem<String>> typeOfCropListItems = [];
  List<DropdownMenuItem<String>> typeOfPulseListItems = [];
  TextEditingController nameOfCropCtrl=TextEditingController();
  TextEditingController quantityOfCropCtrl=TextEditingController();
  TextEditingController priceOfCropCtrl=TextEditingController();
  UserSharedPreferences pref= UserSharedPreferences();
  Map<String,String?>userData={};


typeOfCropCodeSelected(){
  TypeOfCrop typeofcrop=TypeOfCrop();
  final List<dynamic> typeOfCropData = typeofcrop.getTypeOfCrops()["type-of-Crop-data"];
  for (var itemData in typeOfCropData) {
    if (itemData['code']==selectedCropCode) {
      selectedCropDesc=itemData['description'];
    }
  }
  print(selectedCropDesc);
}
  setTypeOfCropsItems() {
    TypeOfCrop typeofcrop=TypeOfCrop();
    final List<dynamic> typeOfCropData = typeofcrop.getTypeOfCrops()["type-of-Crop-data"];
    for (var itemData in typeOfCropData) {
      typeOfCropListItems.add(
        DropdownMenuItem(
          value: itemData['code'],
          child: Text(
            itemData['description'],
            style:const TextStyle(color:AppColors.textColorBlue ,),
          ),
        ),
      );
    }
    final List<dynamic> typeOfPulse=typeofcrop.getTypeOfCrops()["Pulses"];
    for (var itemData in typeOfPulse) {
      typeOfPulseListItems.add(
        DropdownMenuItem(
          value: itemData['code'],
          child: Text(
            itemData['description'],
            style:const  TextStyle(color:AppColors.textColorBlue ),
          ),
        ),
      );
      // print("pulse----------------$itemData");
    }
  }
  textFieldClear(){
    nameOfCropCtrl.clear();
    quantityOfCropCtrl.clear();
    priceOfCropCtrl.clear();
    setState(() {
      selectedCropCode=null;
    });
  }

 Future addCrops() async{
   userData= await pref.loadUserData();
    print("addcrops is running........");
   FocusScope.of(context).requestFocus(FocusNode());
   setState(() {
     _isLoading=true;
   });
   const  timeoutDuration= Duration(seconds: 10);

      String uri = '${URL}api/crops/add';
      final addCropRequest =  http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json', // Set to JSON
        },
        body: jsonEncode({
          'name': nameOfCropCtrl.text,
           'type': selectedCropDesc,
          'quantity': quantityOfCropCtrl.text,
          'farmerId':userData["userId"].toString(),
          'cropCode':selectedCropCode,
          "price":priceOfCropCtrl.text
        }),
      );

      final response= await Future.any([addCropRequest,Future.delayed(timeoutDuration)]);
      print("response ------$response");
      try{
      if(response!=null){
        print("statis code-----------------${response.statusCode}");
        if(response.statusCode==200){
          var responseMsg = jsonDecode(response.body);
          print(responseMsg);
          if(responseMsg["status"]=="success") {
            print("helllo");
            textFieldClear();
            showQuickAlert(responseMsg["message"],"success");

          } else {
            showQuickAlert(response.statusCode,"warning");
          }
        }
      }
      else{
        showQuickAlert("Some Error Occurred","warning");

      }

    }
    catch(e){
      print("catch is running ");
      showQuickAlert("Some Exception Occurred","error");
    }
   finally{
     setState(() {
       _isLoading=false;
     });
   }

  }
  bool dataValidation(){
  if(nameOfCropCtrl.text.isEmpty||quantityOfCropCtrl.text.isEmpty||priceOfCropCtrl.text.isEmpty){
    showSnackBarMessage("fill All the fields");
    return false;
  }
  else if(selectedCropDesc == null){
    showSnackBarMessage("select all the fields");
    return false;
  }
  else if(selectedCropDesc=='Pulses'){
    if(selectedPulseCode==null){
      showSnackBarMessage("select all the fields");
      return false;
    }
    return true;
  }
  else{
    return true;
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

   showSnackBarMessage(String message ) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: AppColors.primaryColor, fontSize: 16),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: AppColors.backgroundColor,
      closeIconColor: AppColors.secondaryColor,
    ));
  }

  getUserCredentials()async{
  userData=await pref.loadUserData();
  print(userData);
  }

  @override
  void initState() {
    super.initState();
    getUserCredentials();
    setTypeOfCropsItems();

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomWidgets.appBar("Add Crop"),
      body: Stack(
        children: [
          Column(
            children: [
              CustomWidgets.textField("Name Of Crop", nameOfCropCtrl),
              CustomWidgets.textField("Quantity Of Crop in Quintal", quantityOfCropCtrl),
              CustomWidgets.textField("Price of Crop PerQuintal", priceOfCropCtrl),

              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Type Of Crops",style: TextStyle(fontSize: 15),),
                    DropdownButton<String>(
                      hint: const Text("Type Of Crops"),
                      focusColor: Colors.transparent,
                      padding: const EdgeInsets.all(10.0),
                      value: selectedCropCode,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCropCode = newValue!;
                          typeOfCropCodeSelected();
                        });
                      },
                      items: typeOfCropListItems,
                    ),

                  ],
                ),
              ),
              CustomWidgets.divider(),
              if(selectedCropCode=='PLS')
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Type Of Pulse",style: TextStyle(fontSize: 15),),
                          DropdownButton<String>(
                            hint: const Text("Type Of Pulse"),
                            focusColor: Colors.transparent,
                            padding: const EdgeInsets.all(10.0),
                            value: selectedPulseCode,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPulseCode = newValue!;
                              });
                            },
                            items: typeOfPulseListItems,
                          ),

                        ],
                      ),
                    ),
                    CustomWidgets.divider(),
                  ],
                ),

                 ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // foregroundColor:
                        backgroundColor:AppColors.primaryColor,
                        elevation: 0 // Text color
                    ),
                    onPressed: () {
                      if(dataValidation()){
                        addCrops();
                      }

                    },
                    child: CustomWidgets.textNormal("Add Crop"),
                ),

            ],
          ),
          if(_isLoading)
            Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )),

        ],
      ),
    );
  }
}