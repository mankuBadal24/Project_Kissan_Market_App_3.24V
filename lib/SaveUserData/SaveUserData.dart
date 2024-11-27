


class SaveUserData {
  late String _userId;
  late String _typeOfUser;
  late String _name;
  late String _phoneNumber;

  saveUserId(String userId){
    _userId=userId;
  }
  saveTypeOfUser(String typeOfUser){
    _typeOfUser=typeOfUser;
  }
  saveName(String name){
    _name=name;
  }
  savePhoneNumber(String number){
    _phoneNumber=number;
  }

  String getName(){
    return _name;
  }
  String getUserId(){
    return _userId;
  }
  String getTypeOfUser(){
    return _typeOfUser;
  }
  String getPhoneNumber(){
    return _phoneNumber;
  }

}