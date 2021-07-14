
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
class graph1 extends StatefulWidget{
  final String _id;
  graph1(this._id);
  @override
  graphState1 createState() => graphState1();
}
class graphState1 extends State<graph1> {

  List<dynamic> total= new List();
  List<FlSpot> axis= [FlSpot(0,0)];//new List();

  void getUsersList(String id) async {
    var document =await FirebaseFirestore.instance.collection('hotel').get();
    setState(() {
    for(var m in document.docs){
      if(m.id==id) {

          total = m.data()['net-quantity'];
          print(total);
      }
    }
    int j=0;
    axis.clear();
    if(total.length>30)
      {
        int i=total.length-30;
        while(i<total.length)
        {
          axis.add(FlSpot(j.toDouble(), total[i].toDouble()));
          j = j + 1;
          i=i+1;
        }
      }
      else{
      for(var m in total)
      {
        axis.add(FlSpot(j.toDouble(), m.toDouble()));
        j = j + 1;
      }
    }
      });

    print(axis);

  }

  @override
  void initState()
  {
      super.initState();
      //setState(() {
        getUsersList(widget._id);
      //});
  }
  Widget build(BuildContext context) {

    return Container(
     child:
        Scaffold(

      appBar:AppBar(
          backgroundColor: Colors.white,
          title:Text('TOTAL FOOD WASTED',style: TextStyle(
              fontFamily: 'Sans',
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold),

          ),
          leading: IconButton(
            icon:Icon(Icons.arrow_back,color: Colors.teal),
            onPressed: ()
            {
              Navigator.pop(context, false);
            },
          ),
          centerTitle: true),

      body:
        Container(
         child:
          Container(
            height: 550,
            margin: EdgeInsets.all(10.0),
            padding:EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(28)),
                color: Colors.teal[100],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 25,
                ),

                 Text(
                  "Past "+(axis.length).toString()+" Days",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(sampleData1(),
                      swapAnimationDuration: Duration(milliseconds: 400),
                    ),

                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("DAYS",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,),
              ],
            ),
          ),//,
      //,


        ),
    ),
    );

    //throw UnimplementedError();
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white60,
            fitInsideHorizontally:true,
            fitInsideVertically:true,
            maxContentWidth:100,
           //getTooltipItems :LineBarSpot(bar, barIndex, spotIndex){
            //return LineTooltipItem("");
            //},
        ),
        touchCallback: (LineTouchResponse touchResponse) {

        },
        //handleBuiltInTouches: true,
      ),
      //clipData:FlClipData.all(),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          interval: axis.length<15 ?3:5,
            getTextStyles: (value) =>
          const
          TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          margin: 10,
          getTitles: (value) {
                return (value).toInt().toString();
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          interval: 3,
    getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {
          //  if(value%3==0)
            return value.toInt().toString();
            //else
              //return "";
          },
          margin: 5,

        ),

      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),

        ),
      ),
      minX: 0,
      maxX: axis.length.toDouble(),
     // maxY: axis.length.toDouble(),
      minY: 0,
      lineBarsData: fooddata(),
    );
  }

  List<LineChartBarData> fooddata() {
    final LineChartBarData linechartdata = LineChartBarData(

      spots:axis.toList(),
      //isStepLineChart:true,
      isCurved: true,
        colors: const [
        Colors.black,
        //Colors.indigo,
        //Colors.orange
      ],
      barWidth: 2,
      dotData: FlDotData(
        show:false,
      ),

      belowBarData: BarAreaData(
        show:true,
        colors:[Colors.teal[300]],
      ),
    );

    return [linechartdata];

  }
}