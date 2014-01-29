import 'dart:html';
import 'package:polymer/polymer.dart';
import 'flap_line.dart';

// DISCLAIMER: The following code is a mess. I'm just
// experimenting around...

TimeTable timeTable;

/**
 * The data structure representing a single 'flight'.
 */
class Entry {
  String id;
  DateTime time;
  String description;
  String location;
  String note;
  
  Entry(this.id, this.time, this.description, this.location, this.note);
}

/**
 * An aggregation of several FlapLine elements in order to form a single line
 * of the time table.
 */
class TimeTableLine {
  FlapLine time, flight, destination, gate, remark;
  Element container;
  
  TimeTableLine() {
    time = new Element.tag('flap-line');
    time.length = 5;
    flight = new Element.tag('flap-line');
    flight.length = 6;
    destination = new Element.tag('flap-line');
    destination.length = 40;
    gate = new Element.tag('flap-line');
    gate.length = 6;
    remark = new Element.tag('flap-line');
    remark.length = 10;
    container = new Element.tag('tr');
    [time, flight, destination, gate, remark].forEach((el) { 
      var wrap = new Element.tag('td');
      wrap.children.add(el);
      container.children.add(wrap);
    });
    
  }
  
  void setContent(Entry e) {
    time.value = e.time.hour.toString() + ':' + e.time.minute.toString();
    flight.value = e.id;
    destination.value = e.description;
    gate.value = e.location;
    remark.value = e.note;
  }
}

class TimeTable {
  Map<String, Entry> entries_ = new Map();
  List<TimeTableLine> lines_ = new List();
  
  TimeTable(Element el) {
    for(var i = 0; i < 10; i++) {
      lines_.add(new TimeTableLine());
      el.children.add(lines_.last.container);
    }
  }
  
  void addEntry(Entry e) {
    if (entries_.length >= lines_.length) {
      var sorted = getSortedEntries();
      var i = 0;
      while (entries_.length >= lines_.length) {
        // Remove the oldest entries
        entries_.remove(sorted[i++].id);
      }  
    }
        
    entries_[e.id] = e;
    updateDisplay();
  }
  
  List<Entry> getSortedEntries() {
    var entries = entries_.values.toList();
    entries.sort((e1, e2) => e1.time.millisecondsSinceEpoch - e2.time.millisecondsSinceEpoch);
    return entries;
  }
  
  void updateDisplay() {
    var entries = getSortedEntries();
    var i = 0;
    entries.forEach((entry) { lines_[i++].setContent(entry); });
  }
}

void main() {
  initPolymer();
  timeTable = new TimeTable(querySelector('#timeTable'));
  timeTable.addEntry(new Entry('DRT101', new DateTime.utc(2014, 2, 22, 10, 15), 'Codelab: Intro to Dart', 'CONF1', 'Boarding'));
  timeTable.addEntry(new Entry('DRT203', new DateTime.utc(2014, 2, 22, 11, 15), 'Polymer.dart in action', 'CONF2', ''));
}
