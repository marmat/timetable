library table_entry;

import "dart:convert";

// The data structure representing a single 'flight'.
class TableEntry implements Comparable<TableEntry> {
  String id;
  String time; 
  DateTime get dateTime => DateTime.parse(time);
  String description;
  String location;
  String note;
  
  TableEntry();
  TableEntry.fromData(this.id, this.time, this.description, this.location, this.note);
  TableEntry.fromMap(Map map) : 
    id = map['id'], time = map['time'], description = map['description'], 
    location = map['location'], note = map['note'];
  TableEntry.fromJsonString(string) : this.fromMap(JSON.decode(string));

  int compareTo(TableEntry other) {
    return this.dateTime.millisecondsSinceEpoch - other.dateTime.millisecondsSinceEpoch;
  }
  
  String toString() {
    return '{"id": "$id", "time": "$time", "description": "$description", "location": "$location", "note": "$note"}';
  }
}