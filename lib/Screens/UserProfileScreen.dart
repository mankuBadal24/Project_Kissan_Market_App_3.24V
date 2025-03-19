import 'package:flutter/material.dart';
import 'package:kissan_market_app/CustomWidgets/CustomWidgets.dart';
import '../SharedPreferences/UserSharedPreferences.dart';

class UserProfileScreen extends StatefulWidget{
  const UserProfileScreen({super.key});
  @override
  State<StatefulWidget>createState()=>_UserProfileScreenState();
}
class _UserProfileScreenState extends State<UserProfileScreen>{
  UserSharedPreferences pref=UserSharedPreferences();
  Map<String, String?> userData={};

  getUserData()async{
    userData= await pref.loadUserData();
    setState(() {

    });
  }
  static Widget customTextRow(String field,String text){
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(text,
                  textAlign: TextAlign.right, style:const TextStyle(fontSize: 16)),
            ),

          ],
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomWidgets.appBar("User Profile"),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/agriculture-working-men-talking-phone.jpg'),
            ),
        Text((userData['name']??'Not available').toUpperCase(),style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),// Change the image as needed
             const SizedBox(height: 20,),
            customTextRow('Id', userData['userId']??'Not Available'),
            customTextRow('State', userData['phoneNumber']??'Not Available'),
            customTextRow('City', userData['phoneNumber']??'Not Available'),
            customTextRow('Area', userData['phoneNumber']??'Not Available'),
            customTextRow('Pin Code', userData['phoneNumber']??'Not Available'),
            if(userData['typeOfUser']!='BR')
            customTextRow('Type Of Farmer', userData['phoneNumber']??'Not Available'),
            FloatingActionButton(onPressed: (){},
            child: const Text('Update'),)
          ],
        ),
      ),
    ),
  );
  }
}