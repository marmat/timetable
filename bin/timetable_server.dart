import 'dart:io' show HttpRequest, HttpServer, Platform;
import 'dart:async' show runZoned;

// A simple server that keeps the current time table entirely 
// in memory (no persistence, if the server crashes, it's gone!)
// as a very simple experiment of using Dart on the server side.

String MOCK_RESPONSE = '[{"id": "DRT101", "time": "2014-02-22 10:15:00", "description": "Testing the Dart Server", "location": "CLOUD", "note": ""}]';

void main() {
  // If deployed on Heroku, the assigned Port will be given as an env variable
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);

  runZoned(() {
    HttpServer.bind('0.0.0.0', port).then((server) {
      server.listen((HttpRequest request) {
        request.response..headers.add('Access-Control-Allow-Origin', '*')
                        ..write(MOCK_RESPONSE)
                        ..close();
        
      });
    });
  },
  onError: (e, stackTrace) => print('Oh noes! $e $stackTrace'));
}
