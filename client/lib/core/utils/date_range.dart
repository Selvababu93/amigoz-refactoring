class DateRanges {
  static DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime endOfDay(DateTime d) =>
      startOfDay(d).add(const Duration(days: 1));

  static DateTime startOfWeek(DateTime d) =>
      startOfDay(d.subtract(Duration(days: d.weekday - 1)));

  static DateTime startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);

  static DateTime startOfNextMonth(DateTime d) => (d.month == 12)
      ? DateTime(d.year + 1, 1, 1)
      : DateTime(d.year, d.month + 1, 1);
}
