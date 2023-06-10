import 'package:http/http.dart' as http;
import 'dart:convert';

var host = 'http://203.252.240.71/';

class Network {
  // getJsonData() async {
  //   var url = Uri.parse(this.);
  //   // http.Response response = await http.get(Uri.parse(url));
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     print('응답');
  //   } else {
  //     print('노응답');
  //   }

  //   return json.decode(response.body);
  // }
  Future<String> changePassword(data1, data2) async {
    late String result;
    var url = Uri.parse('$host/changePassword');

    http.Response response = await http.post(
      url,
      body: {
        'userEmail': data1,
        'inputPassword': data2,
      },
    );
    result = await json.decode(response.body)['result'];
    return result;
  }

  Future<String> Register(data1, data2, data3) async {
    var url = Uri.parse('$host/register');
    late String result;
    // http.Response response = await http.get(Uri.parse(url));

    http.Response response = await http.post(
      url,
      body: {
        'userEmail': data1,
        'userPassword': data2,
        'userNickname': data3,
      },
    );

    result = await json.decode(response.body)['result'];
    return result;
  }

  Future<String> Login(data1, data2) async {
    var url = Uri.parse('$host/login');
    String result = '';

    http.Response response = await http.post(
      url,
      body: {
        'userEmail': data1,
        'userPassword': data2,
      },
    );
    result = json.decode(utf8.decode(response.bodyBytes))['result'];
    return result;
  }

  Future<String> changeEmail(data1, data2) async {
    var url = Uri.parse('$host/changeEmail');
    String result = '';
    http.Response response = await http.post(
      url,
      body: {
        'changeEmail': data1,
        'email': data2,
      },
    );

    result = json.decode(response.body)['result'];
    return result;
  }

  Future<String> changeNickname(data1, data2) async {
    var url = Uri.parse('$host/changeNick');
    String result = '';
    http.Response response = await http.post(
      url,
      body: {
        'changeNick': data1,
        'email': data2,
      },
    );

    result = json.decode(utf8.decode(response.bodyBytes))['result'];
    return result;
  }

  Future<List> Detection(data1, data2, data3) async {
    var url = Uri.parse('$host/detection');
    List result;
    http.Response response = await http.post(
      url,
      body: {
        'Y': data1,
        'U': data2,
        'V': data3,
      },
    );

    result = json.decode(utf8.decode(response.bodyBytes))['result'];

    return result;
  }

  Future<List> checkShopping(email, date) async {
    List result = [];
    var url = Uri.parse('$host/calendarLoad');
    http.Response response = await http.post(
      url,
      body: {
        'user_email': 'a@a.a',
        'date': date,
      },
    );
    result = json.decode(utf8.decode(response.bodyBytes))['result'];

    return result;
  }

  Future<void> SendShoppingData(
      email, names, prices, amount, totalPrice) async {
    var url = Uri.parse('$host/cartmakelist');

    Map<String, dynamic> body = {
      'email': email,
      'shopping': [names, prices, amount],
      'shopping_list': totalPrice.toString()
    };

    http.Response response = await http.post(url,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    print(json.decode(response.body)['result']);
  }

  Future<void> Calendar(email) async {
    var url = Uri.parse('$host/calendar');
    http.Response response = await http.post(
      url,
      body: {
        'email': email,
      },
    );
    print(json.decode(response.body));
  }

  Future<void> calendarDelete(idenNum) async {
    var url = Uri.parse('$host/calendarDelete');
    http.Response response = await http.post(
      url,
      body: {'iden_num': idenNum.toString()},
    );
  }

  Future<List> calendarLoadDetail(idenNum) async {
    var url = Uri.parse('$host/calendarLoadDetail');
    http.Response response = await http.post(
      url,
      body: {'iden_num': idenNum.toString()},
    );
    var result = json.decode(response.body);
    result = result['result'];
    return result;
  }
}
