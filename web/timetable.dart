import 'dart:html';
import 'package:polymer/polymer.dart';
import 'flap_line.dart';

FlapLine flapLine;
List<String> testItems = ['Dart Beginner CodeLab - Room CONF1 - 19:32', 
                          '1234567890 AACHEN', 
                          'made with dart.'];

void main() {
  initPolymer();
  flapLine = querySelector('#flapLine');
  
  int i = 0;
  querySelector('#btn').onClick.listen((e) {
    flapLine.animateValue(testItems[i++ % testItems.length]);
  });
}
