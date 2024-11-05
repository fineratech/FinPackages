import 'package:intl/intl.dart';

class DateTimeService {
  static String mmddyyyyFormat(String date) {
    var dateFormat = DateFormat("MM/dd/yyyy");
    DateTime parsedDate = DateTime.parse(date);
    return dateFormat.format(parsedDate);
  }
}
