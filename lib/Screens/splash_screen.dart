import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
class Splash_screen extends StatefulWidget {
  const Splash_screen({super.key});
  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds:2), () { Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Home_screen()));});
  }
  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.sizeOf(context).height*1;
    final width=MediaQuery.sizeOf(context).width*1;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: height * 0.2),
            Image.asset('images/splash_pic.jpg',fit: BoxFit.cover,width:width*.9,height:height*.5),
            SizedBox(height:height*0.04,),
            Text("Top headlines",style: GoogleFonts.anton(),),
            SizedBox(height:height*.04),
            SpinKitWanderingCubes(color: Colors.blue,size: 40,)
          ],
        ),
      ),
    );
  }
}
