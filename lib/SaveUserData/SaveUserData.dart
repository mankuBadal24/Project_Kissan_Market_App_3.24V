


class SaveUserData {
  late String _userId;
  late String _typeOfUser;
  late String _name;

  saveUserId(String userId){
    _userId=userId;
  }
  saveTypeOfUser(String typeOfUser){
    _typeOfUser=typeOfUser;
  }
  saveName(String name){
    _name=name;
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

}