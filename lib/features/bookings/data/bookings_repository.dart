import 'dart:math';
import '../domain/booking_day.dart';
import '../domain/booking_month_availability.dart';

class BookingsRepository {
  Future<BookingMonthAvailability> fetchMonthlyAvailability({
    DateTime? reference,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    final target = DateTime(
      reference?.year ?? now.year,
      reference?.month ?? now.month,
    );

    final random = Random(target.year * 100 + target.month);
    final daysInMonth = _daysInMonth(target);

    final blockedCount = (daysInMonth * 0.2).round().clamp(1, daysInMonth);
    final blockedDays = <int>{};
    while (blockedDays.length < blockedCount) {
      blockedDays.add(random.nextInt(daysInMonth) + 1);
    }

    final days = List<BookingDay>.generate(daysInMonth, (index) {
      final dayNumber = index + 1;
      final date = DateTime(target.year, target.month, dayNumber);

      if (blockedDays.contains(dayNumber)) {
        return BookingDay(
          date: date,
          status: BookingDayStatus.fullyBooked,
          availableSlots: 0,
        );
      }

      final availableSlots = random.nextInt(3) + 1; // 1-3 slots
      return BookingDay(
        date: date,
        status: BookingDayStatus.available,
        availableSlots: availableSlots,
      );
    });

    return BookingMonthAvailability(
      month: target,
      days: days,
    );
  }

  int _daysInMonth(DateTime date) {
    final beginningNextMonth = (date.month == 12)
        ? DateTime(date.year + 1, 1, 1)
        : DateTime(date.year, date.month + 1, 1);
    return beginningNextMonth.subtract(const Duration(days: 1)).day;
  }
}
