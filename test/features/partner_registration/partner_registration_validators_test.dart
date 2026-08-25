import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/partner_registration/presentation/validation/partner_registration_validators.dart';

void main() {
  group('Jalali birth date validation', () {
    test('normalizes Persian digits and zero padded values', () {
      expect(
        PartnerRegistrationValidators.normalizeJalaliDate('۱۳۷۰/۰۱/۰۱'),
        '1370/1/1',
      );
    });

    test('accepts slash, dash and dot separators', () {
      expect(
        PartnerRegistrationValidators.normalizeJalaliDate('1370-1-1'),
        '1370/1/1',
      );
      expect(
        PartnerRegistrationValidators.normalizeJalaliDate('1370.1.1'),
        '1370/1/1',
      );
    });

    test('rejects invalid month and day ranges', () {
      expect(
        PartnerRegistrationValidators.isValidJalaliDate('1370/13/1'),
        isFalse,
      );
      expect(
        PartnerRegistrationValidators.isValidJalaliDate('1370/7/31'),
        isFalse,
      );
    });
  });
}
