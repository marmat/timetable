import 'dart:convert';
import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:polymer/polymer.dart';
 
HtmlEscape htmlEscape = new HtmlEscape();
 
@CustomTag('flap-line')
class FlapLine extends PolymerElement {
  @published String value = '';
  @published int length = null; // null indicates dynamic width
  
  SpanElement _line;
  Timer _activeTimer;
  String _current = '';
  
  FlapLine.created() : super.created();
  
  enteredView() {
    super.enteredView();
    _line = $['line'];
    animateValue(value);
  }
  
  attributeChanged(String name, String oldValue, String newValue) {
    super.attributeChanged(name, oldValue, newValue);
    animateValue(value);
  }
  
  /**
   * Pads [value] to the given [width] using whitespaces, or shortens
   * it if [value] is longer than [width]. Does nothing if [width] is null.
   */
  String pad(String value, int length) {
    if (length == null) return value;
    
    if (value.length > length) {
      return value.substring(0, length);
    } else {
      return value + new List.filled(length - value.length, ' ').join();
    }
  }
  
  /**
   * Changes the element's visible value to [newValue] in a stepwise
   * flap display animation.
   */
  void animateValue(String newValue) {
    if (_activeTimer != null) {
      _activeTimer.cancel();
    }
 
    _activeTimer = new Timer.periodic(new Duration(milliseconds: 10), (Timer t) {
      _animateStep(newValue);
      if (_current.trim() == newValue.trim()) t.cancel();
    });
  }
  
  /**
   * Performs a single step of the flap display animation.
   */
  void _animateStep(String target) {
    List<int> newUnits = [];
    for (int i = 0; i < max(_current.length, target.length); i++) {
      int currentChar = i < _current.length ? _current.codeUnitAt(i) : 32;
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
    _current = next;
    _line.innerHtml = htmlEscape.convert(pad(_current, length));
  }
}