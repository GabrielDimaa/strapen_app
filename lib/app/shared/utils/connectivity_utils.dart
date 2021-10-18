import 'dart:io';

abstract class ConnectivityUtils {
  static Future<void> hasInternet() async {
    try {
      List<InternetAddress>? result;

      Future.delayed(Duration(seconds: 10), () {
        if (result == null) throw SocketException("Error");
      });

      result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
        return;

      throw SocketException("Error");
    } on SocketException catch(_) {
      throw Exception("Sem conexão com a internet!");
    }
  }
}