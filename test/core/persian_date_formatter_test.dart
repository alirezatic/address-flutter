import 'package:flutter_test/flutter_test.dart';

import 'package:address/core/utils/persian_date_formatter.dart';

void main() {
  test('formats Nowruz as a Persian Jalali date', () {
    final result = PersianDateFormatter.format(DateTime(2024, 3, 20, 12, 5));

    expect(result, '۱ فروردین ۱۴۰۳، ساعت ۱۲:۰۵');
  });

  test('formats a summer date with Persian digits and month name', () {
    final result = PersianDateFormatter.format(DateTime(2026, 7, 20, 9, 7));

    expect(result, '۲۹ تیر ۱۴۰۵، ساعت ۰۹:۰۷');
  });

  test('returns a dash for missing timestamps', () {
    expect(PersianDateFormatter.format(null), '—');
  });
}
