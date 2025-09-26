import 'booking_day.dart';

class BookingMonthAvailability {
  BookingMonthAvailability({
    required this.month,
    required this.days,
  });

  final DateTime month;
  final List<BookingDay> days;

  DateTime get startOfMonth => DateTime(month.year, month.month);
}
