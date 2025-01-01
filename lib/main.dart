
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kissan_market_app/Providers/CropUpdateNotifier.dart';
import 'package:kissan_market_app/Providers/UserUpdateNotifier.dart';
import 'package:kissan_market_app/Screens/DriverListScreen.dart';
import 'Screens/BuyerHomeScreen.dart';
import 'Screens/FarmerHomeScreen.dart';
import 'Screens/LoginScreen.dart';
import 'package:provider/provider.dart';
import 'SessionManagement//SessionManagement.dart';
void main()async {
  bool loginFlag=true;
  bool isFarmer=false;
  WidgetsFlutterBinding.ensureInitialized();
  final sessionProvider=SessionManagement();
  String token=await sessionProvider.loadSession();
  String? type=await sessionProvider.getTypeOfUser();
  if(token!='null'){
    loginFlag=false;
  }
  if(type=='FR'){
    isFarmer=true;
  }
  if (kDebugMode) {
    print(token);
  }
runApp(
    MultiProvider(
     providers: [
       ChangeNotifierProvider(create: ( BuildContext context)=>CropUpdateNotifier()),
      // ChangeNotifierProvider(create: ( BuildContext context)=>UserUpdateNotifier())
      //  ChangeNotifierProvider(create: ( BuildContext context)=>sessionProvider),
       
       Provider<UserUpdateNotifier>(create: (_)=>UserUpdateNotifier())
     ],

     child:MaterialApp(
        debugShowCheckedModeBanner:false,
         home:loginFlag? const LoginScreen():isFarmer?FarmerHomeScreen():BuyerHomeScreen(),
     )
        )
    );
}














