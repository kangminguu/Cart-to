import 'package:capstone_project/screens/home_screen.dart';
import 'package:capstone_project/tools/network.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:camera/camera.dart';

final CameraController _controller = ProvideController().controller;

class CartCameraScreen extends StatefulWidget {
  const CartCameraScreen({super.key});

  @override
  State<CartCameraScreen> createState() => _CartCameraScreenState();
}

class _CartCameraScreenState extends State<CartCameraScreen> {
  int _imageCount = 0;
  late Future<List<dynamic>> result;
  List product_name = [];
  List product_price = [];
  List product_category = [];
  List product_amount = [];
  int count = 0;
  var modify = {};
  @override
  void initState() {
    super.initState();

    if (_controller.value.isInitialized) {
      _controller.startImageStream((image) {
        _imageCount++;

        if (_imageCount % 90 == 0) {
          _imageCount = 0;
          Network network = Network();
          result = network.Detection(
            image.planes[0].bytes.toString(),
            image.planes[1].bytes.toString(),
            image.planes[2].bytes.toString(),
          );
          result.then((val) {
            for (var i = 0; i < val.length; i++) {
              if (product_name.contains(val[i]['product_name'])) {
              } else {
                setState(() {
                  product_name.add(val[i]['product_name']);
                  product_price.add(val[i]['product_price']);
                  product_category.add(val[i]['product_category']);
                  modify[i] = 1;
                  product_amount.add(1);
                });
              }
            }
          }).catchError((error) {
            print('error: $error');
          });
          // 안드로이드는 int YUV_420_888
          // 애플은 kCVPixelFormatType_32BGRA = 'BGRA'
          print('names    : $product_name');
          print('prices   : $product_price');
          print('category : $product_category');
          print('amount   : $product_amount');
        }
      });
    } else {
      print("controller is not initialized!");
    }
  }

  @override
  void dispose() {
    _controller.stopImageStream();
    // _controller.dispose(); // 페이지 나갈때 꼭 추가해주기
    super.dispose();
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
    if (!_controller.value.isInitialized) {
      return Container(); // 퍼미션 확인 전 띄우는 대기 화면. 링 돌아가는 대기화면 하면 좋을 듯
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProvideController>(
            create: (_) => ProvideController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "카트",
              style: TextStyle(
                color: Color(0xFF474747),
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
                    builder: (context) => const CartCameraScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new),
              color: const Color(0xFF474747),
            ),
          ),
          body: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1 / _controller.value.aspectRatio,
                child: CameraPreview(
                  _controller,
                ),
              ),
              Container(
                color: const Color(0xFF000000).withOpacity(0.6),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  height: mediaHeight(context, 50 / 100),
                  child: Column(
                    children: [
                      SizedBox(
                        width: mediaWidth(context, 1),
                        height: mediaHeight(context, 5 / 100),
                        child: TextButton(
                          onPressed: () {
                            modalBottonSheet(context);
                          },
                          style: TextButton.styleFrom(
                            iconColor: const Color(0xFF000000).withOpacity(0.5),
                          ),
                          child: Transform.rotate(
                            angle: 1.5708, //각도가 아니라 라디안 값으로 돌림
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFB7B7B7),
                              width: 1,
                            ),
                          ),
                        ),
                        margin: EdgeInsets.only(
                          left: mediaWidth(context, 5 / 100),
                          right: mediaWidth(context, 5 / 100),
                        ),
                        height: mediaHeight(context, 5 / 100),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: mediaWidth(context, 40 / 100),
                              child: Text(
                                "상 품",
                                style: TextStyle(
                                  color:
                                      const Color(0xFF000000).withOpacity(0.7),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: mediaWidth(context, 25 / 100),
                              child: Text(
                                "수 량",
                                style: TextStyle(
                                  color:
                                      const Color(0xFF000000).withOpacity(0.7),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: mediaWidth(context, 25 / 100),
                              child: Text(
                                "가 격",
                                style: TextStyle(
                                  color:
                                      const Color(0xFF000000).withOpacity(0.7),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mediaHeight(context, 26.5 / 100),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var i = 0; i < product_name.length; i++)
                                addedProduct(product_name[i], product_amount[i],
                                    product_price[i])
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(
                          top: 15,
                          left: 25,
                          right: 25,
                        ),
                        height: mediaHeight(context, 13.5 / 100),
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "상품 수량",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  Text(
                                    "예상 결제 금액",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "0",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFed7d5a)
                                              .withOpacity(1),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "개",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: const Color(0xFF000000)
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "0",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF000000)
                                              .withOpacity(1),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "원",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: const Color(0xFF000000)
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                    ],
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
            ],
          ),
        ),
      ),
    );
  }

  Container addedProduct(
      String productName, int productAmount, int productPrice) {
    if (productName.length > 12) {
      productName = "${productName.substring(0, 11)}...";
    }

    return Container(
      // decoration: const BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(
      //       width: 1,
      //       color: Color(0xFFB7B7B7),
      //     ),
      //   ),
      // ),
      margin: EdgeInsets.only(
        left: mediaWidth(context, 5 / 100),
        right: mediaWidth(context, 5 / 100),
      ),
      height: mediaHeight(context, 6 / 100),
      child: Column(
        children: [
          SizedBox(
            height: mediaHeight(context, 6 / 100),
            child: Row(
              children: [
                SizedBox(
                  width: mediaWidth(context, 40 / 100),
                  child: Text(
                    productName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF000000).withOpacity(0.7),
                    ),
                  ),
                ),
                SizedBox(
                  width: mediaWidth(context, 50 / 100),
                  child: Row(
                    children: [
                      SizedBox(
                        width: mediaWidth(context, 25 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              productAmount.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffFF7448),
                              ),
                            ),
                            Text(
                              " 개",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF000000).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: mediaWidth(context, 25 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              NumberFormat(
                                      '###,###,###') // 천만 단위로 넘어가면 오버플로, 백단위로 제한
                                  .format(productPrice * productAmount),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000000),
                              ),
                            ),
                            Text(
                              " 원",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF000000).withOpacity(0.7),
                              ),
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
        ],
      ),
    );
  }

  Container addedProductDetail(String productName, int productAmount,
      int productPrice, int i, bottomState) {
    var b = productAmount;
    if (productName.length > 25) {
      productName = "${productName.substring(0, 24)}...";
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFB7B7B7),
          ),
        ),
      ),
      margin: EdgeInsets.only(
        left: mediaWidth(context, 5 / 100),
        right: mediaWidth(context, 5 / 100),
      ),
      height: mediaHeight(context, 12 / 100),
      child: Column(
        children: [
          SizedBox(
            // color: Colors.blueGrey,
            height: mediaHeight(context, 6 / 100) - 1,
            child: Row(
              children: [
                SizedBox(
                  width: mediaWidth(context, 13 / 100),
                  child: PopupMenuButton(
                    icon: const Icon(Icons.more_horiz),
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 1,
                          child: Text(
                            "삭제",
                            style: TextStyle(
                              color: Color(0xFFEA2424),
                            ),
                          ),
                        )
                      ];
                    },
                    offset: Offset(0, mediaHeight(context, 6 / 100)),
                    onSelected: (value) {
                      print("삭제버튼");
                    },
                  ),
                  // child: IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Icons.more_horiz,
                  //     color: const Color(0xFF000000).withOpacity(0.7),
                  //   ),
                  // ),
                ),
                Container(
                  width: mediaWidth(context, 47 / 100),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    productName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF000000).withOpacity(0.7),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  // color: Colors.amber,
                  width: mediaWidth(context, 30 / 100),
                  height: mediaHeight(context, 6 / 100) - 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000).withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        width: mediaHeight(context, 4 / 100),
                        height: mediaHeight(context, 4 / 100),
                        child: IconButton(
                          onPressed: () {
                            bottomState(() {
                              setState(() {
                                product_amount[i] = product_amount[i] - 1;
                              });
                            });
                          },
                          icon: Icon(
                            Icons.remove,
                            size: mediaHeight(context, 2 / 100),
                            color: const Color(0xFF000000).withOpacity(0.7),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFF000000).withOpacity(0.1),
                          ),
                        ),
                        width: mediaWidth(context, 10 / 100),
                        height: mediaHeight(context, 4 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              productAmount.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffFF7448),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000).withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        width: mediaHeight(context, 4 / 100),
                        height: mediaHeight(context, 4 / 100),
                        child: IconButton(
                          onPressed: () {
                            bottomState(() {
                              setState(() {
                                product_amount[i] = product_amount[i] + 1;
                              });
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            size: mediaHeight(context, 2 / 100),
                            color: const Color(0xFF000000).withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: mediaHeight(context, 6 / 100) - 1,
            child: Row(
              children: [
                Container(
                  width: mediaWidth(context, 65 / 100),
                ),
                SizedBox(
                  width: mediaWidth(context, 25 / 100),
                  child: Row(
                    children: [
                      SizedBox(
                        width: mediaWidth(context, 25 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              NumberFormat(
                                      '###,###,###') // 천만 단위로 넘어가면 오버플로, 백단위로 제한
                                  .format(productPrice * product_amount[i]),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000000),
                              ),
                            ),
                            Text(
                              " 원",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF000000).withOpacity(0.7),
                              ),
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
        ],
      ),
    );
  }

  // https://kimiszero.tistory.com/115
  Future<void> modalBottonSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) {
            return SizedBox(
              height: mediaHeight(context, 0.8),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3,
                            offset: Offset(0, 1)),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    height: mediaHeight(context, 5 / 100),
                    width: mediaWidth(context, 1),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        iconColor: const Color(0xFF000000).withOpacity(0.5),
                      ),
                      child: Transform.rotate(
                        angle: -1.5708, //각도가 아니라 라디안 값으로 돌림
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mediaHeight(context, 55 / 100),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          for (var i = 0; i < product_name.length; i++)
                            addedProductDetail(
                                product_name[i],
                                product_amount[i],
                                product_price[i],
                                i,
                                bottomState),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 25, right: 25),
                    height: mediaHeight(context, 20 / 100),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "상품 수량",
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      const Color(0xFF000000).withOpacity(0.7),
                                ),
                              ),
                              Text(
                                "예상 결제 금액",
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      const Color(0xFF000000).withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFed7d5a)
                                          .withOpacity(1),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "개",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF000000)
                                          .withOpacity(1),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "원",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: mediaHeight(context, 65 / 1000),
                            width: mediaWidth(context, 0.85),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFFed7d5a),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(180)),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "기록 하기",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color(0xFFFFFFFF).withOpacity(1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
