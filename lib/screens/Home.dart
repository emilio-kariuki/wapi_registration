import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
            children: [
              Text("wapi", style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),),
              Text("Registration", style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),),
            ],
          )
          ],
        )
      )
    );
  }
}