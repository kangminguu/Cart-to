import 'dart:convert';
import 'package:capstone_project/screens/login_screen.dart';
import 'package:capstone_project/screens/change_email_screen.dart';
import 'package:capstone_project/screens/change_nickname_screen.dart';
import 'package:capstone_project/screens/password_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  // 로그인정보 저장소
  static const storage = FlutterSecureStorage();

  // 로그인 정보
  dynamic userInfo = '';
  String email = '';
  String password = '';
  String nickname = '';

  //미디어쿼리 높이 * 비율
  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }

  //미디어쿼리 너비 * 비율
  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  // 로그인 정보 불러오기 함수
  _asyncMethod() async {
    userInfo = await storage.read(key: 'login');
    if (userInfo != null) {
      userInfo = jsonDecode(userInfo);
      setState(
        () {
          email = userInfo['email'];
          password = userInfo['password'];
          nickname = userInfo['nickname'];
        },
      );
      //print("$email, $password, $nickname");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "마이 페이지",
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
                  builder: (context) => const MypageScreen(),
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
                SizedBox(
                  height: mediaHeight(context, 53 / 100),
                  width: mediaWidth(context, 0.85),
                  child: Column(
                    children: [
                      Container(
                        height: mediaHeight(context, 11 / 100),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 0.1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              nickname,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffFF7448),
                              ),
                            ),
                            const Text(
                              "님, 환영합니다.",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: mediaHeight(context, 5 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "이메일",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mediaHeight(context, 7 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            TextButton(
                              child: const Text(
                                '수정',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xffFF7448),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChangeEmail(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mediaHeight(context, 5 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "비밀번호",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mediaHeight(context, 7 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '*' * password.length,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            TextButton(
                              child: const Text(
                                '수정',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xffFF7448),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PasswordCheck(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mediaHeight(context, 5 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "닉네임",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mediaHeight(context, 7 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              nickname,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            TextButton(
                              child: const Text(
                                '수정',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xffFF7448),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const changeNick(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
