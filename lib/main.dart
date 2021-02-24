import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Redeem.dart';
import 'modal/homemodal.dart';

var hmodal = HomeModal();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(fontFamily: "Montserrat", accentColor: Colors.green[900]),
      debugShowCheckedModeBanner: false,
      home: Scaffold(backgroundColor: Colors.white, body: Home()),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Klear Money",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlue[900],
        elevation: 0,
      ),
      drawer: Drawer(
        child: Container(
          height: 500,
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("Users")
              .doc("7vL0geFN6LpiaprhchMN")
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            hmodal.setWithdrawn = snapshot.data["withdrawn"];
            hmodal.setSalary = snapshot.data["total"];
            hmodal.setUsername = snapshot.data["name"];
            hmodal.setSdate = snapshot.data["date"];
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      color: Colors.lightBlue[900],
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Welcome Back Neeraj,",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        getCredits(context),
                        history(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

Widget getCredits(context) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "You have used " +
              hmodal.getWithdrawnPercentage().toString() +
              "% of your earnings",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: hmodal.getWithdrawnPercentage() * 0.01,
            minHeight: 10,
            backgroundColor: Colors.green[100],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "*" + hmodal.geDaysLeft().toString() + " days left",
            ),
            Text("₹" +
                hmodal.getWithdrawn.toString() +
                " / ₹" +
                hmodal.getSalary.toString()),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          child: OutlinedButton(
              onPressed: () {
                if (hmodal.getEligibleCredits() >= 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Redeem(),
                      ));
                }
              },
              style: ButtonStyle(
                  backgroundColor: hmodal.getEligibleCredits() < 1
                      ? MaterialStateProperty.all(Colors.red[900])
                      : MaterialStateProperty.all(Colors.green[900])),
              child: Text(
                  hmodal.getEligibleCredits() < 1
                      ? "You have no more Credits available"
                      : "Get upto ₹" +
                          hmodal.getEligibleCredits().toStringAsFixed(0) +
                          " Credits Now",
                  style: TextStyle(color: Colors.white))),
        )
      ],
    ),
  );
}

Widget history() {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 5),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Previous credits",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 70,
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("Users/7vL0geFN6LpiaprhchMN/history")
                  .orderBy("date", descending: true)
                  .limit(10)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (snapshot.data.docs.length == 0)
                  return Center(
                    child: Text("No Transactions made this month"),
                  );
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.circular(25)),
                            child: Text(
                              snapshot.data.docs[index]["date"]
                                  .toDate()
                                  .day
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          index != snapshot.data.docs.length - 1
                              ? Container(
                                  width: 25,
                                  height: 3,
                                  color: Colors.green[900],
                                )
                              : Container(),
                        ],
                      ),
                      Text("  ₹" +
                          snapshot.data.docs[index]["amount"].toString()),
                    ],
                  ),
                );
              }),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(onPressed: () {}, child: Text("View All")),
          ],
        )
      ],
    ),
  );
}
