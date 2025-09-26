import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/booking_month_availability.dart';
import 'bookings_repository_provider.dart';

final currentMonthAvailabilityProvider =
    FutureProvider<BookingMonthAvailability>((ref) async {
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.fetchMonthlyAvailability();
});
