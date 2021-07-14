import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'classify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  Classifier _classifier;
  final _store = FirebaseFirestore.instance;
  List<dynamic> quantity=new List();
  List<double> dataQuantity=new List();
  List<String> xAxis=new List();
  List<dynamic> yAxis=new List();
   double average=0.0 ;
  int startIndex;
  bool showGraph = false;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _classifier = Classifier();
    getData();
    getCurrent();
  }
  void getCurrent(){
    List<String> Date = ["Mon","Tue","Wed","Thur","Fri","Sat","Sun"];
    var day =  DateFormat('EEEE').format(DateTime.now());
    for(String val in Date){
      if(day.substring(0,val.length)==val)
        startIndex = Date.indexOf(val);
    }
    int i =startIndex;
    int n=0;
    while(n<7){
      if(i==Date.length)
        i=0;
      xAxis.add(Date[i++]);
    n++;
    }

    print(xAxis);
  }
  void getData()async{
    var document = await _store.collection('quantity').get();
    for( var m in document.docs){
      if(m.id=='data') {
        for(int i in m.data()['waste']){
          quantity.add(i.toDouble());
        }
        break;
      }
    }
    print(quantity);
    setState(() {
      quantity.removeRange(0, quantity.length-3);
      for(var val in quantity){
        dataQuantity.add(val.toDouble());
      }

    });



    }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[100],
          title: const Text('Analysis',
          style: TextStyle(
            fontFamily: 'Sans',
            fontSize: 20,
            fontWeight: FontWeight.w600

          ),),
        ),
        body: Container(
          padding: const EdgeInsets.all(4),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Food Wasted Last 3 Days",
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 125,
                          child: Card(
                              child: Center(child: Text(quantity[index].toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.teal,
                                  fontFamily: 'Poppins'
                                ),),
                              )
                          ),
                        );
                      },
                    scrollDirection: Axis.horizontal,
                       itemCount: quantity.length,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        primary: Colors.teal.shade200, // background
                        onPrimary: Colors.white,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ) // foreground
                    ),
                    child: Text(
                      'Predict',
                      style: TextStyle(
                          fontFamily: 'Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onPressed: () {
                      final text = dataQuantity;
                      final prediction = _classifier.classify(text);
                      setState(() {
                        dataQuantity=prediction;
                        for(double val in dataQuantity)
                           average += val;
                        average/=dataQuantity.length;
                        showGraph = true;
                       });
                      print(yAxis);

                    }
                ),
              ),
              showGraph==true?Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      child: LineChart(
                          mainData()
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("Estimated Average : ",style: TextStyle(
                          fontFamily: 'Sans',
                          fontSize: 30
                        ),),
                        Text(average.round().toString() ,style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 30,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold
                        ),),
                      ],
                    )
                  ],
                ),
              ):Container()


            ],
          ),
        ),
      );
  }
  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            return xAxis[value.toInt()].toString();
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 0.toString();
              case 100:
                return 100.toString();
              case 150:
                return 150.toString();
              case 200:
                return 200.toString();
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 200,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, dataQuantity[0].roundToDouble()),
            FlSpot(1, dataQuantity[1].roundToDouble()),
            FlSpot(2, dataQuantity[2].roundToDouble()),
            FlSpot(3, dataQuantity[3].roundToDouble()),
            FlSpot(4, dataQuantity[4].roundToDouble()),
            FlSpot(5, dataQuantity[5].roundToDouble()),
            FlSpot(6, dataQuantity[6].roundToDouble()),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}

