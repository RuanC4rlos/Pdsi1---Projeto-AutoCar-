import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // add any necessary initialization for the image here
    // for example, if using AssetImage:
    // precacheImage(AssetImage('assets/your_image.png'), context);

    // add any other necessary initialization here

    _navigateToHome();
  }

  void _navigateToHome() async {
    // add any necessary delays or operations here

    // delay for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // navigating to home screen
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, AppRoutes.LOGIN_MAIN_PAGE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body:

          // Center(
          //   // replace VideoPlayer with Image
          //   child: Image.asset(
          //     'assets/images/logo.png',
          //     color: const Color(0xFF003BDF), // replace with your image path
          //     // add any other necessary properties here
          //   ),
          // ),
          Center(
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Color.fromRGBO(0, 0, 255, 1),
            BlendMode.srcIn,
          ),
          child: Container(
            width: 226,
            height: 45.17,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
