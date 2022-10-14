
import 'dart:core';

List<String> months = [
  "",
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sept",
  "Oct",
  "Nov",
  "Dec"
];

String getVerbalPresentation(DateTime sel) {
  return "${sel.day} ${months[sel.month]}, ${(sel.hour > 12)? sel.hour - 12: sel.hour}:${sel.minute} ${(sel.hour > 12)? "PM": "AM"}";
}
