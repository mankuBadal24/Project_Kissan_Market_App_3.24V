import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kissan_market_app/Api/ApiURL.dart';
import 'package:kissan_market_app/BuyerHomeScreen.dart';
import 'package:kissan_market_app/Providers/UserUpdateNotifier.dart';
import 'package:kissan_market_app/SaveUserData/SaveUserData.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:kissan_market_app/FarmerHomeScreen.dart';

import 'CustomWidgets/CustomWidgets.dart';
import 'FarmerRegistrationScreen.dart';
import 'SharedPreferences/UserSharedPreferences.dart';
import 'Theme/AppColors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String URL = ApiURL.getURL();
  var responseMsg;
  UserSharedPreferences userSharedPreferences=UserSharedPreferences();
  SaveUserData saveUserData=SaveUserData();
  bool _bgimageflag = true;
  bool crl_avtar_img_flag = true;
  bool _isLoading=false;
  bool _isObscured = true;
  bool _isCardVisible = true;
  late String typeOfUser;
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController cnfmPassCtrl = TextEditingController();

  void _togglePasswordVisibilty() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }


  Future<void> userRegistration() async {
    setState(() {
      _isLoading=true;
    });

    FocusScope.of(context).requestFocus(FocusNode());
    try {
      String uri = '${URL}api/register';
      final res = await http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json', // Set to JSON
        },
        body: jsonEncode({
          'name': nameCtrl.text,
          'phoneNumber': phoneCtrl.text,
          'password': passwordCtrl.text,
          'role':typeOfUser
        }),
      );



      final responseCode = res.statusCode;
      print("responecode...................$responseCode");
      responseMsg = jsonDecode(res.body);
      print(responseMsg);
      if (responseCode==200||responseCode==201) {
        showQuickAlert('Login Successful','success');
        saveUserData.saveUserId(responseMsg['userId'].toString());
        print(saveUserData.getUserId());
        saveUserData.saveTypeOfUser(typeOfUser);
        saveUserData.saveName(nameCtrl.text.toString());
        textFieldClear();
        showQuickAlert("User Registered Successfully", 'success');
          await Future.delayed(const Duration(seconds: 1));
         if(typeOfUser=='FR'){
           Future.delayed(const Duration(seconds: 1));
           Navigator.push(context, MaterialPageRoute(builder: (context)=>FarmerRegistrationScreen(saveUserData: saveUserData,)),);
         }
         else if(typeOfUser=='BR'){
           Future.delayed(const Duration(seconds: 1));
           Navigator.push(context, MaterialPageRoute(builder: (context)=>const BuyerHomeScreen()),);
         }



      } else {
        showQuickAlert("Some Error Occurred....","warning" );
      }
    } catch (e, stackTrace) {
      print("catch is running ${stackTrace}");
      print("catch is running $e");
      showSnackBarMessage("Some Exception Occurred....$e");
      showQuickAlert("Some Exception Occurred....", "error");
    }
    finally{
      setState(() {
        _isLoading=false;
      });
    }
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

  Future<void> userLogin() async {
    ///to down the keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _isLoading=true;
    });
    try{
    const  timeoutDuration= Duration(seconds: 5);
    final Map<String, dynamic> params = {
      'phoneNumber': int.parse(phoneCtrl.text),
      'password': passwordCtrl.text,
    };
    String uri = '${URL}api/login';
    print(uri);
    final loginRequest =  http.post(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json', // Set to JSON
      },
      body: jsonEncode(
          {'phoneNumber': phoneCtrl.text, 'password': passwordCtrl.text}),
    );

    final response= await Future.any([loginRequest,Future.delayed(timeoutDuration)]);

      if(response!=null){
        if(response.statusCode==200){
          var responseMsg = jsonDecode(response.body);
          print(responseMsg);
          saveUserData.saveUserId(responseMsg['id'].toString());
          saveUserData.saveTypeOfUser(responseMsg['role']);
          saveUserData.saveName(responseMsg['name']);
            textFieldClear();
          if(responseMsg['role']=='FR'){
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  FarmerHomeScreen(saveUserData: saveUserData,)));
            });
          }
          else if(responseMsg['role']=='BR'){
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const BuyerHomeScreen()));
            });
          }


        }
        else{
         showQuickAlert(response.statusCode,'warning');
        }
      }
      else{
        showQuickAlert('Server Unreachable...','error');
      }

    }
    catch(e){

      print("catch is running ");
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Some Exception Occurred....",
      );
    }
    finally{
      setState(() {
        _isLoading=false;
      });
    }


  }
  showQuickAlert(String message ,String type){
    if(type=='success'){
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: message,
        autoCloseDuration: const Duration(seconds: 1),
      );
    }
    else if(type=='error'){
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: message,
      );
    }
    else if(type=='warning'){
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: message,
      );
    }
  }

  bool registerDataValidation(){
    if (nameCtrl.text == '' ||
        passwordCtrl.text == '' ||
        phoneCtrl.text == '' ||
        cnfmPassCtrl.text == '') {
      showSnackBarMessage(
          "Fill all the fields!...");
      return false;
    } else if(phoneCtrl.text.length<10){
      showSnackBarMessage(
          "Phone Number Must be of 10 digit");
      return false;
    }
    else if (passwordCtrl.text !=
        cnfmPassCtrl.text) {
      showSnackBarMessage(
          'Enter Password Carefully!...');
      passwordCtrl.clear();
      cnfmPassCtrl.clear();
      return false;
    }
    else{
      return true;
    }
  }

  bool loginDataValidation(){
    if (passwordCtrl.text == '' ||
        phoneCtrl.text == '' ) {
      showSnackBarMessage(
          "Fill all the fields!...");
      return false;
    } else if(phoneCtrl.text.length<10){
      showSnackBarMessage(
          "Phone Number Must be of 10 digit");
      return false;
    }

    else{
      return true;
    }
  }

  textFieldClear() {
    nameCtrl.clear();
    passwordCtrl.clear();
    phoneCtrl.clear();
    cnfmPassCtrl.clear();
  }

  // CustomWidgets.showSnackBarMessage(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(
  //       message,
  //       style: const TextStyle(color: AppColors.primaryColor, fontSize: 16),
  //     ),
  //     duration: const Duration(seconds: 1),
  //     backgroundColor: AppColors.backgroundColor,
  //     closeIconColor: AppColors.secondaryColor,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false, /// prevents the background image from moving when keyboard opens
        backgroundColor: AppColors.backgroundColor,

        /// this is main body stack which contains the background images and all the content
        body: Stack(
          children: [


            ///Container contains the first background image
            Container(
              width: double.infinity,
              height: double.infinity,
              child: AnimatedOpacity(
                opacity: _bgimageflag ? 1.0 : 0.0,
                duration: const Duration(seconds: 2),
                child: Image.asset(
                  'assets/images/wheat-grain-image-yellow.jpg',
                  fit: BoxFit.fill,
                ), // Change the image as needed
              ),
            ),

            ///contains the second background image
            Container(
              width: double.infinity,
              height: double.infinity,
              child: AnimatedOpacity(
                opacity: _bgimageflag ? 0.0 : 1.0,
                duration: const Duration(seconds: 2),
                child: Image.asset(
                  'assets/images/rice-plant-green.jpg',
                  fit: BoxFit.fill,
                ), // Change the image as needed
              ),
            ),

            ///Top Login/signup text
            Positioned(
              top: 20,
              left: 140,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: Container(
                    decoration: const BoxDecoration(
                        //color: AppColors.secondaryColor,

                        ),
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                          opacity: _isCardVisible ? 1.0 : 0.0,
                          duration: const Duration(seconds: 2),
                          child: const Text("Login",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30)),
                        ),
                        AnimatedOpacity(
                          opacity: _isCardVisible ? 0.0 : 1.0,
                          duration: const Duration(seconds: 2),
                          child: const Text("SignUp",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30)),
                        )
                      ],
                    )),
              ),
            ),

            ///Center widget which contains  the main card
            Center(
                child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(20.0),
                // color: Colors.transparent,
                // elevation: 0,
                child: Column(
                  //mainAxisSize: MainAxisSize.min,

                  children: [
                    ///Tab bar menu
                    Container(
                        child: DefaultTabController(
                      length: 2,
                      child: TabBar(
                          labelColor: AppColors.primaryColor,
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor),
                          tabs: const [Tab(text: 'Login'), Tab(text: "Signup")],
                          onTap: (index) {
                            switch (index) {
                              case 0:
                                setState(() {
                                  _isCardVisible = true;
                                  _bgimageflag = true;
                                  textFieldClear();
                                });
                                break;
                              case 1:
                                setState(() {
                                  _isCardVisible = false;
                                  _bgimageflag = false;
                                  textFieldClear();
                                });
                                break;
                            }
                          }),
                    )),
                    ///stack for Avatar images changing on pressing the avatar
                    Stack(children: [
                      /// Login Card
                      Visibility(
                        visible: _isCardVisible,
                        child: Card(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          crl_avtar_img_flag =
                                              !crl_avtar_img_flag;
                                        });
                                      },
                                      child: AnimatedOpacity(
                                        opacity: crl_avtar_img_flag ? 1.0 : 0.0,
                                        duration: const Duration(seconds: 2),
                                        child: const CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                              'assets/images/agriculture-working-men-talking-phone.jpg'),
                                        ), // Change the image as needed
                                      ),
                                    ),
                                  ),

                                  ///container for cicular avatar... two avatar putting in a stack to show while other is hiding in the background
                                  Container(
                                    margin: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          crl_avtar_img_flag =
                                              !crl_avtar_img_flag;
                                        });
                                      },
                                      child: AnimatedOpacity(
                                        opacity: crl_avtar_img_flag ? 0.0 : 1.0,
                                        duration: const Duration(seconds: 2),
                                        child: const CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                              'assets/images/agricluture-working-women.jpg'),
                                        ), // Change the image as needed
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              /// this container contains the Login form ... for input login or email and password Forgot password and Login submit button
                              Container(
                                alignment: Alignment.bottomCenter,
                                //padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                          color:
                                            AppColors.boxShadowColor,
                                          blurRadius: 20.0,
                                          offset: Offset(0, 10)),
                                    ]),
                                child: Column(
                                  children: [
                                    /// container contains textfield for email or phone
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: AppColors.borderColor))),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(10)
                                        ],
                                        controller: phoneCtrl,
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                        ),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '+91-Phone number',
                                          labelStyle: TextStyle(
                                              color: AppColors.primaryColor),
                                        ),
                                      ),

                                      // TextField(
                                      //   decoration: InputDecoration(
                                      //     border: InputBorder.none,
                                      //     hintText: "Email or Phone number",
                                      //     hintStyle: TextStyle(color:AppColors.borderColor[400])
                                      //   ),
                                      // ),
                                    ),

                                    /// this container contains password textfield of password criteria
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: AppColors.borderColor))),
                                      child: TextFormField(
                                          controller: passwordCtrl,
                                          obscureText: _isObscured,
                                          style: const TextStyle(
                                            color: AppColors.primaryColor,
                                          ),
                                          decoration: InputDecoration(
                                              border:
                                                  const OutlineInputBorder(),
                                              labelText: 'Password ',
                                              labelStyle: const TextStyle(
                                                  color: AppColors.primaryColor),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _isObscured
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                                onPressed:
                                                    _togglePasswordVisibilty,
                                              ))),
                                    ),
                                  ],
                                ),
                              ),

                              /// the container contains the Forgot password text
                              Container(
                                child: const Text("Forgot Password?",
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                    Color.fromRGBO(50, 137, 255, 1.0),
                                    Color.fromRGBO(52, 147, 244, 0.6),
                                  ])),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        // foregroundColor:
                                        backgroundColor: Colors.transparent,
                                        elevation: 0 // Text color
                                        ),
                                    onPressed: () {
                                      if (loginDataValidation()){
                                        ///this function initiate login procedure
                                        userLogin();
                                      }
                                     
                                    },
                                    child: const Text("Login",style: TextStyle(color: AppColors.secondaryColor),),
                                  )),
                            ],
                          ),
                        ),
                      ),

                      ///this widget contains signUp card as a child
                      Visibility(
                        visible: !_isCardVisible,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              //padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10)),
                                  ]),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: AppColors.borderColor))),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                                      ],
                                      controller: nameCtrl,
                                      style: const TextStyle(
                                        color: AppColors.primaryColor,
                                      ),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Name',
                                        labelStyle:
                                            TextStyle(color: AppColors.primaryColor),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: AppColors.borderColor))),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10)
                                      ],
                                      controller: phoneCtrl,
                                      style: const TextStyle(
                                        color: AppColors.primaryColor,
                                      ),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: '+91-Phone Number',
                                        labelStyle:
                                            TextStyle(color: AppColors.primaryColor),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: AppColors.borderColor))),
                                    child: TextFormField(
                                        controller: passwordCtrl,
                                        obscureText: _isObscured,
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                        ),
                                        decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: 'Password ',
                                            labelStyle: const TextStyle(
                                                color: AppColors.primaryColor),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _isObscured
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed:
                                                  _togglePasswordVisibilty,
                                            ))),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: AppColors.borderColor))),
                                    child: TextFormField(
                                        controller: cnfmPassCtrl,
                                        obscureText: _isObscured,
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                        ),
                                        decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: 'Confirm Password ',
                                            labelStyle: const TextStyle(
                                                color: AppColors.primaryColor),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _isObscured
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed:
                                                  _togglePasswordVisibilty,
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: double.infinity,
                                child: Row(   /// the row contains the two buttons signup as farmer and signup as buyer
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:Border.all(
                                            color: AppColors.secondaryColor,
                                            width: 2
                                          ),
                                            gradient: const LinearGradient(colors: [
                                              Color.fromRGBO(50, 137, 255, 1.0),
                                              Color.fromRGBO(52, 147, 244, 0.6),
                                            ])),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            // foregroundColor:
                                              backgroundColor: Colors.transparent,
                                              elevation: 0 // Text color
                                          ),
                                          onPressed: () {
                                            typeOfUser='BR';
                                            if(registerDataValidation()){
                                              /// below function used to sent data for registration of the user to backend
                                              userRegistration();
                                                  Provider.of<UserUpdateNotifier>(context,listen: false).saveTypeOfUser(typeOfUser);
                                              Provider.of<UserUpdateNotifier>(context,listen: false).saveUserId(responseMsg['id']);
                                              Provider.of<UserUpdateNotifier>(context,listen: false).saveName(responseMsg['name']);

                                            }

                                          },
                                          child: const Text("SignUp as Buyer")
                                        ),
                                      ),
                                    ),
                                    Expanded(


                                      child: Container(
                                        decoration:  BoxDecoration(
                                              border:Border.all(
                                                  color: AppColors.secondaryColor,
                                                  width: 2
                                              ),
                                            gradient: const LinearGradient(colors: [
                                              Color.fromRGBO(50, 137, 255, 1.0),
                                              Color.fromRGBO(52, 147, 244, 0.6),
                                            ])),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            // foregroundColor:
                                              backgroundColor: Colors.transparent,
                                              elevation: 0 // Text color
                                          ),
                                          onPressed: () {
                                            if(registerDataValidation()){
                                              typeOfUser='FR';
                                              /// below function used to sent data for registration of the user to backend
                                              userRegistration();



                                            }

                                          },

                                          child: const Text("SignUp as Farmer"),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            ),
            ///shows the loading and semi-background when login process started
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
        ));
  }
}
