import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import '../domain/booking_day.dart';
import 'providers/current_month_availability_provider.dart';
import 'widgets/booking_calendar.dart';

class BookingsPage extends ConsumerStatefulWidget {
  const BookingsPage({super.key});

  @override
  ConsumerState<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends ConsumerState<BookingsPage> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final availabilityAsync = ref.watch(currentMonthAvailabilityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        leading: IconButton(
          icon: const Icon(LineIcons.angleLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: availabilityAsync.when(
        data: (availability) {
          BookingDay? selectedDay;
          if (_selectedDate != null) {
            selectedDay = _findDayByDate(availability.days, _selectedDate!);
          }

          selectedDay ??= _findDefaultDay(availability.days);

          if (selectedDay != null &&
              (_selectedDate == null ||
                  !_isSameDate(selectedDay.date, _selectedDate!))) {
            final targetDate = selectedDay.date;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() => _selectedDate = targetDate);
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookingCalendar(
                  availability: availability,
                  selectedDate: _selectedDate,
                  onDaySelected: (day) {
                    setState(() => _selectedDate = day.date);
                  },
                ),
                const SizedBox(height: 24),
                const _CalendarLegend(),
                const SizedBox(height: 24),
                _SelectedDayPanel(day: selectedDay),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Something went wrong loading your availability. Please try again later.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  BookingDay? _findDayByDate(List<BookingDay> days, DateTime date) {
    for (final day in days) {
      if (_isSameDate(day.date, date)) {
        return day;
      }
    }
    return null;
  }

  BookingDay? _findDefaultDay(List<BookingDay> days) {
    if (days.isEmpty) {
      return null;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final day in days) {
      final isPast = day.date.isBefore(today);
      if (day.isAvailable && !isPast) {
        return day;
      }
    }

    for (final day in days) {
      if (day.status != BookingDayStatus.fullyBooked) {
        return day;
      }
    }

    return days.first;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final disabledColor =
        Theme.of(context).disabledColor.withValues(alpha: 0.3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _LegendItem(
          color: colorScheme.primary,
          label: 'Selected day',
        ),
        _LegendItem(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.6),
          label: 'Available',
        ),
        _LegendItem(
          color: colorScheme.errorContainer.withValues(alpha: 0.7),
          label: 'Fully booked',
        ),
        _LegendItem(
          color: disabledColor,
          label: 'Past day',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SelectedDayPanel extends StatelessWidget {
  const _SelectedDayPanel({required this.day});

  final BookingDay? day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (day == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No availability found for this month.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    final bookingDay = day!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isPast = bookingDay.date.isBefore(today);
    final isAvailable = bookingDay.isAvailable && !isPast;

    final formattedDate = _formatLongDate(bookingDay.date);
    // final statusText = bookingDay.status == BookingDayStatus.fullyBooked
    //     ? 'Fully booked'
    //     : isPast
    //         ? 'This day has passed'
    //         : '${bookingDay.availableSlots} slots available';

    final statusText = '';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isAvailable
                      ? LineIcons.calendarCheck
                      : LineIcons.exclamationCircle,
                  color: isAvailable
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isAvailable
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking flow coming soon.'),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(LineIcons.calendarPlus),
              label: const Text('Book this day'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLongDate(DateTime date) {
    const monthNames = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    const weekDays = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final dayName = weekDays[date.weekday - 1];
    final month = monthNames[date.month - 1];
    return '$dayName, ${date.day} $month ${date.year}';
  }
}
