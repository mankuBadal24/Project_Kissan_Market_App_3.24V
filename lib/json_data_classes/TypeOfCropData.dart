
import 'dart:convert';

class TypeOfCrop{
  late Map<String, dynamic> typeOfCrops;
  String jsonStringData='''{
  "type-of-Crop-data": [
    {
      "code": "WHT",
      "description": "Wheat",
      "show_dialog": "Y"
    },
    {
      "code": "RCE",
      "description": "Rice",
      "show_dialog": "Y"
    },
    {
      "code": "MZE",
      "description": "Maize",
      "show_dialog": "Y"
    },
     {
      "code": "SGC",
      "description": "SugarCane",
      "show_dialog": "Y"
    },
     {
      "code": "MST",
      "description": "Mustard",
      "show_dialog": "Y"
    },
     {
      "code": "PLS",
      "description": "Pulses",
      "show_dialog": "Y"
    } 
  ],
  "Pulses": [
    {
      "code": "LNT",
      "description": "Lentils",
      "show_dialog": "Y"
    },
    {
      "code": "CHN",
      "description": "Chickpeas",
      "show_dialog": "N"
    },
    {
      "code": "MTR",
      "description": "Matar (Peas)",
      "show_dialog": "Y"
    }
  ]
  
}''';
  TypeOfCrop(){
    typeOfCrops=jsonDecode(jsonStringData);
  }
   Map<String, dynamic>getTypeOfCrops(){
    return typeOfCrops;
  }
}
