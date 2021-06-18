import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'products';

  void uploadProduct({
      String productName,
      String description,
      String brand,
      String category,
      List images,
      double price,
      int quantity,})

  {
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection('products').doc(productId).set({
      'name': productName,
      'description': description,
      'Id': productId,
      'category': category,
      'brand': brand,
      'quantity': quantity,
      'price': price,
      'picture': images,
    });
  }



}