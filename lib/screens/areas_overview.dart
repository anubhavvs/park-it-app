import 'package:flutter/material.dart';
import 'package:park_it/models/http_exception.dart';
import 'package:provider/provider.dart';

import '../widgets/area_list.dart';
import '../providers/areas.dart';
import '../providers/auth.dart';

class AreasOverviewScreen extends StatefulWidget {
  @override
  State<AreasOverviewScreen> createState() => _AreasOverviewScreenState();
}

class _AreasOverviewScreenState extends State<AreasOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured.'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        Provider.of<Areas>(context).fetchAndSetAreas().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } on HttpException catch (error) {
        var errorMessage = error.toString();
        _showErrorDialog(errorMessage);
      } catch (error) {
        var errorMessage = 'Not able to fetch. Try again later!';
        _showErrorDialog(errorMessage);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 175,
          elevation: 20,
          backgroundColor: Color(0xff351A4D),
          shadowColor: Colors.black,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(0, 37, 260, 5),
            child: Image.asset(
              "images/p1.png",
              width: 50,
              height: 50,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(10, 70, 10, 5),
            child: Text(
              "Find the best \nSpot for Parking",
              style: TextStyle(
                fontSize: 27,
                letterSpacing: 0.1,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 90),
              child: IconButton(
                onPressed: () => {},
                icon: Icon(Icons.person),
                color: Color(0xfff47b4c),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 20, 90),
              child: GestureDetector(
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Icon(
                  Icons.exit_to_app,
                  color: Color(0xfff47b4c),
                ),
              ),
            ),
          ]),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AreaList(),
    );
  }
}
