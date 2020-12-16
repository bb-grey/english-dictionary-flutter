import 'word_detail_screen.dart';
import '../constants.dart';
import '../services/connectivity_service.dart';
import '../enums/connection_status.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConnectivityService _connectivityService;
  TextEditingController _wordController;
  // bool _canSearch = false;

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();
    _wordController = TextEditingController();
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    _wordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: kDefaultPadding,
            top: 120.0,
            right: kDefaultPadding,
            bottom: kDefaultPadding,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dictionary',
                  style: Theme.of(context).textTheme.headline3,
                ),
                SizedBox(height: kDefaultPadding),
                StreamBuilder<ConnectionStatus>(
                    stream: _connectivityService.connectionController.stream,
                    builder: (context, snapshot) {
                      return TextField(
                        controller: _wordController,
                        onSubmitted: snapshot.data == ConnectionStatus.Offline
                            ? null
                            : (value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WordDetailScreen(value),
                                  ),
                                );
                              },
                        decoration: InputDecoration(
                          hintText: 'Search here',
                          isDense: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[700],
                            size: 24,
                          ),
                          filled: true,
                          border: kInputBorder,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 13.0,
                            horizontal: 10,
                          ),
                          enabledBorder: kInputBorder,
                          focusedBorder: kInputBorder,
                        ),
                        style: TextStyle(fontSize: 20),
                      );
                    }),
                StreamBuilder<ConnectionStatus>(
                  stream: _connectivityService.connectionController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('');
                    } else {
                      return Container(
                        margin: EdgeInsets.only(top: 30.0),
                        child: snapshot.data == ConnectionStatus.Offline
                            ? Text(
                                'Device is not connected to the Internet',
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(''),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
