import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/helpers/style.dart';
import 'package:feedthenead/widgets/custom_text.dart';
import 'package:feedthenead/widgets/small_floating_button.dart';
import 'package:flutter/material.dart';

import 'Hotel_dashboard/dashboard.dart';
import 'Hotel_dashboard/order.dart';
import 'Hotel_dashboard/product.dart';
import 'add_product.dart';

String d_id = null;

class Home extends StatefulWidget {
  final String _id;

  Home(this._id);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _type = "type";

  String _name = "name";
  String _imgurl;
  String revenue = "0";
  String _count = "0";
  String _len = "0";
  String _olen = "0";

  //List<dynamic> pr;
  @override
  void initState() {
    super.initState();
    this.getData();
    setState(() {
      d_id = widget._id;
    });
  }

  getData() {
    FirebaseFirestore.instance
        .collection('hotel')
        .doc(widget._id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        _name = documentSnapshot.data()['name'];
        _imgurl = documentSnapshot.data()['imageUrl'];
        _type = documentSnapshot.data()['type'];
        revenue = documentSnapshot.data()['revenue'].toString();

        int len = documentSnapshot.data()['product'].length;
        int olen = documentSnapshot.data()['order'].length;

        print(len);
        _count = len.toString();
        _olen = olen.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        elevation: 0.5,
        backgroundColor: primary,
        title: CustomText(
          text: _name,
          color: white,
          fontfamily: "sans",
          size: 25,
        ),
        actions: <Widget>[],
      ),
      drawer: Drawer(child: Dashboard(widget._id)),
      backgroundColor: white,
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
//                  Positioned.fill(
//                      child: Align(
//                        alignment: Alignment.center,
//                        child: Loading(),
//                      )),

              // restaurant image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                ),
                child: _imgurl == null
                    ? Image.asset(
                        "images/food.png",
                        height: 200.0,
                        width: 400.0,
                      )
                    : Image.network(_imgurl, fit: BoxFit.fill),
              ),

              // fading black
              /*   Container(
                height: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.025),
                      ],
                    )),
              ),

                 //restaurant name
              Positioned.fill(
                  bottom: 30,
                  left: 10,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomText(
                        text: _name,
                        color: white,
                        size: 24,
                        weight: FontWeight.normal,
                      ))),

              // average price
              Positioned.fill(
                  bottom: 10,
                  left: 10,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomText(
                        text: _type,
                        color: white,
                        size: 16,
                        weight: FontWeight.w300,
                      ))),
*/
              Positioned.fill(
                  bottom: 2,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow[900],
                                size: 20,
                              ),
                            ),
                            Text("rating"),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(-2, -1),
                          blurRadius: 5),
                    ]),
                child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Order()));
                    },
                    leading: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset("images/delivery.png"),
                    ),
                    title: CustomText(
                      text: "Orders",
                      size: 24,
                    ),
                    trailing: CustomText(
                      text: _olen,
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(-2, -1),
                          blurRadius: 5),
                    ]),
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Product(widget._id)));
                    },
                    leading: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset("images/fd.png"),
                    ),
                    title: CustomText(
                      text: "Products",
                      size: 24,
                    ),
                    trailing: CustomText(
                      text: _count,
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(-2, -1),
                          blurRadius: 5),
                    ]),
                child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        child: Text(
                          "  ₹ ",
                          style: TextStyle(
                              fontSize: 40,
                              //fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                      ),
                    ),
                    title: CustomText(
                      text: "Revenue",
                      size: 24,
                    ),
                    trailing: CustomText(
                      text: revenue,
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ),
            ),
          ),

          // products
          Column()
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => addProduct(widget._id)));
        },
        child: Icon(Icons.add),
        backgroundColor: primary,
        tooltip: 'Add Product',
      ),
    );
  }

  Widget imageWidget({bool hasImage, String url}) {
    if (hasImage)
      return FadeInImage.memoryNetwork(
        placeholder: null,
        image: url,
        height: 160,
        fit: BoxFit.fill,
        width: double.infinity,
      );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                size: 40,
              ),
            ],
          ),
          CustomText(text: "No Photo")
        ],
      ),
      height: 160,
    );
  }
}
