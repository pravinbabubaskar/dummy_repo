import 'package:flutter/material.dart';
import 'data.dart';
import 'billPage.dart';


class Cart extends StatefulWidget {
  Cart(String hotel){
   hotelName=hotel;
  }

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  var map = Map();
  List<dynamic> Data=new List();
  int totalCost =0,withOut=0;
  int len=0;
  double pass=0;
  void initState() {
    // TODO: implement initState
    super.initState();
    countOcc();
    total();
    len=Data.length;
    finalCart=Data;
   // pass=(withOut+(withOut*0.1)) as double;
  }
  countOcc(){

    cartData.forEach((element) {
      if(!map.containsKey(element)) {
        map[element] = 1;
        Data.add(element);
      } else {
        map[element] +=1;
      }
    });
  }
  @override
  void total(){
    withOut=cost;
    if(isNGOVerified){
      totalCost-=0;
    }
    else{
      totalCost=(cost/2).round();
    }

  }

  navigateToBilling(int bill){

    Navigator.push(context,
        MaterialPageRoute(
            builder:(context)=>billPage(
            bill:bill,)
        )
    );
  }
  Widget build(BuildContext context) {
    return Data.length==0?Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/cart.png'),
          Text('No More Waste',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poppins",
              letterSpacing: -1,
              color: Colors.black,
              fontSize: 20,
            ),),
          Text("Your cart is empty. Add something from the menu",
            textAlign: TextAlign.center,
            style: TextStyle(
            fontFamily: "Sans",
            letterSpacing: -1,
            color: Colors.grey,
            fontSize: 20,
          ),
          ),
        ],
      )
    ):Scaffold(

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Text("Your Cart", style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700
                        ),),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            height: 0.5,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: Data.length,
                      itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                                    child: placesWidget(Data[index]),
                                  );
              },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total ($len)", style: TextStyle(
                          fontFamily: 'Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 18
                        ),),
                        Text("\₹ $withOut", style: TextStyle(
                            fontFamily: 'Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                        ),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("+Taxes", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: 'Sans',
                            color: Colors.grey
                        ),),
                        Text("\₹ "+(
                            withOut*0.1
                        ).toString(), style: TextStyle(
                            fontFamily: 'Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey
                        ),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Discounts", style: TextStyle(
                            fontFamily: 'Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey
                        ),),
                        Text(isNGOVerified==true? "- $withOut":"- "+ (withOut/2).toString() , style: TextStyle(
                            fontFamily: 'Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey
                        ),)
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Payable", style: TextStyle(
                          fontFamily: 'Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),),
                        Text(((totalCost+(withOut*0.1))).toString(), style: TextStyle(
                            fontFamily: 'Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black
                        ),)
                      ],
                    ),
                    SizedBox(height: 25,),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: (){
                        navigateToBilling((totalCost+(withOut*0.1)).round());
                        totalValue=(totalCost+(withOut*0.1)).round();
                        },//openSuccessPage,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          color: Colors.teal[100],
                        ),
                        child: Text("Order", style: TextStyle(
                          fontFamily: 'Sans',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700
                        ),),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Row placesWidget(Map<dynamic,dynamic>mp)
  {
    return Row(

      children: [
        Container(
          height: 100,
          width: 125,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: mp["p_url"] == null
                  ? Image.asset(
                "images/food.png",
                fit: BoxFit.contain,
                height: 25,
                width: 50,
              )
                  : Image.network(
                mp["p_url"],
                fit: BoxFit.contain,

              )),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${mp['name'][0].toUpperCase()}${mp['name'].substring(1)}',style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              ),),

            ],
          ),
        ),
        SizedBox(width: 10,),
        Row(
          children: [
            Container(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    if(map[mp]==1){
                      Data.removeWhere((element) => element==mp);
                      cartData.clear();
                      map.clear();
                      totalCost=withOut=cost=toto=0;
                    }
                    else {
                        map[mp]--;
                       // totalCost-=int.parse(mp["price"]);
                        cost-=int.parse(mp["price"]);
                        total();
                    }
                  });
                },
                child: Text("-", style: TextStyle(
                    fontSize: 25,
                    color: Colors.black
                ),),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Text(map[mp].toString(), style: TextStyle(

                    fontSize: 13,
                    fontWeight: FontWeight.w700
                ),),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    map[mp]++;
                    //totalCost+=int.parse(mp["price"]);
                    cost+=int.parse(mp["price"]);
                    total();
                  });
                },
                child: Text("+", style: TextStyle(
                    fontSize: 18,
                    color: Colors.black
                ),),
              ),
            ),
          ],
        ),
        SizedBox(width: 60,),
        Text((int.parse(mp['price'])*map[mp]).toString(),style: TextStyle(
          fontFamily: 'Sans',
          fontSize: 15,
          color: Colors.grey
        ),)
      ],
    );
  }

}
