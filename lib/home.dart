import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'near_me.dart';
import 'explore.dart';
import 'account.dart';
import 'cart.dart';

String userLoc;

class HomePage extends StatefulWidget {
  String location;
  HomePage({Key key, @required this.location}) : super(key: key) {
    userLoc = location;
  }
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  List<Widget> _screen = [NearMe(), Explore(), Cart(null), Account()];

  void _onItemTaped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getUser() async {
    User firebaseUser = await _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  dynamic move() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Cart(null)),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Colors.teal[400],
          inactiveIconColor: Colors.teal,
          // barBackgroundColor: Colors.teal,
          tabs: [
            TabData(
              iconData: Icons.home,
              title: "Home",
            ),
            TabData(
              iconData: Icons.search,
              title: "Search",
            ),
            TabData(
              iconData: Icons.shopping_cart,
              title: "cart",
            ),
            TabData(
              iconData: Icons.account_circle_outlined,
              title: "Account",
            )
          ],
          onTabChangedListener: (position) {
            setState(() {
              _onItemTaped(position);
              _selectedIndex = position;
            });
          },
        ),
        /*  BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        fixedColor: Colors.teal,
        onTap: _onItemTaped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Near Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
        selectedLabelStyle: TextStyle(fontFamily: 'Sans'),
        currentIndex: _selectedIndex,
      ),*/
        body: PageView(
          controller: _pageController,
          children: _screen,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ));
  }
}
