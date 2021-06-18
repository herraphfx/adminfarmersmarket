import 'dart:io';
import 'dart:ui';
import 'package:adminecomerce/db/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../db/category.dart';
import '../db/brand.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VendorList extends StatefulWidget {
  @override
  _VendorListState createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  final priceController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory ;

  String _currentBrand;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  File _imageFile;
  String imagePath;
  File _imageFile2;
  File _imageFile3;
  bool isLoading = false;


  @override
  void initState() {
    _getCategories();
    _getBrands();
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(0, DropdownMenuItem(child: Text(categories[i].data()['category']),
          value: categories[i].data()['category'],));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandsDropdown() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        items.insert(0, DropdownMenuItem(child: Text(brands[i].data()['brand']),
          value: brands[i].data()['brand'],));
      });
    }
    return items;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        // leading: Icon(Icons.close, color: black,),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ],
        backgroundColor: Colors.green,
        title: Text("Vendor", style: TextStyle(color: black),),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: isLoading ? CircularProgressIndicator() : Column(
              children: <Widget>[


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("List of Product Vendor",
                    style: TextStyle(color: Colors.red),),
                ),

// select category








                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 400,
                        width: 400,
                        child:  ListView.builder(
                            itemCount: brands.length,
                            itemBuilder:(context, index){
                              return ListTile(
                                title: Text(brands[index]['brand']),
                              );
                            }),
                      ),
                    ],
                  ),
                )

              ],

            ),
          ),

        ),

      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data()['category'];
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    print(data.length);
    setState(() {
      brands = data;
      brandsDropDown = getBrandsDropdown();
      _currentBrand = brands[0].data()['brand'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() => _currentBrand = selectedBrand);
  }

  void PickImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    var image2 = await ImagePicker().getImage(source: ImageSource.gallery);
    var image3 = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(image.path);
    });

    setState(() {
      _imageFile2 = File(image2.path);
    });

    setState(() {
      _imageFile3 = File(image3.path);
    });
  }


  Widget displayChild1() {
    if(_imageFile == null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0,14.0,50.0),
        child: Icon(Icons.add, color: grey,),
      );
    }else {
      return Image.file(File(_imageFile.path), fit: BoxFit.fill, width: double.infinity,);
    }
  }

  Widget displayChild2() {
    if(_imageFile2 == null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0,14.0,50.0),
        child: Icon(Icons.add, color: grey,),
      );
    }else {
      return  Image.file(_imageFile2, fit: BoxFit.fill,width: double.infinity,);
    }
  }

  Widget displayChild3() {
    if(_imageFile3 == null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0,14.0,50.0),
        child: Icon(Icons.add, color: grey,),
      );
    }else {
      return Image.file(_imageFile3, fit: BoxFit.fill, width: double.infinity,);
    }
  }

  void validateAndUpload() async{
    if(_formKey.currentState.validate()){
      setState(() =>
      isLoading = true
      );
      if(_imageFile != null && _imageFile2 != null && _imageFile3 != null){
        String imageUrl1;
        String imageUrl2;
        String imageUrl3;
        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture1 = "1${DateTime.now().microsecondsSinceEpoch.toString()}.jpg";
        UploadTask task1 = storage.ref().child(picture1).putFile(_imageFile);
        final String picture2 = "2${DateTime.now().microsecondsSinceEpoch.toString()}.jpg";
        UploadTask task2 = storage.ref().child(picture2).putFile(_imageFile2);
        final String picture3 = "3${DateTime.now().microsecondsSinceEpoch.toString()}.jpg";
        UploadTask task3 = storage.ref().child(picture3).putFile(_imageFile3);

        TaskSnapshot snapshot1 = await task1.then((snapshot) => snapshot);
        TaskSnapshot snapshot2 = await task2.then((snapshot) => snapshot);
        task3.then((snapshot3) async{
          imageUrl1 = await snapshot1.ref.getDownloadURL();
          imageUrl2 = await snapshot2.ref.getDownloadURL();
          imageUrl3 = await snapshot3.ref.getDownloadURL();
          List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];

          productService.uploadProduct(
            productName: productNameController.text,
            description: descriptionController.text,
            images: imageList,
            price: double.parse(priceController.text),
            quantity: int.parse(quantityController.text),
            category: _currentCategory,
            brand: _currentBrand,
          );

          //form
          _formKey.currentState.reset();
          setState(() =>
          isLoading = false
          );
          setState(() =>
          isLoading = false
          );
          Fluttertoast.showToast(msg: 'Product Added');
          Navigator.pop(context);
        });
      }else{
        setState(() =>
        isLoading = false
        );
        Fluttertoast.showToast(msg: 'All images must be provided');
      }
    } else{
      Fluttertoast.showToast(msg: 'All the images must be provided');
    }
  }

}