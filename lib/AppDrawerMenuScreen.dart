import 'package:flutter/material.dart';
import 'package:kissan_market_app/LoginScreen.dart';
import 'package:kissan_market_app/SaveUserData/SaveUserData.dart';

import 'Theme/AppColors.dart';

class AppDrawerMenuScreen extends StatefulWidget{
  SaveUserData saveUserData=SaveUserData();
  AppDrawerMenuScreen({super.key,required this.saveUserData});
  @override
  State<AppDrawerMenuScreen> createState()=>App_DrawerMenuScreenState();

 
}
class App_DrawerMenuScreenState extends State<AppDrawerMenuScreen>{
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        color: AppColors.secondaryColor,
        child: ListView(padding: EdgeInsets.zero,
        children:<Widget> [
           DrawerHeader(
              decoration: const BoxDecoration(
              color: AppColors.primaryColor
            ),
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 5),
              child:Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,

                  children:<Widget>[
                    const SizedBox(height: 65,),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 8, 0, 5),
                      child:  Text(widget.saveUserData.getName(),
                        style:TextStyle(fontSize: 16,color:AppColors.textColorWhite)
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      child:  Text(
                        '+91${widget.saveUserData.getPhoneNumber()}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColorWhite,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
          ),
          // SizedBox(height: 10,),
          ExpansionTile(
            leading: const Icon(Icons.phone,color: AppColors.primaryColor,),
            title: const Text('Contact Us'),
            children:<Widget> [
             ListTile(
               title: const Text('Phone Numbers',
                 style: TextStyle(fontSize: 15,color: Colors.black),
               ),
               onTap: (){},
             ),
              ListTile(
                title: const Text('Email',
                  style: TextStyle(fontSize: 15,color: Colors.black),
                ),
                onTap: (){},
              ),
            ],
          ),
          const Divider(height: 1,color: AppColors.borderColor,),

          ListTile(
            leading: const Icon(Icons.person,color: AppColors.primaryColor,),
            title: const Text('Profile'),
            onTap: (){},),

          const Divider(height: 1,color: AppColors.borderColor,),
          ListTile(
            leading: const Icon(Icons.info_outline,color: AppColors.primaryColor,),
            title: const Text('About us'),
          onTap: (){},),

          const Divider(height: 1,color: AppColors.borderColor,),

          ListTile(
            leading: const Icon(Icons.share,color: AppColors.primaryColor,),
            title: const Text('Share'),
            onTap: (){},),

          const Divider(height: 1,color: AppColors.borderColor,),

          ListTile(
            leading: const Icon(Icons.security,color: AppColors.primaryColor,),
            title: const Text('Change Password'),
            onTap: (){},),

          const Divider(height: 1,color: AppColors.borderColor,),
          ListTile(
            leading: const Icon(Icons.logout,color: AppColors.primaryColor,),
            title: const Text('Logout'),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
            },),

        ],),
      ),
    );
  }
}
