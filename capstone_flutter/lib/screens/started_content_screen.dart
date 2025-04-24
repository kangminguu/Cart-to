import 'dart:convert';

import 'package:capstone_project/screens/home_screen.dart';
import 'package:capstone_project/screens/login_screen.dart';
import 'package:capstone_project/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../tools/network.dart';

class StartedContentScreen extends StatefulWidget {
  const StartedContentScreen({super.key});

  @override
  State<StartedContentScreen> createState() => _StartedContentScreenState();
}

class _StartedContentScreenState extends State<StartedContentScreen> {
  late String result;
  String warning = '';
  static const storage = FlutterSecureStorage();
  dynamic userInfo = '';
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    userInfo = await storage.read(key: 'login');

    if (userInfo != null) {
      userInfo = jsonDecode(userInfo);
      Network network = Network();
      result = await network.Login(userInfo['email'], userInfo['password']);
      if (result == '0') {
        await storage.delete(key: 'login');
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    }
  }

  //미디어쿼리 높이 * 비율
  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }

  //미디어쿼리 너비 * 비율
  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF000000).withOpacity(0.0),
          shadowColor: Colors.grey.withOpacity(0.0),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.keyboard_double_arrow_left_rounded),
            color: const Color(0xFF000000).withOpacity(0.5),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: mediaHeight(context, 53 / 100),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mediaHeight(context, 65 / 1000),
                    width: mediaWidth(context, 0.85),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFed7d5a),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(180)),
                        ),
                        side: BorderSide(
                          color: const Color(0xFF000000).withOpacity(0.0),
                          width: 0.1,
                        ),
                      ),
                      child: Text(
                        "회원 가입",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF).withOpacity(1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mediaHeight(context, 2 / 100),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: mediaHeight(context, 65 / 1000),
                        width: mediaWidth(context, 0.85),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(180)),
                            ),
                            side: BorderSide(
                              color: const Color(0xFF000000).withOpacity(1.0),
                              width: 0.1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Image.asset(
                                  "./images/googleLogo.png",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Google로 계속하기",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color(0xFF000000).withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mediaHeight(context, 2 / 100),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "이미 계정이 있으신가요?",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF000000).withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "로그인 하기",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFFed7d5a),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
