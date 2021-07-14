import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:dio/dio.dart';
import 'data.dart';
import 'hotel.dart';
import 'package:web_scraper/web_scraper.dart';

class NearMe extends StatefulWidget {
  @override
  _NearMeState createState() => _NearMeState();
}

class _NearMeState extends State<NearMe> {
  List<dynamic> hotel = new List();
  int i = 0;
  List<String> duration = [
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown',
    'Unknown',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    for (var t in hotelData) {
      if (t['district'] == loc1) {
        hotel.add(t);
        getDistance(t['latitue'],t['longitude']);
      }
    }
  }

  getDistance(double lat, double long) async {

    var dio = Dio();
    double Ulat = latlong.latitude;
    double Ulong = latlong.longitude;
    final response = await dio.get(
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$Ulat,$Ulong&destinations=$lat,$long&key=dsgdfgdfrgd232435');
    Map data = response.data;
    setState(() {
      duration[i] = data['rows'][0]["elements"][0]["duration"]["text"];
      print(duration[i]);
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(isNGOVerified);
    return Scaffold(
        appBar: AppBar(
          //title: Text("NEAR ME"),
          backgroundColor: Colors.teal[300],
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_city_rounded,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    loc1,
                    style: TextStyle(fontFamily: 'Sans', color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              isNGOVerified == true ?Text(
                "NGO+",
                style: TextStyle(
                    fontFamily: 'Sans',
                    color:Colors.teal[100],
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ):Text(""),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "ALL RESTAURANTS",
                    style: TextStyle(
                        fontFamily: 'Sans',
                        fontSize: 17.5,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: hotel.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HotelPage(
                                        hotelData: hotel[index],
                                      )),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: placesWidget(
                                  hotel[index]['name'],
                                  hotel[index]['type'],
                                  hotel[index]['imageUrl'],
                                  hotel[index]['r'],
                                  duration[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
          ),
        ));
  }

  Row placesWidget(String name, String abt, String url,String r, String time) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          height: 120,
          width: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: url == null
                ? Image.asset("images/food.png", fit: BoxFit.contain)
                : Image.network(url, fit: BoxFit.fill),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                    fontFamily: 'Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                abt,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w100,
                    color: Colors.grey),
              ),
              SizedBox(
                height: 5,
              ),
              SmoothStarRating(
                  size: 20,
                  allowHalfRating: true,
                  starCount: 5,
                  rating: double.parse(r),
                  isReadOnly: true,
                  color: Colors.teal,
                  borderColor: Colors.teal[100],
                  spacing: -0.5),
              SizedBox(
                height: 5,
              ),
              Divider(color: Colors.grey),
              Row(
                children: [
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Sans',
                        fontWeight: FontWeight.w100,
                        color: Colors.grey),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
