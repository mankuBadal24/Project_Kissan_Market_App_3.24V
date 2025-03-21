import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';
import 'package:kissan_market_app/Screens/FarmerHomeScreen.dart';
import 'package:kissan_market_app/Theme/AppColors.dart';
import 'package:kissan_market_app/json_data_classes/IndianStateCities.dart';
import '../Api/ApiURL.dart';
import '../SaveUserData/SaveUserData.dart';
import '../SharedPreferences/UserSharedPreferences.dart';
import '../json_data_classes/TypeOfFarmer.dart';


class FarmerRegistrationScreen extends StatefulWidget {
  SaveUserData saveUserData=SaveUserData();
   FarmerRegistrationScreen({super.key,required this.saveUserData});
  @override
  State<FarmerRegistrationScreen> createState() => _FarmerRegistrationState();
}

class _FarmerRegistrationState extends State<FarmerRegistrationScreen> {
  String? selectedTypeOfFarmer;         /// variable to hold the type of farmer value
  String? selectedState;
  String? selectedCity;


  UserSharedPreferences pref=UserSharedPreferences();
  bool _isLoading = false;
  final bool _isDisposed = false;
  String URL = ApiURL.getURL();

  TextEditingController houseNoCtrl=TextEditingController();
  TextEditingController pinCodeCtrl=TextEditingController();
  
  late String indianStateData;
  List<DropdownMenuItem<String>> indianStateItems = [];
  List<DropdownMenuItem<String>> indianCitiesItems = [];
  List<DropdownMenuItem<String>> typeOfFarmerListItems = [];  /// list for type of farmers
  
  IndianStateCities indianStateCities=IndianStateCities();
  bool flag=false;
  
  late Map<String, dynamic> indianStateList;
  List<Color> dropDownColor = AppColors.dropDownColor;/// list of colors for the color of the drop down text

   setTypeOfFarmerDropdownItems() {
    // String typeOfFarmerStringData = aw0ait rootBundle.loadString('assets/data/JSON/typeOfFarmer.json');
    TypeOfFarmer typeoffarmer=TypeOfFarmer();
    final List<dynamic> typeOfFarmerData = typeoffarmer.getFarmerType()["type-of-farmer-data"];
    int index = 0;
    for (var itemData in typeOfFarmerData) {
      typeOfFarmerListItems.add(
        DropdownMenuItem(
          value: itemData['code'],
          child: Text(
            itemData['description'],
            style: TextStyle(fontWeight: FontWeight.bold, color: dropDownColor[index++]),
          ),
        ),
      );
    }
  }

   setIndianStateDropDownItems()  {

    ///below two lines used to fetch data from json file from assets but it requires function to be async that is why second method is used
    // indianStateData=await rootBundle.loadString('assets/data/JSON/Indian_Cities_In_States_JSON.json');
    // indianStateList=jsonDecode(indianStateData) ;

    indianStateList=indianStateCities.getIndianStateCities();
    
    indianStateList.forEach((state, value) {
      indianStateItems.add(
        DropdownMenuItem(
          value: state,
          child: Text(state),
        ),
      );
    });
  }


  showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: AppColors.snackBarTextColor, fontSize: 16),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: AppColors.secondaryColor,
      closeIconColor: AppColors.secondaryColor,
    ));
  }


  bool dataValidation(){
    if (houseNoCtrl.text == '' ||
        pinCodeCtrl.text == '') {
      showSnackBarMessage(
          "Fill all the fields!...");
      return false;
    } else if (selectedState==null||selectedCity==null||selectedTypeOfFarmer==null) {
      showSnackBarMessage(
          'Select all the fields!...');
      return false;
    }
    else if(pinCodeCtrl.text.length<6){
      showSnackBarMessage(
          'Pincode must be of 6 digits!...');
      return false;
    }
    else{
      return true;
    }
  }


  setCity() {
    // Clear previous city list before adding new cities
    indianCitiesItems.clear();
    try {

        // Add cities for the selected state
        for (var item in indianStateList[selectedState]) {
          indianCitiesItems.add(
            DropdownMenuItem(
              value: item.toString(),
              child: Text(item.toString()),
            ),
          );

      }

      // If no cities were added, add a "No Cities Available" option
      if (indianCitiesItems.isEmpty) {
        indianCitiesItems.add(
          const DropdownMenuItem(
            value: '',
            child: Text('No Cities Available'),
          ),
        );
      }


        // newindianCitiesItems = List.from(indianCitiesItems);
    } catch (e) {
      print("Exception in setting city list: $e");
    }
  }



  Future<void>registerFarmer() async {
    // Hide the keyboard when updating the crop
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _isLoading = true;
    });

    try {
      const timeoutDuration = Duration(seconds: 5);
      String uri = '${URL}api/farmer-register';
      final updateRequest = http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json', // Set to JSON
        },
        body: jsonEncode(
          {
            "id":int.parse(widget.saveUserData.getUserId()),
            "farmerType":selectedTypeOfFarmer,
            "state":selectedState,
            "city":selectedCity,
            "area":houseNoCtrl.text,
            "pincode":pinCodeCtrl.text

          },
        ),
      );

      final response = await Future.any([updateRequest, Future.delayed(timeoutDuration)]);

      if (_isDisposed) return;  // If widget is disposed, exit the function early.

      if (response != null) {
        print(response.statusCode);

        Map<String,dynamic> responseMsg = jsonDecode(response.body);
        if ((response.statusCode == 200||response.statusCode == 201)&&responseMsg["status"]=="success") {

          // textFieldClear();
          showQuickAlert(responseMsg["message"], 'success');
          await pref.saveUserData(widget.saveUserData.getName(), widget.saveUserData.getUserId(),'FR' ,widget.saveUserData.getPhoneNumber());
         await Future.delayed(const Duration(seconds: 1));
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> FarmerHomeScreen()));
        } else {
          showQuickAlert(responseMsg["message"], 'warning');
          print(responseMsg["message"]);
        }
      } else {
        showQuickAlert('Server Unreachable...', 'warning');
      }
    } catch (e) {
      showQuickAlert("Some Exception Occurred..$e", 'error');
      print(e);
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


  //
  //
  // Future<void> _loadUserData() async {
  //   Map<String, String?> userData = await userSharedPreferences.loadUserData();
  //   _name = userData['name'] ?? "No name set";
  //   _userId = userData['userId'] ?? "No ID set";
  //   _typeOfUser = userData['typeOfUser'] ?? "No type set";
  //
  // }

  @override
  void initState() {
    super.initState();
    print(widget.saveUserData.getUserId());
    setTypeOfFarmerDropdownItems();
    setIndianStateDropDownItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomWidgets.appBar("Farmer Registration Page"),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Type of Farmer Dropdown
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     const Text("Type Of farmer",style: TextStyle(fontSize: 15),),
                      DropdownButton<String>(
                        hint: const Text("Type Of Farmer"),
                        focusColor: Colors.transparent,
                        padding: const EdgeInsets.all(10.0),
                        value: selectedTypeOfFarmer,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTypeOfFarmer = newValue!;
                          });
                        },
                        items: typeOfFarmerListItems,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 4,
                  color: AppColors.primaryColor,
                ),

                // Indian State Dropdown
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:   [
                      const Text("State",style: TextStyle(fontSize: 15),),
                      DropdownButton<String>(
                        hint:const Text('Select State'),
                        value: selectedState,

                        padding: const EdgeInsets.all(10.0),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedState = newValue;
                            selectedCity = null; // Reset city when state changes
                            setCity();
                          });
                        },
                        items: indianStateList.keys.map((dynamic state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 4,
                  color: Colors.blueAccent,
                ),




                // City Dropdown
                if (selectedState != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("City",style: TextStyle(fontSize: 15)),
                        DropdownButton<String>(
                          hint:const Text('Select City'),
                          value: selectedCity,
                            padding: const EdgeInsets.all(10.0),

                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCity = newValue;
                            });
                          },
                          items: indianCitiesItems
                          // indianStateList[selectedState]!
                          //     .map((String city) {
                          //   return DropdownMenuItem<String>(
                          //     value: city,
                          //     child: Text(city),
                          //   );
                          // }).toList(),
                        ),
                      ],
                    ),
                  ),
                if (selectedState != null)
                Container(
                  height: 4,
                  color: Colors.blueAccent,
                ),

                // Additional Form Fields (e.g., House No./Village/Local Area and PinCode)

                CustomWidgets.textField("House No./Village/Local Area", houseNoCtrl),

                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppColors.borderColor))),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6)
                    ],
                    controller: pinCodeCtrl,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'PinCode',
                      labelStyle: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        gradient:AppColors.buttonGradient),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // foregroundColor:
                          backgroundColor: Colors.transparent,
                          elevation: 0 // Text color
                      ),
                      onPressed: () {
                        setState(() {

                        if(dataValidation()){
                        registerFarmer();

                        }
                        });

                        },

                      child: const Text("Submit",style: TextStyle(fontSize: 18),)
                    )
                 ),

              ],
            ),
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
