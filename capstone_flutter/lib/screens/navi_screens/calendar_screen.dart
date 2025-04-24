import 'package:capstone_project/tools/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<NeatCleanCalendarEvent> _todaysEvents = [
    NeatCleanCalendarEvent(
      'Event A',
      startTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0),
      endTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0),
      description: 'A special event',
      color: Colors.blue[700],
    ),
  ];

  final List<NeatCleanCalendarEvent> _eventList = [
    NeatCleanCalendarEvent('MultiDay Event A',
        description: 'test desc',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 10, 0),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 2, 12, 0),
        color: Colors.orange,
        isMultiDay: true),
  ];

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
  }

  void check(date) {
    Network network = Network();
    print(date);
    network.checkShopping('a@a.a', date);
  }

  //미디어쿼리 높이 * 비율
  double mediaHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }

  //미디어쿼리 너비 * 비율
  double mediaWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDate = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "쇼핑 기록",
            style: TextStyle(
              color: Color(0xFF474747),
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
          backgroundColor: const Color(0xFFFFFFFF),
          shadowColor: Colors.grey.withOpacity(0.0),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarScreen(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: const Color(0xFF474747),
          ),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: mediaHeight(context, 35 / 100),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                Calendar(
                  onDateSelected: (value) {
                    // check(DateTime(DateTime.now().year, DateTime.now().month,
                    //         DateTime.now().day)
                    //     .toString());
                    selectedYear = value.year;
                    selectedMonth = value.month;
                    selectedDate = value.day;
                    setState(() {});
                  },
                  datePickerType: DatePickerType
                      .hidden, // 상단 달력 아이콘, date, year, hidden 선택 가능, 일, 년 선택
                  eventListBuilder: (context, events) {
                    return Container();
                  }, //이벤트 리스트 부분

                  hideArrows: false, // 상단 단 전환 화살표

                  hideTodayIcon:
                      true, // todayButtonText: 'Heute', // 상단 ?월???? 제목

                  // bottomBarArrowColor: Colors.amber,
                  startOnMonday: false,
                  weekDays: const ['일', '월', '화', '수', '목', '금', '토'],
                  eventsList: _eventList,
                  // eventDoneColor: Colors.green,
                  selectedColor: const Color(0xFFE87D5C),
                  selectedTodayColor: const Color(0xFFE87D5C),
                  todayColor: Colors.blue,
                  eventColor: const Color(0xFFE87D5C),
                  locale: 'ko',
                  allDayEventText: '',
                  multiDayEndText: 'Ende',
                  isExpanded: true, // true면 달 뷰, false면 주 뷰
                  expandableDateFormat: 'yyyy년 MMMM dd일 EEEE', // 중간바 글자 포멧
                  dayOfWeekStyle: const TextStyle(
                      color: Color(0xFF474747),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: mediaHeight(context, 2 / 100),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: mediaHeight(context, 4 / 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$selectedMonth",
                            style: TextStyle(
                              color: const Color(0xFFE87D5C),
                              fontSize: mediaWidth(context, 4 / 100),
                            ),
                          ),
                          Text(
                            "월 ",
                            style: TextStyle(
                              color: const Color(0xFF474747),
                              fontSize: mediaWidth(context, 4 / 100),
                            ),
                          ),
                          Text(
                            "$selectedDate",
                            style: TextStyle(
                              color: const Color(0xFFE87D5C),
                              fontSize: mediaWidth(context, 4 / 100),
                            ),
                          ),
                          Text(
                            "일 쇼핑 내역 입니다.",
                            style: TextStyle(
                              color: const Color(0xFF474747),
                              fontSize: mediaWidth(context, 4 / 100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    newMethod(context),
                    newMethod(context),
                    newMethod(context),
                    newMethod(context),
                    newMethod(context),
                    newMethod(context),
                    Container(
                      height: mediaHeight(context, 2 / 100),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container newMethod(BuildContext context) {
    return Container(
      height: mediaHeight(context, 10 / 100),
      width: mediaWidth(context, 1),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      margin: EdgeInsets.only(
        left: mediaWidth(context, 5 / 100),
        right: mediaWidth(context, 5 / 100),
        top: mediaHeight(context, 2 / 100),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          backgroundColor: const Color(0xFFFFFFFF),
        ),
        onPressed: () {
          modalBottonSheet(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: mediaWidth(context, 10 / 100),
              child: PopupMenuButton(
                icon: const Icon(
                  Icons.more_horiz,
                  color: Color(0xFF474747),
                ),
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
            ),
            SizedBox(
              width: mediaWidth(context, 70 / 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mediaHeight(context, 3 / 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "오상품) 이름어쩌구저",
                          style: TextStyle(
                            color: const Color(0xFF474747),
                            fontSize: mediaWidth(context, 4 / 100),
                          ),
                        ),
                        Text(
                          " 외 ",
                          style: TextStyle(
                            color: const Color(0xFF474747),
                            fontSize: mediaWidth(context, 4 / 100),
                          ),
                        ),
                        Text(
                          "5",
                          style: TextStyle(
                            color: const Color(0xFFE87D5C),
                            fontSize: mediaWidth(context, 4 / 100),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " 개 상품 ",
                          style: TextStyle(
                            color: const Color(0xFF474747),
                            fontSize: mediaWidth(context, 4 / 100),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mediaHeight(context, 3 / 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "총 금액 ",
                          style: TextStyle(
                            color: const Color(0xFF474747),
                            fontSize: mediaWidth(context, 4 / 100),
                          ),
                        ),
                        Text(
                          NumberFormat(
                                  '###,###,###') // 천만 단위로 넘어가면 오버플로, 백단위로 제한
                              .format(100000),
                          style: TextStyle(
                            color: const Color(0xFF000000),
                            fontSize: mediaWidth(context, 4 / 100),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " 원",
                          style: TextStyle(
                            color: const Color(0xFF474747),
                            fontSize: mediaWidth(context, 4 / 100),
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
    );
  }

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
              height: mediaHeight(context, 73.5 / 100),
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
                          // for (var i = 0; i < product_name.length; i++)
                          //   addedProductDetail(
                          //       product_name[i],
                          //       product_amount[i],
                          //       product_price[i],
                          //       i,
                          //       bottomState),
                          addedProductDetail("productName", 1, 12313, 1, 1),
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
                                "결제 금액",
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
                          alignment: Alignment.bottomCenter,
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
                Container(
                  width: mediaWidth(context, 70 / 100),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    productName,
                    style: TextStyle(
                      color: const Color(0xFF000000),
                      fontSize: mediaWidth(context, 4 / 100),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  width: mediaWidth(context, 20 / 100),
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        productAmount.toString(),
                        style: TextStyle(
                          color: const Color(0xFFE87D5C),
                          fontSize: mediaWidth(context, 4 / 100),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " 개",
                        style: TextStyle(
                          color: const Color(0xFF000000),
                          fontSize: mediaWidth(context, 4 / 100),
                          fontWeight: FontWeight.normal,
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
                            const Text(
                              "dadadsa",
                              // NumberFormat(
                              //         '###,###,###') // 천만 단위로 넘어가면 오버플로, 백단위로 제한
                              //     .format(productPrice * product_amount[i]),
                              style: TextStyle(
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
}
