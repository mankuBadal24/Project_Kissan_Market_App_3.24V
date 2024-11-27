

import 'package:flutter/material.dart';
import 'package:kissan_market_app/Providers/CropUpdateNotifier.dart';
import 'package:kissan_market_app/Providers/UserUpdateNotifier.dart';
import 'LoginScreen.dart';
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














