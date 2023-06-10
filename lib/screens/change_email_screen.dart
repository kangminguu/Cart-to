import 'package:flutter/material.dart';
import '../tools/network.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'login_screen.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  //입력된 정보
  String inputEmail = '';

  String emailWarning = '';

  bool isEmail = true;

  dynamic userInfo = '';

  String email = '';

  String password = '';

  String nickname = '';

  static const storage = FlutterSecureStorage();

  late String result;

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
          email = userInfo['email'];
          password = userInfo['password'];
          nickname = userInfo['nickname'];
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  emailChange(data1, data2) async {
    Network network = Network();
    result = await network.changeEmail(data1, data2);
  }

  checkEmailForm(value1) {
    String checkEmail = value1;

    //========이메일 형식 확인=============
    if (checkEmail.contains('@') && checkEmail.contains('.')) {
      if (checkEmail.split('@')[0].isNotEmpty &&
          checkEmail.split('@')[1].length >= 3) {
        if (!checkEmail.contains(RegExp(r'[\s]'))) {
          isEmail = true;
        } else {
          isEmail = false;
        }
      } else {
        isEmail = false;
      }
    } else {
      isEmail = false;
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
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "이메일 변경",
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
                  builder: (context) => const ChangeEmail(),
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
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: mediaHeight(context, 3 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "이메일",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF000000).withOpacity(0.7),
                              ),
                            ),
                            Text(
                              emailWarning,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.red),
                            ),
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
                            //======================이메일 입력============
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
                      Column(
                        children: [
                          SizedBox(
                            height: mediaHeight(context, 65 / 1000),
                            width: mediaWidth(context, 0.85),
                            child: OutlinedButton(
                              onPressed: () async {
                                await checkEmailForm(inputEmail);

                                // 이메일 형식 확인
                                if (isEmail == false) {
                                  setState(() {
                                    emailWarning = '올바르지 않은 이메일 형식입니다.';
                                  });
                                } else {
                                  result = await emailChange(inputEmail, email);

                                  // 이메일 중복
                                  if (result == '0') {
                                    setState(() {
                                      emailWarning = '이미 가입된 이메일입니다.';
                                    });
                                  } else {
                                    storage.delete(key: 'login');
                                    storage.write(
                                      key: 'login',
                                      value: jsonEncode(
                                        {
                                          'email': inputEmail,
                                          'password': password,
                                          'nickname': nickname
                                        },
                                      ),
                                    );
                                    setState(() {});
                                    Navigator.pop(context);
                                  }
                                  setState(() {
                                    emailWarning = '';
                                  });
                                }

                                //형식적인 것을 모두 통과한 경우 API서버로 데이터 전송

                                //============회원가입 완료 버튼==================
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFFed7d5a),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(180)),
                                ),
                                side: BorderSide(
                                  color:
                                      const Color(0xFF000000).withOpacity(0.0),
                                  width: 0.1,
                                ),
                              ),
                              child: Text(
                                "이메일 변경",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color(0xFFFFFFFF).withOpacity(1.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
