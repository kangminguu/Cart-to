// import 'package:capstone_project/main.dart';
// import 'package:capstone_project/screens/navi_screens/mypage_screen.dart';
// import 'package:capstone_project/screens/navi_screens/calendar_screen.dart';
// import 'package:capstone_project/screens/navi_screens/cart_camera_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:provider/provider.dart';

// final List<CameraDescription> _cameras = ProvideCamera().cameras;
// late CameraController _controller;

// class NavibarScreen extends StatefulWidget {
//   const NavibarScreen({super.key});

//   @override
//   State<NavibarScreen> createState() => _NavibarScreenState();
// }

// class _NavibarScreenState extends State<NavibarScreen> {
//   @override
//   void initState() {
//     super.initState();

//     _controller = CameraController(
//       _cameras[0],
//       ResolutionPreset.medium,
//       // imageFormatGroup: ImageFormatGroup.jpeg,
//     );
//     _controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             // Handle access errors here.
//             break;
//           default:
//             // Handle other errors here.
//             break;
//         }
//       }
//     });
//   }

//   int _selectPage = 0;

//   static List pages = [
//     const MypageScreen(),
//     const CartCameraScreen(),
//     const CalendarScreen(),
//   ];

//   tapSelectPage(int index) {
//     setState(() {
//       const NavibarScreen();
//       _selectPage = index;
//     });
//   }

//   //미디어쿼리 높이 * 비율
//   double mediaHeight(BuildContext context, double scale) {
//     return MediaQuery.of(context).size.height * scale;
//   }

//   //미디어쿼리 너비 * 비율
//   double mediaWidth(BuildContext context, double scale) {
//     return MediaQuery.of(context).size.width * scale;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.value.isInitialized) {
//       return Container(); // 퍼미션 확인 전 띄우는 대기 화면. 링 돌아가는 대기화면 하면 좋을 듯
//     }
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<ProvideCamera>(create: (_) => ProvideCamera())
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           backgroundColor: const Color(0xFFFFFFFF),
//           resizeToAvoidBottomInset: false,
//           body: pages[_selectPage],
//           bottomNavigationBar: Container(
//             height: mediaHeight(context, 1.0 / 10),
//             decoration: const BoxDecoration(
//               boxShadow: <BoxShadow>[
//                 BoxShadow(
//                   color: Colors.grey,
//                   blurRadius: 3,
//                 ),
//               ],
//             ),
//             child: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               backgroundColor: const Color(0xFFFFFFFF),
//               selectedItemColor: const Color(0xFFFF7448),
//               selectedLabelStyle: const TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//               ),
//               unselectedItemColor: const Color(0xFFB7B7B7),
//               unselectedLabelStyle: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.normal,
//               ),
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.person),
//                   label: "마이 페이지",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.add_shopping_cart_rounded),
//                   label: "카트",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.calendar_month_outlined),
//                   label: "쇼핑 기록",
//                 ),
//               ],
//               currentIndex: _selectPage,
//               onTap: tapSelectPage,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProvideController extends ChangeNotifier {
//   CameraController get controller => _controller;
// }
