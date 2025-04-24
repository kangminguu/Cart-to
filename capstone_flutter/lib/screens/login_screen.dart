import 'dart:convert';
import 'package:capstone_project/screens/home_screen.dart';

import 'package:flutter/material.dart';
import '../tools/network.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //입력된 정보
  String inputEmail = '';
  String inputPassword = '';
  late String result;
  String warning = '';
  static const storage = FlutterSecureStorage();
  dynamic userInfo = '';
  //미디어쿼리 높이 * 비율
  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }

  //미디어쿼리 너비 * 비율
  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

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
    } else {
      print('login please');
    }
  }

  Login(data1, data2) async {
    Network network = Network();
    result = await network.Login(data1, data2);
    if (result == '0') {
      setState(() {
        warning = '이메일 또는 비밀번호를 확인해 주세요.';
      });
    } else {
      setState(() {
        warning = '';
      });
      var val =
          jsonEncode({'email': data1, 'password': data2, 'nickname': result});
      await storage.write(
        key: 'login',
        value: val,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "로그인",
            style: TextStyle(
              color: const Color(0xFF000000).withOpacity(1.0),
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
          backgroundColor: const Color(0xFF000000).withOpacity(0.0),
          shadowColor: Colors.grey.withOpacity(0.0),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: const Color(0xFF000000).withOpacity(0.5),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: mediaHeight(context, 53 / 100),
                width: mediaWidth(context, 0.85),
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaHeight(context, 32 / 100),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: mediaHeight(context, 3 / 100),
                      child: Text(
                        "이메일",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF000000).withOpacity(0.7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaHeight(context, 1 / 100),
                    ),
                    SizedBox(
                      height: mediaHeight(context, 35 / 1000),
                      child: TextField(
                        onChanged: (value) {
                          //=========================입력된 이메일===========
                          inputEmail = value;
                        },
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.normal,
                        ),
                        cursorColor: const Color(0xFFed7d5a),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF000000).withOpacity(0.2)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF000000).withOpacity(1.0)),
                          ),
                          hintText: "이메일 입력",
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: const Color(0xFF000000).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaHeight(context, 3 / 100),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: mediaHeight(context, 3 / 100),
                      child: Text(
                        "비밀번호",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF000000).withOpacity(0.7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaHeight(context, 1 / 100),
                    ),
                    SizedBox(
                      height: mediaHeight(context, 35 / 1000),
                      child: TextField(
                        onChanged: (value) {
                          //===============================입력된 비밀번호=========
                          inputPassword = value;
                        },
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.normal,
                        ),
                        cursorColor: const Color(0xFFed7d5a),
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF000000).withOpacity(0.2)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF000000).withOpacity(1.0)),
                          ),
                          hintText: "비밀번호 입력",
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: const Color(0xFF000000).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: mediaHeight(context, 65 / 1000),
                    width: mediaWidth(context, 0.85),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          warning,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mediaHeight(context, 65 / 1000),
                    width: mediaWidth(context, 0.85),
                    child: OutlinedButton(
                      onPressed: () {
                        Login(inputEmail, inputPassword);
                        // Navigator.pop(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const LoginScreen(),
                        //   ),
                        // );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => NavibarScreen(),
                        //   ),
                        // );
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
                        "로그인",
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
                      Text(
                        "비밀번호를 잊어버리셨나요?",
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const LoginScreen(),
                          //   ),
                          // );
                        },
                        child: const Text(
                          "비밀번호 재설정",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
