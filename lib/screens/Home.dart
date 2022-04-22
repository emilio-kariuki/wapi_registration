import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    // this is for 3 buttons, add "false" same as the number of buttons here

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "wapi",
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                Text(
                  "Registration",
                  style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          const Action(action: "Fetch"),
          Button(size: size, actionString: "Fetch", action: () {}),
          const Action(action: "Bluetooth"),
          
        ],
      ),
    )));
  }
}

class Button extends StatelessWidget {
  final Function() action;
  final String actionString;
  const Button({
    Key? key,
    required this.size,
    required this.action,
    required this.actionString,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: SizedBox(
        height: size.height * 0.06,
        width: size.width * 0.55,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 14, 14, 20)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(
                  color: Color.fromARGB(255, 14, 14, 20),
                  width: 2.0,
                ),
              ),
            ),
          ),
          child: Text(actionString, style: GoogleFonts.roboto(fontSize: 20)),
          onPressed: () => exit(0),
        ),
      ),
    );
  }
}

class Action extends StatelessWidget {
  final String action;
  const Action({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(children: [
        Text(
          action,
          style: GoogleFonts.roboto(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ]),
    );
  }
}
