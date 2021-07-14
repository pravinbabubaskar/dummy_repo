
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_scraper/web_scraper.dart';
import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data.dart';

class WebScraperApp extends StatefulWidget {
  @override
  _WebScraperAppState createState() => _WebScraperAppState();
}

class _WebScraperAppState extends State<WebScraperApp> {
  // initialize WebScraper by passing base url of website
  final webScraper = WebScraper('https://ngodarpan.gov.in');
  final _store = FirebaseFirestore.instance;
  List<String> dummy;
  int pos,ind;
  String result;
  var address;
  bool flag = false,progress=false;
  String name;
  void findPerson(List<String> people, String Name,int i) async{
    if(people[0][0].codeUnitAt(0)>Name[0].codeUnitAt(0)){
      setState(() {
        flag = true;
        progress=false;
        showResult('Not Found',name);
      });
    }
    final index = people.indexWhere((element) => element == Name);
    if (index >= 0) {
      setState(() {
        ind=index;
        pos=i;
      });

      print('found');
      setState(() {
        result = people[index];
        flag = true;
        progress=false;
        makeVerified();
        findAddress();
        //showResult('NGO Verified',name);
      });

    }
  }

  void findAddress() async {
    var elements;
    final webScraper = WebScraper();
    if (await webScraper.loadFullURL(
        'https://ngodarpan.gov.in/index.php/home/statewise_ngo/7589/33/1?per_page=100')) {
        elements = webScraper.getElementTitle('tbody > tr > td:nth-child(4)');
        print(elements[88]);
    }
    FirebaseFirestore.instance.collection('NGO').doc(name)
        .update({'address':elements[ind],'donation':0});

  }

  void makeVerified() async{
    bool check = false;
    final snapshots = await _store.collection("NGO").get();
    for (var m in snapshots.docs) {
      var t = m.data();
      if (t['name'] == name) {
        check=true;
        print(check);
        break;
      }
    }
    if(check==true) {
      showResult("Failed", 'Already verified under \n'+ user1.email);
    }
    else{
      FirebaseFirestore.instance.collection('NGO').doc(name)
          .set({'name': name,'user':user1.email}).then((value) => print("User Added"));
      await FirebaseAuth.instance.currentUser.updateProfile(photoURL: 'dvdfv');
      showResult("Success", 'Verified');
      setState(() {
        isNGOVerified = true;
        print(isNGOVerified);
      });


    }
  }
  showResult(String message,String name) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              message,
              style: errorStyle,
            ),
            content: Text(
              name,
              style: messageStyle,
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  void fetchProducts() async {
    int i = 0;
    // Loads web page and downloads into local state of library
    while (i++ < 72 && flag == false) {
      if (await webScraper.loadWebPage(
          '/index.php/home/statewise_ngo/7589/33/$i?per_page=100')) {
        dummy = webScraper
            .getElementTitle("div.ibox-content > table > tbody > tr> td > a ");
      }
      findPerson(dummy, name,i);
    }
  }





  @override
  void initState() {
    super.initState();

    // Requesting to fetch before UI drawing starts
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          actions: [

          ],
          title: Text("NGO +",style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Sans',fontSize: 25,color: Colors.black),),
        ),
        body: isNGOVerified ?Column(
          children: [
            SizedBox(
              height: 10,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Already this user is verified under  ',
                  style: TextStyle(
                      color: Colors.black, fontSize: 25,fontFamily: 'Raleway',fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text:user1.email,
                      style: TextStyle(color: Colors.red,fontSize: 25),
                    ),
                  ]
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text('Get Food 🍱 for free',style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),textAlign: TextAlign.center,),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.only(left: 5,top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.teal[100],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' ➼ Order food and donate it for free\n',style: TextStyle(fontSize:20,fontFamily: 'Raleway',fontWeight: FontWeight.bold)),
                  Text(' ➼ Extra donation for app users\n',style: TextStyle(fontSize:20,fontFamily: 'Raleway',fontWeight: FontWeight.bold)),
                  Text(' ➼ Collaborations with hotel for large events\n',style:TextStyle(fontSize:20,fontFamily: 'Raleway',fontWeight: FontWeight.bold)),
                  Text(' ➼ More extra benefits\n',style: TextStyle(fontSize:20,fontFamily: 'Raleway',fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Image.asset('images/upgrade.png'),
          ],
        ):Padding(
          padding: const EdgeInsets.only(top:10,left: 10,right: 10),
          child: progress==true?
          Center(
            child:
            CircularProgressIndicator(
              backgroundColor: Colors.teal,
              valueColor: AlwaysStoppedAnimation(Colors.teal[100]),
            ), // Loads Circular Loading Animation
          ):
          ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'NGO name',
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Raleway',
                      fontSize: 20.0,
                  fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    name = value;
                  },
                ),
              ),
              FlatButton(
                padding: EdgeInsets.all(5),
                color: Colors.teal[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  setState(() {
                    progress=true;
                    flag=false;
                  });
                  fetchProducts();
                },
                child: Text(
                  ' Update',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                   // fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text('Get Food 🍱 for free',style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),textAlign: TextAlign.center,),
              SizedBox(
                height: 25,
              ),
              Container(
                padding: EdgeInsets.only(left: 5,top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.teal[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' ➼ Order food and donate it for free\n',style: TextStyle(fontSize:20,fontFamily: 'Raleway',fontWeight: FontWeight.bold)),
                    Text(' ➼ Extra donation for app users\n',style: TextStyle(fontSize:20,fontFamily: 'Raleway',fontWeight: FontWeight.bold)),
                    Text(' ➼ Collaborations with hotel for large events\n',style:TextStyle(fontSize:20,fontFamily: 'Raleway',fontWeight: FontWeight.bold)),
                    Text(' ➼ More extra benefits\n',style: TextStyle(fontSize:20,fontFamily: 'Raleway',fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
               Image.asset('images/upgrade.png'),
            ],
          ),
        ),
      ),
    );
  }
}
