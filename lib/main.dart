import 'dart:ffi';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Curry(),
  ));
}

class Curry extends StatefulWidget {
  @override
  _CurryState createState() => _CurryState();
}

class _CurryState extends State<Curry> {
  final fromController = TextEditingController();
  List<dynamic> curr = [];
  String fromcurr = "USD";
  String tocurr = "GBP";
  String result = "";

  @override
  void initState() {
    super.initState();
    loadcurr();
  }

  Future<String> loadcurr() async {
    var uri = Uri.parse(
        "https://v6.exchangerate-api.com/v6/7385701f0010ab74aa182fb6/latest/USD");
    var response =
        await http.get((uri), headers: {"Accept": "application/json"});
    var responsebody = json.decode(response.body);
    Map curmap = responsebody['conversion_rates'];
    //print(curmap.keys);
    curr = curmap.keys.toList();
    setState(() {});
    //print(curr);
    return "Success";
  }

  Future<String> conv() async {
    var uri = Uri.parse(
        "https://v6.exchangerate-api.com/v6/7385701f0010ab74aa182fb6/pair/$fromcurr/$tocurr");
    var response =
        await http.get((uri), headers: {"Accept": "application/json"});
    var responsebody = json.decode(response.body);
    setState(() {
      result = (double.parse(fromController.text) *
              (responsebody["conversion_rate"]))
          .toString() as String;
    });
    print(result);
    return "Yay";
  }

  _onFromChanged(String value) {
    setState(() {
      fromcurr = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      tocurr = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //extendBodyBehindAppBar: true,
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Color(0xCCFFEAA5),
        title: Center(
            child: Text(
          'Currency Convertor',
          style: TextStyle(
            fontFamily: 'MS',
            fontSize: 25,
            letterSpacing: 2,
            color: Colors.black,
          ),
        )),
      ),
      body: curr == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: Color(0xffc7efcf),
                elevation: 4.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: TextField(
                        controller: fromController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Currency Value',
                          labelStyle: TextStyle(
                            fontFamily: 'MS',
                            fontSize: 20,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      trailing: _buildDropDownButton(fromcurr),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    IconButton(
                        onPressed: conv,
                        iconSize: 45,
                        icon: Icon(Icons.arrow_downward_rounded)),
                    SizedBox(
                      height: 100,
                    ),
                    ListTile(
                      title: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 45),
                          child: Chip(
                            backgroundColor: Color(0XFFfe5f55),
                            label: result != null
                                ? Text(
                                    result,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                    ),
                                  )
                                : Text('data'),
                          )),
                      trailing: _buildDropDownButton(tocurr),
                      // _buildDropDownButton(tocurr),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDropDownButton(String currencychoice) {
    return DropdownButton(
      value: currencychoice,
      items: curr.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'MS',
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        );
      }).toList(),
      onChanged: (dynamic value) {
        if (currencychoice == fromcurr) {
          _onFromChanged(value);
        } else {
          _onToChanged(value);
        }
      },
    );
  }
}
