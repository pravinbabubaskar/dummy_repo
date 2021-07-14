
import 'UpiPayment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget{

  final DocumentSnapshot post;
  DetailPage({this.post});

  @override

  _DetailPageState createState() =>_DetailPageState();

}

class _DetailPageState extends State<DetailPage>{
 // get infinity => null;


  @override

  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Stack(
        children: [
          Container(
            //decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(30.0),
            //color:Colors.blueGrey,
            //),
            //margin: EdgeInsets.all(5.0),
            //padding: const EdgeInsets.all(5),
            child: Image(image: AssetImage('images/test.png'),
            ),//asset('images/bill2crp.png'),
            //height: 350.0,
            //alignment:Alignment.center,
            //width:double.infinity,
          ),

        ],
      ),
      appBar:AppBar(
          backgroundColor: Colors.white,
          title:Text('NGO Details',style: TextStyle(
              fontFamily: 'Sans',
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold),

          ),
          leading: IconButton(
            icon:Icon(Icons.arrow_back,color: Colors.teal[100],),
            onPressed: ()
            {
              Navigator.pop(context, false);
            },
          ),
          centerTitle: true),

      body:
      Container(
  child:
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(
      children: [
        Column(
          children: [
            Row(
              children: [
                Text("Trust Name :  ",  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Colors.grey,
                    ),),
                Expanded(
                  child: Text(widget.post.get('name'),  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Text("Address:  ",  style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  color: Colors.grey,
                ),),
                Expanded(
                  child: Text(widget.post.get('address'),  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Text("Mail@:  ",  style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  color: Colors.grey,
                ),),
                Expanded(
                  child: Text(widget.post.get('user'),  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Colors.black,
                  ),),
                ),
              ],
            ),
            SizedBox(height: 35,),
            Text("Donation Received So Far :  "+"₹ "+widget.post.get('donation').toString(),  style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              color: Colors.black,
            ),),
            SizedBox(height: 25,),
          ],
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  primary: Colors.teal.shade200, // background
                  onPrimary: Colors.white,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ) // foreground
              ),
              child: Text(
                'DONATE',
                style: TextStyle(
                  fontFamily: 'Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => UpiPayment(widget.post.get('user'),widget.post.get('name'),
                        int.parse(
                            widget.post.get('donation').toString()
                        )
                    ),
                  ));
            }
              ),
        ),
      ],
    ),
  ),

      ),
    );
  }
}