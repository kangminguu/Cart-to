import 'package:flutter/material.dart';
import '../tools/network.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //입력된 정보
  String inputEmail = '';
  String inputPassword = '';
  String inputPasswordCheck = '';
  String inputNickname = '';
  String emailWarning = '';
  String rePassWarning = '';
  String nickWarning = '';
  bool isEmail = true;
  bool isPassword = true;
  bool isNickname = true;
  late String result;

  Register(data1, data2, data3) async {
    Network network = Network();
    result = await network.Register(data1, data2, data3);
  }

  checkRegisterForm(value1, value2, value3, value4) {
    String checkEmail = value1;
    String checkPassword = value2;
    String checkPassCorrect = value3;
    String checkNickname = value4;

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

    //========비밀번호, 비밀번호 확인 비교==========
    if (checkPassword != checkPassCorrect) {
      isPassword = false;
    } else {
      //========비밀번호 형식 확인==========
      //8자 이상 16자 이하, 한글 미포함
      if (checkPassword.length >= 8 && checkPassword.length <= 16) {
        if (checkPassword.contains(RegExp(r'[ㄱ-ㅎ가-힣\s]'))) {
          isPassword = false;
        } else {
          isPassword = true;
        }
      } else {
        isPassword = false;
      }
    }

    //=======닉네임 형식 확인=====
    if (checkNickname.length >= 2 && checkNickname.length <= 8) {
      if (checkNickname
          .contains(RegExp(r'''[!@#$%^&*()\-_=+`~\[\]{}\\|;:'",<.>/?\s]'''))) {
        isNickname = false;
      } else {
        isNickname = true;
      }
    } else {
      isNickname = false;
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
            "회원 가입",
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
                  builder: (context) => const RegisterScreen(),
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
                      Container(
                        alignment: Alignment.centerLeft,
                        height: mediaHeight(context, 3 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "비밀번호",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF000000).withOpacity(0.7),
                              ),
                            ),
                            Text(
                              rePassWarning,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
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
                      Container(
                        alignment: Alignment.centerLeft,
                        height: mediaHeight(context, 3 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "비밀번호 확인",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF000000).withOpacity(0.7),
                              ),
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
                            //================입력된 비밀번호 확인===============
                            inputPasswordCheck = value;
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
                            hintText: "비밀번호 확인 입력",
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "닉네임",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF000000).withOpacity(0.7),
                              ),
                            ),
                            // 경고문 출력
                            Text(
                              nickWarning,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.red,
                                  fontSize: 15),
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
                            //===================닉네임 입력====================
                            inputNickname = value;
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
                            hintText: "닉네임 입력",
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
                      child: OutlinedButton(
                        onPressed: () async {
                          await checkRegisterForm(inputEmail, inputPassword,
                              inputPasswordCheck, inputNickname);

                          // 이메일 형식 확인
                          if (isEmail == false) {
                            setState(() {
                              emailWarning = '올바르지 않은 이메일 형식입니다.';
                            });
                          } else {
                            setState(() {
                              emailWarning = '';
                            });
                          }

                          // 비밀번호 형식 확인
                          if (isPassword == false) {
                            setState(() {
                              rePassWarning = '올바르지 않은 비밀번호 형식입니다.';
                            });
                          } else {
                            setState(() {
                              rePassWarning = '';
                            });
                          }

                          // 닉네임 형식 확인
                          if (isNickname == false) {
                            setState(() {
                              nickWarning = '올바르지 않은 닉네임 형식입니다.';
                            });
                          } else {
                            setState(() {
                              nickWarning = '';
                            });
                          }

                          //형식적인 것을 모두 통과한 경우 API서버로 데이터 전송
                          if (isEmail && isPassword && isNickname) {
                            await Register(
                                inputEmail, inputPassword, inputNickname);

                            // 이메일 중복
                            if (result == '0') {
                              setState(() {
                                emailWarning = '이미 가입된 이메일입니다.';
                              });
                            }
                            // 닉네임 중복
                            else if (result == '1') {
                              setState(() {
                                emailWarning = '';
                                nickWarning = '이미 사용중인 닉네임입니다.';
                              });
                            }
                            //모든 조건통과 스크린 변경 하면됨.
                            else {
                              setState(() {
                                emailWarning = '';
                                nickWarning = '';
                              });
                            }
                          }
                          //============회원가입 완료 버튼==================
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
