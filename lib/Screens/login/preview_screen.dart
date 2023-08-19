import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:camera/camera.dart';

class DisplayPictureScreen extends StatefulWidget {
  final XFile imagePath;
  final double latitude;
  final double longitude;
  final String? address;
  const DisplayPictureScreen(
      {Key? key,
        required this.imagePath,
        required this.latitude,
        required this.longitude,
        this.address})
      : super(key: key);

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String presentAddress ="";

  @override
  void initState() {
    super.initState();
    getAddressFromCoordinates(widget.latitude, widget.longitude);
  }
  Future<void> getAddressFromCoordinates(latitude, longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        String? street = placemark.street;
        String? city = placemark.locality;
        String? state = placemark.administrativeArea;
        String? country = placemark.country;

        setState(() {
          presentAddress =
          "${street??'' },${city??''},\n${state } , ${country??'' }";
        });

        print('Address: $presentAddress');
      } else {
        print('No placemarks found.');
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(90), // Set this height
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Text(
              'Captured Picture',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: previewPicture(context),
    );
  }

  previewPicture(BuildContext context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height / 1.8,
            child: Stack(children: [
              Image.file(File(widget.imagePath.path)),
              Positioned(bottom: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height/8,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Latitude :${widget.latitude} ",style: GoogleFonts.portLligatSans(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),),
                      Text("Longitude : ${widget.longitude} ",style: GoogleFonts.portLligatSans(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),),
                      Text("Address :${presentAddress}",style:GoogleFonts.portLligatSans(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ) ,textAlign: TextAlign.left,  // Align the text to the left
                        softWrap: true,)
                    ],
                  ),
                ),
              ),

            ])),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: verifyPicture(context),
        )
      ],
    );
  }

  verifyPicture(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 75.0,
            height: 75.0,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(50.0)),
            child: GestureDetector(
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..pop(widget.imagePath);
              },
            )),
        Container(
            width: 75.0,
            height: 75.0,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(50.0)),
            child: GestureDetector(
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ))
      ],
    );
  }
}