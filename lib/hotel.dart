import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:like_button/like_button.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;
import 'cart.dart';
import 'data.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelPage extends StatefulWidget {
  var hotelData;
  HotelPage({Key key, @required this.hotelData}) : super(key: key);
  @override
  _HotelPageState createState() => _HotelPageState(this.hotelData);
}

class _HotelPageState extends State<HotelPage> {
  var data;
  double distance;
  List<dynamic> products = new List();
  _HotelPageState(this.data) {
    products = data['product'];
    distance=calculateDistance(latlong.latitude, latlong.longitude, data['latitue'], data['longitude']);

  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.dstATop),
                      image: data['imageUrl'] == null
                          ? AssetImage('images/food.png')
                          : NetworkImage(data['imageUrl']),
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '${data['name'][0].toUpperCase()}${data['name'].substring(1)}',
                                style: TextStyle(
                                    fontFamily: 'Sans',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SmoothStarRating(
                                  size: 25,
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: double.parse(data['r']),
                                  isReadOnly: true,
                                  color: Colors.green,
                                  borderColor: Colors.green,
                                  spacing: -0.5),
                            ],
                          ),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Center(
                              child: LikeButton(
                                isLiked: true,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['type'],
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black54,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                child: Icon(Icons.call,
                                    size: 30.0, color: Colors.green),
                                onTap: () {
                                  int num = int.parse(data["number"]);
                                  launch("tel:$num");
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                child:
                                    Icon(Icons.map, size: 30.0, color: Colors.green),
                                onTap: () {
                                  double lat = latlong.latitude;
                                  double long = latlong.longitude;
                                  double Hlat = data["latitue"];
                                  double Ulong = data["longitude"];
                                  String url =
                                      "https://www.google.com/maps/dir/?api=1&origin=" +
                                          '$Hlat' +
                                          "," +
                                          '$Ulong' +
                                          "&destination=" +
                                          '$lat' +
                                          "," +
                                          '$long' +
                                          "&travelmode=driving";
                                  launch(url);
                                },
                              ),
                            ],
                          ),
                          Text(
                            distance.toStringAsFixed(2)+" KM",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black54,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Dishes",
                      style: TextStyle(
                          fontFamily: 'Sans',
                          fontSize: 22,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: 0.5,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: AnimationLimiter(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    //  return dishWidget(products[index]);
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: dishWidget(products[index]),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Padding dishWidget(Map<dynamic, dynamic> mp) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${mp['name'][0].toUpperCase()}${mp['name'].substring(1)}',
                    style: TextStyle(
                        fontFamily: 'Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    mp["description"],
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w100,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "₹ " + mp["price"],
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Sans',
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Availability :" + mp["quantity"].toString(),
                    style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 12,
                        fontFamily: 'Sans',
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Stack(
                  children: [
                    Container(height: 140),
                    Container(
                      height: 120,
                      width: 140,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: mp["p_url"] == null
                              ? Image.asset(
                                  "images/food.png",
                                  fit: BoxFit.contain,
                                  height: 80,
                                  width: 100,
                                )
                              : Image.network(
                                  mp["p_url"],
                                  fit: BoxFit.contain,
                                  height: 80,
                                  width: 100,
                                )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // background
                    ),
                    onPressed: () {
                      setState(() {
                        toto++;
                        cost += int.parse(mp["price"]);
                        openCartPage(mp);
                        hotelId = data['id'];
                      });
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                          fontFamily: 'Sans', fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  void openCartPage(Map<dynamic, dynamic> mp) {
    cartData.add(mp);
    final snackBar1 = SnackBar(
      duration: Duration(seconds: 5),
      backgroundColor: Colors.green,
      content: Text(
        '$toto Items | ₹ $cost 😋',
        style: TextStyle(
          fontFamily: 'Sans',
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      action: SnackBarAction(
        label: 'Cart',
        textColor: Colors.orange[500],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cart(data['name'])),
          );
        },
      ),
    );

    final snackBar2 = SnackBar(
      duration: Duration(seconds: 5),
      backgroundColor: Colors.green,
      content: Text(
        'Trying to add from different hotel',
        style: TextStyle(
          fontFamily: 'Sans',
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      action: SnackBarAction(
        label: 'Clear Cart',
        textColor: Colors.orange[500],
        onPressed: () {
          cost = toto = 0;
          cartData.clear();
          barName = null;
        },
      ),
    );
    if (barName == null || barName == data['name']) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
      barName = data['name'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }
  }
}
