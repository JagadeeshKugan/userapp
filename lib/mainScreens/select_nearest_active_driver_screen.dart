import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/main.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  _SelectNearestActiveDriversScreenState createState() =>
      _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState
    extends State<SelectNearestActiveDriversScreen> {
  String fareAmount = "";

  getFareAmountAccordingToVehicleType(int index) {
    if (tripDirectionDetailsInfo != null) {
      if (dList[index]["car_details"]["type"].toString() == "bike") {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                        tripDirectionDetailsInfo!) /
                    2)
                .toStringAsFixed(1);
      }
      if (dList[index]["car_details"]["type"].toString() ==
          "uber-x") //means executive type of car - more comfortable pro level
      {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                        tripDirectionDetailsInfo!) *
                    2)
                .toStringAsFixed(1);
      }
      if (dList[index]["car_details"]["type"].toString() ==
          "uber-go") // non - executive car - comfortable
      {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                    tripDirectionDetailsInfo!))
                .toString();
      }
    }
    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        shadowColor: Colors.blueAccent,
        title: const Text(
          "Nearest Online Drivers",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () {
            //delete/remove the ride request from database
            widget.referenceRideRequest!.remove();
            Fluttertoast.showToast(msg: "you have cancelled the ride request.");

            SystemNavigator.pop();
            // Future.delayed(const Duration(milliseconds: 4000), () {
            //   MyApp.restartApp(context);
            // });
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                chosenDriverId = dList[index]["id"].toString();
                userfare = double.parse(
                    getFareAmountAccordingToVehicleType(index) ?? '0');

                log("0" + userfare.toString());

                FirebaseDatabase.instance
                    .ref()
                    .child("drivers")
                    .child(chosenDriverId!)
                    .child("fare")
                    .set(userfare);
              });
              Navigator.pop(context, "driverChoosed");
            },
            child: Card(
              color: Colors.blue[900],
              elevation: 3,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    "images/" +
                        dList[index]["car_details"]["type"].toString() +
                        ".png",
                    width: 70,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dList[index]["name"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      dList[index]["car_details"]["car_model"],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    SmoothStarRating(
                      rating: dList[index]["ratings"] == null
                          ? 0.0
                          : double.parse(dList[index]["ratings"]),
                      color: Colors.yellowAccent,
                      borderColor: Colors.black,
                      allowHalfRating: true,
                      starCount: 5,
                      size: 15,
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₹ " + getFareAmountAccordingToVehicleType(index),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      tripDirectionDetailsInfo != null
                          ? tripDirectionDetailsInfo!.duration_text!
                          : "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                    // add the bargain here
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      tripDirectionDetailsInfo != null
                          ? tripDirectionDetailsInfo!.distance_text!
                          : "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
