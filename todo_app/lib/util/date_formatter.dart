import 'package:intl/intl.dart';

String dateFormatted() {
  var now = DateTime.now();

  var dateFormat = DateFormat('EEE, MMM d, ''yy');

  String formattedDate = dateFormat.format(now);

  return formattedDate;
}