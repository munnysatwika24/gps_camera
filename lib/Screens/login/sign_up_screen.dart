import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gps_camera/Screens/login/intro_screen.dart';
import '../../custom/bottom_container.dart';
import '../../custom/container.dart';
import '../../custom/container_left.dart';
import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key ?key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  bool isShowPassword = false;
  String errorMessage = "";
  String errorMessageEmail = "";
  String errorMessagepass = "";
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
  Widget passwordUser(IconData icon, hintText) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: passwordController,
        obscureText: isShowPassword,
        keyboardType: TextInputType.emailAddress,
        validator: (value){
          if (passwordController.text.isEmpty) {
            return  'Please enter password';
          }
          if (passwordController.text.isEmpty) {
            return  'Please enter password';
          }
          RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

          if (!regex.hasMatch(passwordController.text)){
            return ' Use combination of  Capital letters, numbers, and symbols';

          }
          else if (passwordController.text.length < 8) {
            return 'Password must be at least 8 characters';
          }
          return null;

        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black12,
            ),suffixIcon: IconButton(icon: Icon(!isShowPassword?Icons.visibility:Icons.visibility_off), onPressed: () { setState(() {
          isShowPassword = !isShowPassword;
        }); },),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.black12),
            contentPadding: EdgeInsets.all(10)),

      ),
    );
  }
  Widget userEmail(IconData icon, hintText) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: emailController,
        validator: (value){
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
          if (!regex.hasMatch(value)){
            return "Please Enter Valid Email";
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black12,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.black12),
            contentPadding: EdgeInsets.all(10)),
      ),
    );
  }
  Widget userName(IconData icon, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: userController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          // if ( value.length < 6) {
          //   return 'Password must be at least 6 characters';
          // }
          return null;
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r"[a-zA-Z]+|\s"),
          )
        ],
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black12,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.black12),
            contentPadding: EdgeInsets.all(10)),
      ),
    );
  }
  Widget _entryField(String title,) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),

          // TextField(
          //     obscureText: isPassword,
          //     decoration: const InputDecoration(
          //         border: InputBorder.none,
          //         fillColor: Color(0xfff3f3f4),
          //         filled: true))
        ],
      ),
    );
  }
  void _navigateToIntroScreen(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IntroScreen(camera: firstCamera)),
    );
  }
  Widget _submitButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],

          color: Colors.pinkAccent
        ),
        child: const Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),onTap: (){
      if (formKey.currentState!.validate()) {
        emailController.clear();
        passwordController.clear();
        _navigateToIntroScreen(context); // Call the function to navigate
      }
    },
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const<Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
          text: 'S',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)
          ),

          children: [
            TextSpan(
              text: 'ig',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'n Up',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          _entryField("Username"),
          userName(Icons.person_outline, "User Name"),


          _entryField("Email id"),
          userEmail(
            Icons.mail_outline,
            "Email",
          ),
          _entryField("Password",),
          passwordUser(
            Icons.lock_outline,
            "Password",
          ),
        ],
      ),
    );
  }

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
                    const SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    // SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}