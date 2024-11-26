

import 'package:flutter/material.dart';
import 'package:kissan_market_app/AddCropScreen.dart';
import 'package:kissan_market_app/BuyerHomeScreen.dart';
import 'package:kissan_market_app/Providers/CropUpdateNotifier.dart';
import 'package:kissan_market_app/Providers/UserUpdateNotifier.dart';
import 'package:kissan_market_app/ViewCropsScreen.dart';

import 'FarmerHomeScreen.dart';
import 'LoginScreen.dart';
import 'FarmerRegistrationScreen.dart';
import 'package:provider/provider.dart';
void main(){
runApp(
    MultiProvider(
     providers: [
       ChangeNotifierProvider(create: ( BuildContext context)=>CropUpdateNotifier()),
      // ChangeNotifierProvider(create: ( BuildContext context)=>UserUpdateNotifier())
       Provider<UserUpdateNotifier>(create: (_)=>UserUpdateNotifier())
     ],

     child:const MaterialApp(
        debugShowCheckedModeBanner:false,
        home:LoginScreen()),
   )
);
}














