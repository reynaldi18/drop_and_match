import 'package:drag_drop/database/queries/time_query.dart';
import 'package:drag_drop/models/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'database/db_helper.dart';
import 'main.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final DbHelper _helper = new DbHelper();

  List<Time> result = [];
  int index = 0;
  int no = 0;

  @override
  void initState() {
    super.initState();
    _helper.getData(TimeQuery.TABLE_NAME).then((value) {
      value.forEach((element) {
        Time country = Time.fromJson(element);
        print(country.toJson());
      });
      List<Time> data = (value).map((e) => Time.fromJson(e)).toList();
      print('DATA: $data');
      setState(() {
        result = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peringkat'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: result.map((item) {
                  index++;
                  no++;
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(no.toString()),
                        Text('${item.time.toString()} Detik'),
                        no == 1
                            ? SvgPicture.asset(
                                'assets/images/star.svg',
                                width: 18,
                              )
                            : no == 2
                                ? SvgPicture.asset(
                                    'assets/images/star.svg',
                                    color: Color(0xFFC0C0C0),
                                    width: 18,
                                  )
                                : no == 3
                                    ? SvgPicture.asset(
                                        'assets/images/star.svg',
                                        color: Color(0xFFA52A2A),
                                        width: 18,
                                      )
                                    : Container(),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(05),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                ),
                child: Text('Play Again'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
