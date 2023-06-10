import 'package:capstone_project/main.dart';
import 'package:capstone_project/screens/navi_screens/calendar_screen.dart';
import 'package:capstone_project/screens/navi_screens/cart_camera_screen.dart';
import 'package:capstone_project/screens/navi_screens/mypage_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

final List<CameraDescription> _cameras = ProvideCamera().cameras;
late CameraController _controller;

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
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "홈",
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
                // Navigator.pop(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ,
                //   ),
                // );
                print("여기를 누르면 앱이 종료되도록");
              },
              icon: const Icon(Icons.arrow_back_ios_new),
              color: const Color(0xFF000000).withOpacity(0.5),
            ),
          ),
          backgroundColor: const Color(0xFFFFFFFF),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: mediaHeight(context, 100 / 100),
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
                            children: const [
                              Text(
                                // nickname,
                                "강민구",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffFF7448),
                                ),
                              ),
                              Text(
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MypageScreen(),
                              ),
                            );
                          },
                          child: const Text("회원정보수정"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartCameraScreen(),
                              ),
                            );
                          },
                          child: const Text("카트"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CalendarScreen(),
                              ),
                            );
                          },
                          child: const Text("기록"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProvideController extends ChangeNotifier {
  CameraController get controller => _controller;
}
