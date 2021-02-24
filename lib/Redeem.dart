import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'main.dart';

class Redeem extends StatefulWidget {
  @override
  _RedeemState createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  var _value = 0.0;
  var _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
      ),
      bottomSheet: _loading
          ? Container(
              margin: EdgeInsets.only(top: 70, left: 50, right: 50),
              child: LinearProgressIndicator())
          : SwipingButton(
              key: UniqueKey(),
              text: "Get Credits",
              backgroundColor: Colors.greenAccent,
              swipeButtonColor: Colors.green,
              padding: EdgeInsets.all(10),
              height: 50,
              onSwipeCallback: () async {
                setState(() {
                  if (_value == 0.0) return;
                  _loading = true;
                });
                if (_value == 0.0)
                  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Please enter a valid amount",
                    ),
                    duration: Duration(seconds: 1),
                  ));
                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc("7vL0geFN6LpiaprhchMN")
                    .update({
                  "withdrawn": FieldValue.increment(
                      _value.toInt() + (_value * 0.02).toInt())
                });
                await FirebaseFirestore.instance
                    .collection("Users/7vL0geFN6LpiaprhchMN/history")
                    .add({
                  "amount": _value.toStringAsFixed(0),
                  "date": FieldValue.serverTimestamp()
                });
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreditComplete(),
                    ),
                    (route) => false);
              },
            ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              "₹" + _value.toStringAsFixed(0),
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(
              height: 50,
            ),
            Slider(
                value: _value,
                min: 0,
                max: hmodal.getEligibleCredits(),
                activeColor: Colors.green,
                inactiveColor: Colors.greenAccent,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                }),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Transaction Details",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Amount Withdrawn"),
                      Text("₹" + _value.toStringAsFixed(0))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Amount Remaining"),
                      Text("₹" +
                          (hmodal.getSalary - hmodal.getWithdrawn - _value)
                              .toStringAsFixed(0))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Klear Money Fees"),
                      Text("₹" + (_value * 0.02).toStringAsFixed(0))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CreditComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Credited Successfully'),
          OutlinedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                    (route) => false);
              },
              child: Text("Back to Home")),
        ],
      ),
    ));
  }
}
