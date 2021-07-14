import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'graph1.dart';
//import 'package:charts_flutter/flutter.dart' as charts;

class graph extends StatefulWidget {
  final String _id;
  graph(this._id);
  @override
  graphState createState() => graphState();
}

class graphState extends State<graph> {
  int iftouch;
  List<String> productName = new List();
  List<dynamic> quantity = new List();
  CollectionReference collection =
      FirebaseFirestore.instance.collection('hotel');

  void getUsersList(String id) async {
    var document = await FirebaseFirestore.instance.collection('hotel').get();
    for (var m in document.docs) {
      if (m.id == id) {
        print(m.data()['product']);
        for (var values in m.data()['product']) {
          setState(() {
            productName.add(values['name']);
            quantity.add(values['quantity'].toDouble());
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUsersList(widget._id);
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: _buildBarTouchData(),
      titlesData: axesDesign(),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: createbars(),
    );
  }

  List<BarChartGroupData> createbars() {
    return List.generate(
      quantity.length,
      (index) => createBar(index, quantity[index], isTouched: index == iftouch),
    );
  }

  BarChartGroupData createBar(
    int xvalue,
    double yvalue, {
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: xvalue,
      barsSpace: 2,
      barRods: [
        BarChartRodData(
          y: isTouched ? yvalue + 10 : yvalue,
          colors: isTouched
              ? [
                  Colors.yellow[200],
                  Colors.yellow[400],
                  Colors.orange[400],
                  Colors.orange[800]
                ]
              : [Colors.yellow[300]], // : Colors.white,
          width: 30,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            //y: 40,

            colors: [Colors.grey[600]],
          ),
        ),
      ],
    );
  }

  FlTitlesData axesDesign() {
    return FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        margin: 20,
        getTextStyles: (value) => const TextStyle(
          color: Colors.black54,//(0xff67727d),
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        getTitles: (double value) {
          return productName[value.toInt()].toString();
        },
      ),
      leftTitles: SideTitles(
        showTitles: false,
        /*getTitles: (double value) {
          return value.toString();
        },*/
      ),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.yellow[300],
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipItem: (grp, grpInd, rod, rodIndex) {
          return BarTooltipItem(
            "Item : " +
                productName[grp.x.toInt()] +
                '\n' +
                "Quantity : " +
                quantity[grp.x.toInt()]
                    .toString(), //(t).toString(),//(rod.y).toString(),
            TextStyle(
                color: Colors.black,
                fontFamily: 'Sans',
                fontSize: 10,
                fontWeight: FontWeight.bold),
          );
        },
      ),
      touchCallback: (barTouchResponse) {
        setState(() {
          if (barTouchResponse.spot != null &&
              barTouchResponse.touchInput is! FlPanEnd &&
              barTouchResponse.touchInput is! FlLongPressEnd) {
            iftouch = barTouchResponse.spot.touchedBarGroupIndex;
          } else {
            iftouch = -1;
          }
        });
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Stack(
        children: [
          Container(
            //decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(30.0),
            //color:Colors.blueGrey,
            //),

            // margin: EdgeInsets.all(5.0),
            //padding: const EdgeInsets.all(5),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 25, right: 25),
                    primary: Colors.teal.shade200, // background
                    onPrimary: Colors.white,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ) // foreground
                    ),
                child: Text(
                  'Total FOOD DETAILS',
                  style: TextStyle(
                      fontFamily: 'Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => graph1(widget._id),
                      ));
                }
            ),
            height: 180.0,
            alignment:Alignment.center,
            width:double.infinity,
          ),
        ],
      ),
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'FOOD Details',
            style: TextStyle(
                fontFamily: 'Sans',
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.teal),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          centerTitle: true),
      body: Container(
        child: Container(
          height: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.teal[100],
          ),
          margin: EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Unused Food',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Remaining',
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: BarChart(
                      mainBarData(),
                      swapAnimationDuration: Duration(milliseconds: 400),
                      //AnimatedAlign:anim// Optional
                      //AnimatedContainer:
                      //:Curves.linear,
                      //swapAnimationCurve: Curves.linear,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    //throw UnimplementedError();
  }
}
