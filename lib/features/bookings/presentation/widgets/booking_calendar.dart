import 'package:flutter/material.dart';
import '../../domain/booking_day.dart';
import '../../domain/booking_month_availability.dart';

typedef BookingDaySelected = void Function(BookingDay day);

class BookingCalendar extends StatelessWidget {
  const BookingCalendar({
    super.key,
    required this.availability,
    required this.onDaySelected,
    this.selectedDate,
  });

  final BookingMonthAvailability availability;
  final BookingDaySelected onDaySelected;
  final DateTime? selectedDate;

  static const _monthNames = <String>[
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

  static const _weekdays = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final firstDay = availability.startOfMonth;
    final monthLabel = '${_monthNames[firstDay.month - 1]} ${firstDay.year}';

    final calendarSlots = _buildCalendarSlots(availability);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          monthLabel,
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _weekdays
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.9,
          ),
          itemCount: calendarSlots.length,
          itemBuilder: (context, index) {
            final day = calendarSlots[index];
            if (day == null) {
              return const SizedBox.shrink();
            }

            final isSelected =
                selectedDate != null && _isSameDate(day.date, selectedDate!);
            final isToday = _isSameDate(day.date, now);
            final isPast =
                day.date.isBefore(DateTime(now.year, now.month, now.day));
            final isSelectable = day.isAvailable && !isPast;

            final colors = _resolverColorScheme(theme, day, isSelected, isPast);

            return GestureDetector(
              onTap: isSelectable ? () => onDaySelected(day) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : isToday
                            ? theme.colorScheme.primary.withValues(alpha: 0.6)
                            : colors.border,
                    width: isSelected || isToday ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${day.date.day}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.label,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<BookingDay?> _buildCalendarSlots(BookingMonthAvailability availability) {
    final days = availability.days;
    if (days.isEmpty) {
      return const [];
    }

    final firstDay = days.first.date;
    final leadingBlanks = (firstDay.weekday - DateTime.monday) % 7;

    final slots = <BookingDay?>[
      ...List<BookingDay?>.filled(leadingBlanks, null),
      ...days,
    ];

    while (slots.length % 7 != 0) {
      slots.add(null);
    }

    return slots;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  _CalendarCellColors _resolverColorScheme(
    ThemeData theme,
    BookingDay day,
    bool isSelected,
    bool isPast,
  ) {
    final colorScheme = theme.colorScheme;

    if (isSelected) {
      return _CalendarCellColors(
        background: colorScheme.primary,
        border: colorScheme.primary,
        label: colorScheme.onPrimary,
        secondaryLabel: colorScheme.onPrimary.withValues(alpha: 0.9),
      );
    }

    if (day.status == BookingDayStatus.fullyBooked) {
      return _CalendarCellColors(
        background: colorScheme.errorContainer.withValues(alpha: 0.7),
        border: colorScheme.error.withValues(alpha: 0.3),
        label: colorScheme.error,
        secondaryLabel: colorScheme.error,
      );
    }

    if (isPast) {
      final disabled = theme.disabledColor.withValues(alpha: 0.3);
      return _CalendarCellColors(
        background: disabled,
        border: Colors.transparent,
        label: theme.disabledColor,
        secondaryLabel: theme.disabledColor.withValues(alpha: 0.8),
      );
    }

    return _CalendarCellColors(
      background: colorScheme.secondaryContainer.withValues(alpha: 0.6),
      border: Colors.transparent,
      label: colorScheme.onSecondaryContainer,
      secondaryLabel: colorScheme.onSecondaryContainer.withValues(alpha: 0.9),
    );
  }
}

class _CalendarCellColors {
  const _CalendarCellColors({
    required this.background,
    required this.border,
    required this.label,
    required this.secondaryLabel,
  });

  final Color background;
  final Color border;
  final Color label;
  final Color secondaryLabel;
}
