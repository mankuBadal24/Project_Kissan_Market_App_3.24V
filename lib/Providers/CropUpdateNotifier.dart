import 'package:flutter/material.dart';
class CropUpdateNotifier extends ChangeNotifier{
bool isChanged=false;
void toUpdateTrue(){
  isChanged=true;
  notifyListeners();
}
void toUpdateFalse(){
  isChanged=false;
  notifyListeners();
}
}