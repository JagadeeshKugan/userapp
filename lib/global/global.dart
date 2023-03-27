import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //online- active drivers Information List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId = "";
double? userfare = 0;
String? requestid = "";
int? bidglobe = 0;
String cloudMessagingServerToken =
    "key=AAAAq1f4wWc:APA91bGPHNDmd_8qCscG8gQwf6uVi2t2bTEO9YT7te7bdG_JT0RxyzNy3RNKxhe4AFnqGXwjR9VVa-nk7BH2shFrUoKupF0j35roffNKQHgEa3V0uSJ9d1p-qgxvNJSzEdRx1WtJx0Ax";
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
double countRatingStars = 0.0;
String titleStarsRating = "";
