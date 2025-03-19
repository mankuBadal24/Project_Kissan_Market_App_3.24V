import 'package:flutter/material.dart';

import '../Theme/AppColors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class CustomWidgets{
  ///textNormal
  static textNormal(String text){
    return Text(text,style:const TextStyle(color: AppColors.textColorWhite),);
  }
  static textBlue(String text){
    return Text(text,style:const TextStyle(color: AppColors.primaryColor),);
  }
  static appBar(String title){
    return AppBar(title: CustomWidgets.textNormal(title),backgroundColor: AppColors.appBarColor,);
  }

  static textField(String label,TextEditingController controller){
  return  Container(
    padding: const EdgeInsets.all(8.0),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderColor))),
    child: TextFormField(
      controller: controller,
      style: const TextStyle(
        color: AppColors.primaryColor,
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText:label,
        labelStyle: const TextStyle(color:AppColors.primaryColor),
      ),
    ),
  );
  }

  static ElevatedButton buildElevatedButton({
    required String btnText,
    required VoidCallback onPressed,
    Color color = AppColors.buttonColor, // Default color if not passed
    double elevation = 2.0,     // Default elevation if not passed
  })
  {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,          // Set the button color
        elevation: elevation,    // Set the button elevation
      ),
      child: CustomWidgets.textNormal(btnText),         // Set the text of the button
    );
  }

  static divider(){
    return const Divider(height: 1,color: AppColors.borderColor,);
  }

  // static showSnackBarMessage(String message ,BuildContext context) {
  //   return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(
  //       message,
  //       style: const TextStyle(color: AppColors.primaryColor, fontSize: 16),
  //     ),
  //     duration: const Duration(seconds: 1),
  //     backgroundColor: AppColors.backgroundColor,
  //     closeIconColor: AppColors.secondaryColor,
  //   ));
  // }

  static showQuickAlert(String message ,String type,BuildContext context){
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
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the alert after 3 seconds
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
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(text,
                  textAlign: TextAlign.right, style:const TextStyle(fontSize: 12)),
            ),

          ],
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }

  static Widget CustomeCard(String name,String phoneNumber,VoidCallback onTap){
    return Card(
      elevation: 5,
      // color: Color(0xffdce9fb),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primaryColor)
      ),
      child: Padding(padding: EdgeInsets.all(8.0),
      child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.person,color: AppColors.primaryColor,),
                SizedBox(width: 8,),
                Expanded(child:  Text("Name : ${name.toUpperCase()}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))

              ],
            ),
            Divider(),
            Row(
              children: [
                Icon(Icons.phone,color: AppColors.primaryColor,),
                SizedBox(width: 8,),
                Expanded(child:  Text("Phone : +91-$phoneNumber",style: TextStyle(fontSize: 16,)))

              ],
            ),



        ],
      ),),
    );
  }

}