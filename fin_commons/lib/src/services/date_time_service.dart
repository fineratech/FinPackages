import 'package:intl/intl.dart';

class DateTimeService {
  static String mmddyyyyFormat(String date) {
    var dateFormat = DateFormat("MM-dd-yyyy");
    DateTime? parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) {
      return "-1";
    }
    return dateFormat.format(parsedDate);
  }
}
