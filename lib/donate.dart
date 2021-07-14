
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DetailPage.dart';

class donate extends StatefulWidget {

  @override
  _Donation createState() => _Donation();

}

class _Donation extends State<donate> {

  void initState() {
    super.initState();
  }



  Widget build(BuildContext context) {

    return Scaffold(
        bottomNavigationBar: Stack(
          children: [
            Container(
              child: Image.asset('images/donate.png'),
              height: 200.0,
              width: double.infinity,
            ),
          ],
        ),
        body : ListPage(),
    );
  }

}

class ListPage extends StatefulWidget{

  @override
  _ListPageState createState() =>_ListPageState();

}

class _ListPageState extends State<ListPage>{

  Future getPosts() async{

    var firestore= FirebaseFirestore.instance;
    QuerySnapshot qn= await firestore. collection("NGO").get();
    return qn.docs;

  }

  navigateToDetail(DocumentSnapshot post){

    Navigator.push(context,
        MaterialPageRoute(
            builder:(context)=>DetailPage(post:post,)
        )
    );
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: FutureBuilder(

          future: getPosts(),
          builder: (_,snapshot){

            if(snapshot.connectionState==ConnectionState.waiting){
          return Center(
            child: Text("Loading"),
          );
        }
        else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    child: Image.asset('images/donate1.png'),
                    height: 200.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Registered NGO",
                        style: TextStyle(
                            fontFamily: 'Sans',
                            color: Colors.teal[100],
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
                ),
                Text(
                  "Under Feed the Need",
                  style: TextStyle(
                      fontFamily: 'Sans',
                      fontSize: 22,
                      letterSpacing: -0.5,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount:snapshot.data.length,
                      itemBuilder: (_,index) {
                       return ListTile(
                        title:Container(
                          child: Text(snapshot.data[index]['name'],style: TextStyle(
                              fontFamily: 'Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey
                          ),
                          ),
                        ),

                         onTap:()=>navigateToDetail(snapshot.data[index]),
                        );
                      }
                      ),
                ),
              ],
            ),
          );
        }
      }
      ),
    );
  }
}

