
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gps_camera/Screens/login/preview_screen.dart';

import '../../custom/bottom_container.dart';
import '../../custom/container.dart';
import '../../custom/container_left.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    Key? key,
    this.title,
    required this.camera,
  }) : super(key: key);
  final String? title;
  final CameraDescription camera;
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late List<CameraDescription> cameras;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraFront = true;
  bool _isPressed = false;
  Position? _position;
  late bool servicePermission = false;
  late LocationPermission permission;
  String currentAddress = "";
  @override
  void initState() {
    super.initState();
    // _isCameraFront = !_isCameraFront;
    _initializeControllerFuture = initializeCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Position> getLocation() async {
    //checking service permissions
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      return Future.error("Location services disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  //converting co-ordinates into address
  Future<void> getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _position!.latitude,
        _position!.longitude,
      );

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        String? street = placemark.street;
        String? city = placemark.locality;
        String? state = placemark.administrativeArea;
        String? country = placemark.country;

        setState(() {
          currentAddress =
              "${street ?? ''}, ${city ?? ''}, ${state ?? ''}, ${country ?? ''}";
        });

        print('Address: $currentAddress');
      } else {
        print('No placemarks found.');
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }



  bool showFocusCircle = false;
  double x = 0;
  double y = 0;

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    CameraDescription selectedCamera;

    if (_isCameraFront) {
      selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
    } else {
      selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
    }

    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
    );

    await _controller.initialize();
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // Future<void> initializeCamera() async {
  //   cameras = await availableCameras();
  //   _controller = CameraController(cameras.first, ResolutionPreset.high);
  //   _initializeControllerFuture = _controller.initialize();
  // }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .25,
                  child: const BezierContainer()),
              Positioned(
                  top: -height * .05,
                  right: -MediaQuery.of(context).size.width * -.6,
                  child: const BezierContainerLeft()),
              Positioned(
                  top: height * 0.7,
                  right: -MediaQuery.of(context).size.width * -.4,
                  child: const BezierContainerBottom()),
              Positioned(
                  top: -height * .05,
                  right: -MediaQuery.of(context).size.width * -.6,
                  child: const BezierContainerLeft()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      // const SizedBox(height: 50),
                      const SizedBox(height: 20),
                      _divider(),
                      // SizedBox(height: height * .055),
                      //_createAccountLabel(),
                      FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          return _camera(snapshot);
                        },
                      ),
                      cameraButtons(context),
                      Visibility(
                        visible: !_isPressed,
                        child: Text(
                          currentAddress,
                          style: GoogleFonts.portLligatSans(
                            textStyle: Theme.of(context).textTheme.headlineMedium,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.pinkAccent)),
                        onPressed: () async {
                          setState(() async{
                            _isPressed = !_isPressed;
                            print("Getting location...");
                            _position = await getLocation();

                            if (_position != null) {
                              print(
                                  "Location: ${_position!.latitude},${_position!.longitude}");
                              await getAddressFromCoordinates();
                              print("Address: $currentAddress");
                            } else {
                              print(
                                  "Location services are disabled or permission is denied.");
                            }

                          });

                        },
                        child: Text("Get location"),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ));
  }
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Add Picture using Camera',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
  cameraButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [shutterButton(context), flipCamera()],
    );
  }

  Widget shutterButton(BuildContext context) {
    return Container(
      width: 75.0,
      height: 75.0,
      decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(50.0)),
      child: GestureDetector(
        child: Icon(
          Icons.camera_alt,
          size: 24,
          color: Colors.white,
        ),
        onTap: () async {

            try {
              await _initializeControllerFuture;

              // Attempt to take a picture and get the file `image`
              // where it was saved.
              final image = await _controller.takePicture();

              // If the picture was taken, display it on a new screen.
               if(_isPressed==true){
                 await Navigator.of(context).push(
                   MaterialPageRoute(
                     builder: (context) => DisplayPictureScreen(
                       // the DisplayPictureScreen widget.
                       imagePath: image,
                       latitude: _position!.latitude,
                       longitude: _position!.longitude,
                       address: currentAddress,
                     ),
                   ),
                 );
               }else{
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                     content: Text('Click on get location button',style: TextStyle(color: Colors.white),),
                     backgroundColor: Colors.deepPurple,
                   ),
                 );
               }


            } catch (e) {
              print(e);
            }


        },
      ),
    );
  }

  Widget flipCamera() {
    return Container(
      width: 75.0,
      height: 75.0,
      decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(50.0)),
      child: GestureDetector(
          child: Icon(
            Icons.cameraswitch,
            size: 24,
            color: Colors.white,
          ),
          onTap: _toggleCamera),
    );
  }

  void _toggleCamera() async {
    setState(() {
      _isCameraFront = !_isCameraFront;
    });

    await initializeCamera(); // Reinitialize the camera with the updated flag
  }

  Widget _camera(AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // If the Future is complete, display the preview.
      return Container(
        height: MediaQuery.of(context).size.height / 2.4,
        child: Stack(
          children: [
            CameraPreview(_controller),
            if (showFocusCircle)
              Positioned(
                top: y - 20,
                left: x - 20,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5)),
                ),
              ),
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(""),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          // SizedBox(
          //   width: 20,
          // ),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
          text: 'H',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)),
          children: [
            TextSpan(
              text: 'e',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'llo',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  
}


