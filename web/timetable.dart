import 'dart:convert';
import 'dart:async';
import 'dart:html';
import 'dart:math';

// The following is a huge mess...

Element flapLine;
String current;
HtmlEscape htmlEscape = new HtmlEscape();

void main() {
  flapLine = querySelector('#flapLine');
  current = flapLine.innerHtml;
  
  List<String> testItems = ['Dart Beginner CodeLab - Room CONF1 - 19:32', 
               '1234567890 AACHEN', 
               'made with dart.'];
  int i = 0;
  querySelector('#btn').onClick.listen((e) {
    setText(testItems[i++ % testItems.length]);
  });
}

void setText(String text) {  
  // Move every character by one until done.
  new Timer.periodic(new Duration(milliseconds: 10), (Timer timer) {
    step(text);
    if (current.trim() == text.trim()) timer.cancel();
  });
}

// printable ascii range: 32..126 (for all special chars we go to space 
// and then insta-transition to the right one)
void step(String target) {
  List<int> newUnits = [];
  for (int i = 0; i < max(current.length, target.length); i++) {
    int currentChar = i < current.length ? current.codeUnitAt(i) : 32;
    int targetChar = i < target.length ? target.codeUnitAt(i) : 32;
    
    if (targetChar < 32 || targetChar > 126) {
      if (currentChar == 32) {
        newUnits.insert(i, targetChar);
        continue;
      } else {
        targetChar = 32;
      }
    }
    
    int direction = targetChar - currentChar;
    if (direction != 0) {
      direction = direction ~/ direction.abs(); // normalize to get step size of 1
    }
    
    newUnits.insert(i, currentChar + direction);
  }
  
  String next = new String.fromCharCodes(newUnits);
  current = next;
  flapLine.innerHtml = htmlEscape.convert(current);
}
