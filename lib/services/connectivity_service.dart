import 'dart:async';
import 'package:connectivity/connectivity.dart';
import '../enums/connection_status.dart';

class ConnectivityService {
  StreamController<ConnectionStatus> connectionController =
      StreamController<ConnectionStatus>.broadcast();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      ConnectionStatus connectionStatus = _getConnectionStatus(result);
      connectionController.sink.add(connectionStatus);
    });
  }

  ConnectionStatus _getConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return ConnectionStatus.Connected;
    }
    return ConnectionStatus.Offline;
  }

  void dispose() {
    connectionController.close();
  }
}
