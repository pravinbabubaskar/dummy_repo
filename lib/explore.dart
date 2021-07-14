import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/hotel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  String name = "";
  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          cursorColor: Colors.teal,
          controller: _controller,
          onChanged: (val) {
            setState(() {
              name = "";
              name = val;
              if (name.isNotEmpty)
                print(name[0].toUpperCase() + name.substring(1).toLowerCase());
            });
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: _controller.clear,
                icon: Icon(Icons.clear),
                color: Colors.teal[100],
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal, width: 0.0),
              ),
              contentPadding: EdgeInsets.only(left: 25.0),
              hintText: 'Search by name',
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(4.0))),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
                .collection('hotel')
                .where('name',
                    isGreaterThanOrEqualTo:
                        name[0].toUpperCase() + name.substring(1).toLowerCase())
                .where('name',
                    isLessThan: name[0].toUpperCase() +
                        name.substring(1).toLowerCase() +
                        'z')
                .snapshots()
            : FirebaseFirestore.instance.collection("hotel").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: new Text('Error: ${snapshot.error}'));
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.docs.length < 1) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/table.png',
                  height: 150,
                ),
                Text(
                  'No Restaurents available..',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    letterSpacing: -1,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Try another one",
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
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data.docs[index];

                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 2000),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HotelPage(
                                          hotelData: snapshot.data.docs[index],
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      data['imageUrl'],
                                      width: 125,
                                      height: 100,
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
                                        data['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        data['type'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                      ));
                },
              ),
            );
        },
      ),
    );
  }
}
