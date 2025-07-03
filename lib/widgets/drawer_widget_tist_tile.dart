import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerWidgetListTile extends StatefulWidget {
  bool? isLoading;
  Icon leadingIcon;
  VoidCallback ?onPress;
  String title;
  DrawerWidgetListTile({
    super.key,
    required this.leadingIcon,
     this.onPress,
    this.isLoading = false,
    required this.title,
  });

  @override
  State<DrawerWidgetListTile> createState() => _DrawerWidgetListTileState();
}

class _DrawerWidgetListTileState extends State<DrawerWidgetListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading! ? null : widget.onPress,
      child: ListTile(
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: widget.leadingIcon,
      ),
    );
  }
}
