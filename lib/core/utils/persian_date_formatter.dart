abstract final class PersianDateFormatter {
  static const List<String> _monthNames = <String>[
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  static const String _latinDigits = '0123456789';
  static const String _persianDigits = '۰۱۲۳۴۵۶۷۸۹';

  static String format(DateTime? value) {
    if (value == null) {
      return '—';
    }

    final local = value.toLocal();
    final jalali = _gregorianToJalali(local.year, local.month, local.day);
    final day = _toPersianDigits(jalali.day.toString());
    final year = _toPersianDigits(jalali.year.toString());
    final hour = _toPersianDigits(local.hour.toString().padLeft(2, '0'));
    final minute = _toPersianDigits(local.minute.toString().padLeft(2, '0'));

    return '$day ${_monthNames[jalali.month - 1]} $year، ساعت $hour:$minute';
  }

  static String _toPersianDigits(String value) {
    final buffer = StringBuffer();

    for (final codeUnit in value.codeUnits) {
      final character = String.fromCharCode(codeUnit);
      final index = _latinDigits.indexOf(character);
      buffer.write(index < 0 ? character : _persianDigits[index]);
    }

    return buffer.toString();
  }

  static _JalaliDate _gregorianToJalali(
    int gregorianYear,
    int gregorianMonth,
    int gregorianDay,
  ) {
    const gregorianMonthDays = <int>[
      31,
      28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];
    const jalaliMonthDays = <int>[
      31,
      31,
      31,
      31,
      31,
      31,
      30,
      30,
      30,
      30,
      30,
      29,
    ];

    var year = gregorianYear - 1600;
    var month = gregorianMonth - 1;
    var day = gregorianDay - 1;

    var gregorianDayNumber =
        365 * year + (year + 3) ~/ 4 - (year + 99) ~/ 100 + (year + 399) ~/ 400;

    for (var index = 0; index < month; index++) {
      gregorianDayNumber += gregorianMonthDays[index];
    }

    final leapYear = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

    if (month > 1 && leapYear) {
      gregorianDayNumber += 1;
    }

    gregorianDayNumber += day;

    var jalaliDayNumber = gregorianDayNumber - 79;
    final jalaliCycles = jalaliDayNumber ~/ 12053;
    jalaliDayNumber %= 12053;

    var jalaliYear = 979 + 33 * jalaliCycles;
    jalaliYear += 4 * (jalaliDayNumber ~/ 1461);
    jalaliDayNumber %= 1461;

    if (jalaliDayNumber >= 366) {
      jalaliYear += (jalaliDayNumber - 1) ~/ 365;
      jalaliDayNumber = (jalaliDayNumber - 1) % 365;
    }

    var jalaliMonth = 0;

    while (jalaliMonth < 11 &&
        jalaliDayNumber >= jalaliMonthDays[jalaliMonth]) {
      jalaliDayNumber -= jalaliMonthDays[jalaliMonth];
      jalaliMonth += 1;
    }

    return _JalaliDate(
      year: jalaliYear,
      month: jalaliMonth + 1,
      day: jalaliDayNumber + 1,
    );
  }
}

class _JalaliDate {
  const _JalaliDate({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;
}
