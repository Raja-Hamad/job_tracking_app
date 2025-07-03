import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ReusableContainerWidget extends StatefulWidget {
  String title;
  String containerText;
  ReusableContainerWidget({
    super.key,
    required this.containerText,
    required this.title,
  });

  @override
  State<ReusableContainerWidget> createState() =>
      _ReusableContainerWidgetState();
}

class _ReusableContainerWidgetState extends State<ReusableContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            child: Text(
              widget.containerText,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
