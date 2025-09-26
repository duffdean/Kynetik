enum BookingDayStatus { available, fullyBooked }

class BookingDay {
  BookingDay({
    required this.date,
    required this.status,
    this.availableSlots = 0,
  });

  final DateTime date;
  final BookingDayStatus status;
  final int availableSlots;

  bool get isAvailable =>
      status == BookingDayStatus.available && availableSlots > 0;
}
