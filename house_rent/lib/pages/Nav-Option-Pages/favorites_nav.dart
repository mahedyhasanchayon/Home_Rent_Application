import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteNav extends StatelessWidget {
  const FavoriteNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: Color.fromARGB(
                  255, 248, 250, 250), // Background color of AppBar
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0), // Rounded bottom corners
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.meeting_room_sharp,size: 30,color: Color.fromARGB(255, 250, 70, 70),),
                  onPressed: () {
                    // Add logic to handle back navigation if needed
                  },
                ),
                SizedBox(width: 8.0),
                Text(
                  "বাড়ি বদল",
                  style: GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 250, 70, 70)),
                ),
                Spacer(), // Adds flexible space between title and actions
              ],
            ),
          ),
        ),
      ),
      body:   SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 120,),
            SvgPicture.asset("assets/images/house_search.svg",height: 80,width:80,),
            SizedBox(height: 50.0,),
            Text("আপনার এই মুহূর্তে কোনো পছন্দের বিজ্ঞাপন নেই,\nপছন্দের বিজ্ঞাপন গুলো এখানে একত্রিত থাকবে।",style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    )
    );
    
     
  }
}