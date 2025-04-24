import 'package:capstone_project/main.dart';
import 'package:capstone_project/screens/navi_screens/calendar_screen.dart';
import 'package:capstone_project/screens/navi_screens/cart_camera_screen.dart';
import 'package:capstone_project/screens/navi_screens/mypage_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

final List<CameraDescription> _cameras = ProvideCamera().cameras;
late CameraController _controller;

bool _isAnimated = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _asyncMethod();
    // });

    _controller = CameraController(
      _cameras[0],
      ResolutionPreset.medium, // 480p (640x480 on iOS, 720x480 on Android)
      // imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _isAnimated = true;
    });
  }

  // // 로그인 정보 불러오기 함수
  // _asyncMethod() async {
  //   userInfo = await storage.read(key: 'login');
  //   if (userInfo != null) {
  //     userInfo = jsonDecode(userInfo);
  //     setState(
  //       () {
  //         email = userInfo['email'];
  //         password = userInfo['password'];
  //         nickname = userInfo['nickname'];
  //       },
  //     );
  //     //print("$email, $password, $nickname");
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const LoginScreen(),
  //       ),
  //     );
  //   }
  // }

  // 카드 넘어가는거
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(); // 퍼미션 확인 전 띄우는 대기 화면. 링 돌아가는 대기화면 하면 좋을 듯
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProvideCamera>(create: (_) => ProvideCamera())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFF6F6F6),
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              SizedBox(
                // color: const Color(0xffE87D5C), // 변경된 주황색, 좀 더 채도를 낮춤
                height: mediaHeight(context, 50 / 100),
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      "images/home_background.svg",
                      fit: BoxFit.fill,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: mediaHeight(context, 3 / 100),
                        left: mediaWidth(context, 6 / 100),
                      ),
                      width: mediaWidth(context, 35 / 100),
                      child: SvgPicture.asset(
                        "images/logo.svg",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: mediaHeight(context, 10 / 100),
                        left: mediaWidth(context, 6 / 100),
                      ),
                      child: Text(
                        "당신의 쇼핑 메이트\n이제 편리하게\n당신의 소비를 기록하세요.",
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: mediaHeight(context, 2.2 / 100),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: mediaWidth(context, 75 / 100),
                      margin: EdgeInsets.only(
                        top: mediaHeight(context, 20 / 100),
                        left: mediaWidth(context, 8 / 100),
                      ),
                      child: SvgPicture.asset(
                        "images/moving_cart.svg",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: mediaHeight(context, 27 / 100),
                        left: mediaWidth(context, 70 / 100),
                      ),
                      width: mediaWidth(context, 25 / 100),
                      child: SvgPicture.asset(
                        "images/phone.svg",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: mediaHeight(context, 50 / 100),
                // color: Colors.pink.shade100,
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaHeight(context, 8 / 100),
                      width: mediaWidth(context, 85 / 100),
                      child: Row(
                        children: [
                          Text(
                            "사용자",
                            style: TextStyle(
                              color: const Color(0xFFE87D5C),
                              fontSize: mediaHeight(context, 2.5 / 100),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: mediaWidth(context, 0.3 / 100),
                          ),
                          Text(
                            "님, 환영합니다!",
                            style: TextStyle(
                              color: const Color(0xFF474747),
                              fontSize: mediaHeight(context, 2.5 / 100),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: mediaHeight(context, 30 / 100), // card height
                      child: PageView.builder(
                        itemCount: 3,
                        controller: PageController(viewportFraction: 0.85),
                        onPageChanged: (int index) =>
                            // setState(() => _index = index),
                            setState(() {
                          _index = index;
                        }),
                        itemBuilder: (_, i) {
                          final List pages = [
                            const CartCameraScreen(),
                            const CalendarScreen(),
                            const MypageScreen(),
                          ];

                          final List descs = [
                            "카트 촬영하기",
                            "쇼핑 기록 확인하기",
                            "내 정보 확인하기",
                          ];

                          final List descDetail = [
                            "카트를 촬영하고\n편리하게 쇼핑 목록을\n기록하세요.",
                            "기록한 쇼핑 내역을\n확인하세요.",
                            "입력된 내 정보를\n확인하고\n수정할 수 있어요.",
                          ];

                          final List images = [
                            "images/cart_logo.svg",
                            "images/calendar_log.svg",
                            "images/user_info.svg",
                          ];

                          return Transform.scale(
                            scale: i == _index ? 1 : 0.90,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => pages[i],
                                  ),
                                );
                              },
                              child: Card(
                                // elevation: 6,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: mediaHeight(context, 3 / 100),
                                        left: mediaHeight(context, 3 / 100),
                                      ),
                                      child: Text(
                                        descs[i],
                                        style: TextStyle(
                                          color: const Color(0xFF474747),
                                          fontSize:
                                              mediaHeight(context, 2.5 / 100),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: mediaHeight(context, 7 / 100),
                                        left: mediaHeight(context, 3 / 100),
                                      ),
                                      child: Text(
                                        descDetail[i],
                                        style: TextStyle(
                                          color: const Color(0xFF474747),
                                          fontSize:
                                              mediaHeight(context, 2.0 / 100),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: mediaWidth(context, 45 / 100),
                                          top: mediaHeight(context, 10 / 100)),
                                      width: mediaWidth(context, 30 / 100),
                                      child: SvgPicture.asset(
                                        images[i],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: mediaHeight(context, 1 / 100),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_index == 0) ...[
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0xFFE87D5C),
                            ),
                            height: mediaHeight(context, 1 / 100),
                            width: mediaHeight(context, 1 / 100),
                          ),
                          SizedBox(
                            width: mediaHeight(context, 1 / 100),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0xFFDFDFDF),
                            ),
                            height: mediaHeight(context, 1 / 100),
                            width: mediaHeight(context, 1 / 100),
                          ),
                          SizedBox(
                            width: mediaHeight(context, 1 / 100),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0xFFDFDFDF),
                            ),
                            height: mediaHeight(context, 1 / 100),
                            width: mediaHeight(context, 1 / 100),
                          )
                        ] else if (_index == 1) ...[
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0xFFDFDFDF),
                            ),
                            height: mediaHeight(context, 1 / 100),
                            width: mediaHeight(context, 1 / 100),
                          ),
                          SizedBox(
                            width: mediaHeight(context, 1 / 100),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0xFFE87D5C),
                            ),
                            height: mediaHeight(context, 1 / 100),
                            width: mediaHeight(context, 1 / 100),
                          ),
                          SizedBox(
                            width: mediaHeight(context, 1 / 100),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0xFFDFDFDF),
                            ),
                            height: mediaHeight(context, 1 / 100),
                            width: mediaHeight(context, 1 / 100),
                          )
                        ] else if (_index == 2) ...[
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0xFFDFDFDF),
                            ),
                            height: mediaHeight(context, 1 / 100),
                            width: mediaHeight(context, 1 / 100),
                          ),
                          SizedBox(
                            width: mediaHeight(context, 1 / 100),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0xFFDFDFDF),
                            ),
                            height: mediaHeight(context, 1 / 100),
                            width: mediaHeight(context, 1 / 100),
                          ),
                          SizedBox(
                            width: mediaHeight(context, 1 / 100),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0xFFE87D5C),
                            ),
                            height: mediaHeight(context, 1 / 100),
                            width: mediaHeight(context, 1 / 100),
                          )
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProvideController extends ChangeNotifier {
  CameraController get controller => _controller;
}
