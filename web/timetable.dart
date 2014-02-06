import 'dart:convert';
import 'dart:html';
import 'package:intl/intl.dart';
import 'package:polymer/polymer.dart';

import '../common/table_entry.dart';
import 'flap_line.dart';


// DISCLAIMER: The following code is a mess. I'm just
// experimenting around...

TimeTable timeTable;
String DATA_SOURCE = 'http://localhost:9999/';

/**
 * An aggregation of several FlapLine elements in order to form a single line
 * of the time table.
 */
class TimeTableLine {
  List<FlapLine> _columns;
  final Element container;
  final int TIME = 0, FLIGHT = 1, DESTINATION = 2, GATE = 3, REMARK = 4;
  
  TimeTableLine() : 
      _columns = [new FlapLine(length: 5), new FlapLine(length: 6), 
                new FlapLine(length: 40), new FlapLine(length: 6), 
                new FlapLine(length: 10)], 
      container = new Element.tag('tr') {
    // Add the cells (wrapped in table columns) into 
    // the table row container 
    _columns.forEach((line) {
      var wrap = new Element.tag('td');
      wrap.children.add(line);
      container.children.add(wrap);
    });    
  }
  
  void setContent(TableEntry e) {
    _columns[TIME].value = new DateFormat.Hm().format(e.dateTime);
    _columns[FLIGHT].value = e.id;
    _columns[DESTINATION].value = e.description;
    _columns[GATE].value = e.location;
    _columns[REMARK].value = e.note;
  }
}

class TimeTable {
  Map<String, TableEntry> _entries = new Map();
  List<TimeTableLine> _lines = new List();
  
  TimeTable(Element el) {
    for(var i = 0; i < 10; i++) {
      _lines.add(new TimeTableLine());
      el.children.add(_lines.last.container);
    }
  }
  
  void addTableEntry(TableEntry e) {
    if (_entries.length >= _lines.length) {
      var sorted = getSortedEntries();
      var i = 0;
      while (_entries.length >= _lines.length) {
        // Remove the oldest entries
        _entries.remove(sorted[i++].id);
      }  
    }
        
    _entries[e.id] = e;
    updateDisplay();
  }
  
  List<TableEntry> getSortedEntries() {
    var entries = _entries.values.toList();
    entries.sort();
    return entries;
  }
  
  void updateDisplay() {
    var entries = getSortedEntries();
    var i = 0;
    entries.forEach((TableEntry) { _lines[i++].setContent(TableEntry); });
  }
}

void main() {
  initPolymer();
  timeTable = new TimeTable(querySelector('#timeTable'));
  fetchEntries();
}

void fetchEntries() {
  // Some local mock entries
  timeTable.addTableEntry(new TableEntry.fromData('DRT102', '2014-02-22 11:00', 'Codelab: Write a Web App', 'CONF1', 'Boarding'));
  timeTable.addTableEntry(new TableEntry.fromData('DRT201', '2014-02-22 09:30', 'Tech Talk: Intro to Dart', 'CONF2', ''));
  timeTable.addTableEntry(new TableEntry.fromData('DRT103', '2014-02-22 12:00', 'Codelab: Using Polymer.dart', 'CONF2', ''));
  timeTable.addTableEntry(new TableEntry.fromData('GDG001', '2014-02-22 09:00', 'Flight School Safety Instructions', 'CONF1', ''));
  timeTable.addTableEntry(new TableEntry.fromData('DRT202', '2014-02-22 13:30', 'Tech Talk: Polymer.dart in action', 'CONF2', ''));
  timeTable.addTableEntry(new TableEntry.fromData('HX1337', '2014-02-22 14:00', 'Dart Hackathon', 'CONF1', ''));
  
  // Fetch entries from server
  HttpRequest.getString(DATA_SOURCE).then((response) {
    var entries = JSON.decode(response);
    entries.forEach((data) {
      TableEntry tableEntry = new TableEntry.fromMap(data);
      print(tableEntry);
      timeTable.addTableEntry(tableEntry);
    });
  });
}
