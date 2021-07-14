import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/Hotel/Hotel_dashboard/add_img.dart';
import 'package:feedthenead/Hotel/Hotel_dashboard/order.dart';
import 'package:feedthenead/Hotel/Hotel_dashboard/product.dart';
import 'package:feedthenead/Hotel/Hotel_dashboard/restaurent.dart';
import 'package:feedthenead/Hotel/Hotel_dashboard/update_profile.dart';
import 'package:feedthenead/Hotel/home.dart';
import 'package:feedthenead/Hotel/login.dart';
import 'package:feedthenead/helpers/style.dart';
import 'package:feedthenead/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'graph.dart';

class Dashboard extends StatefulWidget {
  final String _id;
  Dashboard(this._id);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _type = "type";

  String _name = "name";

  String _imgurl;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('hotel')
        .doc(widget._id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        _name = documentSnapshot.data()['name'];
        _imgurl = documentSnapshot.data()['imageUrl'];
        _type = documentSnapshot.data()['type'];
      });
    });
    return Column(children: [
      Container(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Add_Img(widget._id)));
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imgurl == null
                      ? AssetImage(
                          "images/food.png",
                        )
                      : NetworkImage(
                          _imgurl,
                        ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                _name,
                style: TextStyle(
                  fontSize: 22.0,
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                _type,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      //Now let's Add the button for the Menu
      //and let's copy that and modify it
      ListTile(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Home(widget._id)));
          },
          leading: Icon(
            Icons.home,
            color: Colors.black,
          ),
          title: CustomText(
            text: "Home page",
            color: black,
            size: 16,
            weight: FontWeight.w300,
          )),

      ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Restaurent(widget._id)));
          },
          leading: Icon(
            Icons.restaurant,
            color: Colors.black,
          ),
          title: CustomText(
            text: "My Restaurent",
            color: black,
            size: 16,
            weight: FontWeight.w300,
          )),

      ListTile(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Order()));
          },
          leading: Icon(
            Icons.bookmark_border,
            color: Colors.black,
          ),
          title: CustomText(
            text: "Orders",
            color: black,
            size: 16,
            weight: FontWeight.w300,
          )),

      ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Product(widget._id)));
          },
          leading: Icon(
            Icons.fastfood,
            color: Colors.black,
          ),
          title: CustomText(
            text: "Products",
            color: black,
            size: 16,
            weight: FontWeight.w300,
          )),
      ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Update_profile(widget._id)));
          },
          leading: Icon(
            Icons.update_outlined,
            color: Colors.black,
          ),
          title: CustomText(
            text: "Update Profile",
            color: black,
            size: 16,
            weight: FontWeight.w300,
          )),
      ListTile(
          onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => graph(widget._id)));
          },
          leading: Icon(
            Icons.bar_chart,
            color: Colors.black,
          ),
          title: CustomText(
            text: "Graph",
            color: black,
            size: 16,
            weight: FontWeight.w300,
          )),
      ListTile(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
            Navigator.pop(context);
          },
          leading: Icon(
            Icons.logout,
            color: Colors.black,
          ),
          title: CustomText(
            text: "Log Out",
            color: black,
            size: 16,
            weight: FontWeight.w300,
          )),
    ]);
  }
}
