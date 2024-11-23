import 'package:flutter/material.dart';

import '../Theme/AppColors.dart';

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

}