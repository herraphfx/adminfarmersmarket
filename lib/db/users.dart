import 'package:adminecomerce/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserServices{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = "users";

  void createUser(Map data) {
    _firestore.collection(collection).doc(data["userId"]).set(data);
    print("USER WAS CREATED");
  }

  // void loginUser(Map data) {
  //   _firestore.collection(collection).doc(data["userId"]).snapshots();
  // }
  Future<UserModel> getUserById(String id)=> _firestore.collection(collection).doc(id).get().then((doc){
    return UserModel.fromSnapshot(doc);
  });
}