import 'package:flutter/material.dart';
import 'package:gps_camera/Screens/login/sign_up_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}
class _WelcomePageState extends State<WelcomePage> {
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: const Color(0xffdf8e33).withAlpha(100),
                  offset: const Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Color(0xfff7892b)),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpPage()));
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'W',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme
                .of(context)
                .textTheme
                .headline1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: const [
            TextSpan(
              text: 'el',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'come',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.cyanAccent, Colors.yellowAccent])),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.cyan, Colors.teal])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _title(),
                  const SizedBox(
                    height: 80,
                  ),
                  _submitButton(),
                  const SizedBox(
                    height: 20,
                  ),
                  _signUpButton(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}