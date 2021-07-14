import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/Hotel/Hotel_dashboard/view_details.dart';
import 'package:feedthenead/Hotel/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Completed extends StatefulWidget {
  const Completed({Key key}) : super(key: key);

  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('hotel');
    DocumentReference docref = users.doc(d_id);
    return StreamBuilder<DocumentSnapshot>(
        stream: users.doc(d_id).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          var order = snapshot.data['completed_orders'];

          if (snapshot.hasError)
            return Center(child: new Text('Error: ${snapshot.error}'));
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data['completed_orders'].length < 1) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/order.jpg',
                  height: 150,
                ),
                Text(
                  'No Orders Till now..',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    letterSpacing: -1,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Wait for new  one",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Sans",
                    letterSpacing: -1,
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ],
            ));
          } else
            return AnimationLimiter(
              child: ListView.builder(
                  itemCount: order != null ? order.length : 0,
                  itemBuilder: (_, int index) {
                    return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 2000),
                        child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Image.asset(
                                          'images/tick.jpg',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            order[index]['user name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "₹ " +
                                                    order[index]['Cost']
                                                        .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  var temp =
                                                      order[index]['items'];
                                                  var r = order[index]['Cost'];
                                                  var n =
                                                      order[index]['user name'];
                                                  var i =
                                                      order[index]['user id'];

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              View_details(temp,
                                                                  r, i, n)));
                                                },
                                                child: Text(
                                                  "view Details",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )));
                  }),
            );
        });
  }
}
