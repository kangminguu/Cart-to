import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordCheck extends StatefulWidget {
  const PasswordCheck({super.key});

  @override
  State<PasswordCheck> createState() => _PasswordCheckState();
}

class _PasswordCheckState extends State<PasswordCheck> {
  //입력된 정보
  String inputPassword = '';
  //미디어쿼리 높이 * 비율
  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }

  //미디어쿼리 너비 * 비율
  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

  dynamic userInfo = '';
  String passWarning = '';
  static const storage = FlutterSecureStorage();
  String password = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    userInfo = await storage.read(key: 'login');
    if (userInfo != null) {
      userInfo = jsonDecode(userInfo);
      setState(
        () {
          password = userInfo['password'];
        },
      );
    } else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const LoginScreen(),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "비밀번호 변경",
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
                  builder: (context) => const PasswordCheck(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: const Color(0xFF000000).withOpacity(0.5),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: mediaHeight(context, 25 / 100)),
                SizedBox(
                  width: mediaWidth(context, 0.85),
                  child: Column(
                    children: [
                      Container(
                        height: mediaHeight(context, 11 / 100),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: mediaHeight(context, 3 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "현재 비밀번호",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF000000).withOpacity(0.7),
                              ),
                            ),
                            Text(
                              passWarning,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mediaHeight(context, 1 / 100),
                      ),
                      SizedBox(
                        height: mediaHeight(context, 35 / 1000),
                        child: TextField(
                          onChanged: (value) {
                            //====================입력된 비밀번호===============
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
                      SizedBox(
                        height: mediaHeight(context, 3 / 100),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: mediaHeight(context, 65 / 1000),
                      width: mediaWidth(context, 0.85),
                      child: OutlinedButton(
                        onPressed: () async {
                          //============회원가입 완료 버튼==================
                          if (password == inputPassword) {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const LoginScreen(),
                            //   ),
                            // );
                          } else {
                            setState(() {
                              passWarning = '비밀번호가 일치하지 않습니다.';
                            });
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFed7d5a),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(180)),
                          ),
                          side: BorderSide(
                            color: const Color(0xFF000000).withOpacity(0.0),
                            width: 0.1,
                          ),
                        ),
                        child: Text(
                          "회원 가입 완료",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFFFFF).withOpacity(1.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaHeight(context, 3 / 100),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
