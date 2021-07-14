import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class Past extends StatelessWidget {
  List orders;
Past(this.orders);
List<String> item=new List();
void cal()
{
  int i=0;
  String t="";
  for(var a in orders)
    {

      for(var b in a['items'])
        {
          t=t+b['name'].toString()+"("+b['quantity'].toString()+") ";
        }
      item.add(t.toString());
      t="";
    }
}

Widget Listdata()
{
   cal();
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: orders.length,
          itemBuilder:(context,index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(orders[index]['Hotel'],style: TextStyle(
                          fontFamily:'Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                      )),
                      Text("₹ "+orders[index]['Cost'].toString(),style: TextStyle(
                          fontFamily:'Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                      )),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: [
                      Expanded(
                        child: Container(

                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: orders[index]['items'].length,
                              itemBuilder: (context,ind){
                                return Text(//camelCase(
                                    orders[index]['items'][ind]['name'],style: TextStyle(
                                    fontFamily: 'Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.grey
                                ),
                                    );
                              }),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Text('Transaction ID : '+ orders[index]['transaction id'].toString(),style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 5,),
                  Text('Status : '+ orders[index]['result'].toString(),style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),


                ],
              ),
            );
          }
      ),
    );
}
Widget build(BuildContext context) {
    return Listdata();

  }
}

