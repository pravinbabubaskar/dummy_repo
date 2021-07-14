import 'package:flutter/material.dart';

class View_details extends StatefulWidget {
  final ord;
  int rup;
  String uid;
  String uname;

  View_details(this.ord, this.rup, this.uid, this.uname);

  @override
  _View_detailsState createState() => _View_detailsState();
}

class _View_detailsState extends State<View_details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
          ),
          Text(
            "Order Details",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.0),
          Text(
            widget.uname,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.0),
          Text(
            widget.uid,
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 23.0),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 300.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.ord.length,
                        itemBuilder: (context, index) {
                          return _buildFoodItem(
                            widget.ord[index]['p_url'],
                            widget.ord[index]['name'],
                            widget.ord[index]['quantity'].toString(),
                            widget.ord[index]['price'],
                          );
                        },
                      ),
                    )),
                Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Cost",
                      style: TextStyle(
                        fontFamily: 'Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "₹ " + widget.rup.toString(),
                      style: TextStyle(
                          fontFamily: 'Sans',
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          color: Colors.red),
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFoodItem(
      String imgPath, String foodName, String qua, String price) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {
              //  Navigator.of(context).push(MaterialPageRoute(
              //    builder: (context) => DetailsPage(
              //       heroTag: imgPath, foodName: foodName, foodPrice: price)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
                  Hero(
                      tag: imgPath,
                      child: Image(
                          image: NetworkImage(imgPath),
                          fit: BoxFit.cover,
                          height: 75.0,
                          width: 75.0)),
                  SizedBox(width: 10.0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(foodName,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Text(qua + " Quantity",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                color: Colors.grey))
                      ])
                ])),
                Text("₹ " + price,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                        color: Colors.grey))
              ],
            )));
  }
}
