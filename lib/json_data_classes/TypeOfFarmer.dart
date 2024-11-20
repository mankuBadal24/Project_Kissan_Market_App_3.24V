import 'dart:convert';

class TypeOfFarmer{
  late Map<String, dynamic> typeOfFarmer;
  String jsonStringData='''{
  "type-of-farmer-data": [
    {
      "code": "S",
      "description": "SMALL",
      "show_dialog": "Y"
    },
    {
      "code": "M",
      "description": "MEDIUM",
      "show_dialog": "Y"
    },
    {
      "code": "L",
      "description": "LARGE",
      "show_dialog": "Y"
    }
  ]
}''';
  TypeOfFarmer(){
    typeOfFarmer=jsonDecode(jsonStringData);
  }
  Map<String, dynamic>getFarmerType(){
    return typeOfFarmer;
}
}
