import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/partner_registration/data/models/partner_application.dart';
import 'package:address/features/partner_registration/data/models/partner_reusable_identity.dart';

void main() {
  test('reusable identity parses complete individual identity', () {
    final identity = PartnerReusableIdentity.fromJson(<String, Object?>{
      'verificationId': '11111111-1111-4111-8111-111111111111',
      'applicantType': 'individual',
      'fullName': 'کاربر آزمایشی',
      'companyName': '',
      'representativeName': '',
      'nationalId': '0012345678',
      'companyNationalId': '',
      'representativeNationalId': '',
      'mobile': '09121112233',
      'landline': '',
      'email': '',
      'verifiedFatherName': 'نمونه',
      'verifiedBirthDate': '1370/01/01',
      'nationalCardFileName': 'national-card.jpg',
      'nationalCardReference': '/media/national-card.jpg',
      'livenessSessionId': '22222222-2222-4222-8222-222222222222',
      'livenessVideoFileName': 'liveness.mp4',
      'livenessVideoReference': '/media/liveness.mp4',
      'verifiedAt': '2026-07-20T08:00:00.000Z',
      'validUntil': '2027-07-20T08:00:00.000Z',
    });

    expect(identity.isComplete, isTrue);
    expect(identity.nationalId, '0012345678');
  });

  test('status-history entry parses event code', () {
    final entry = PartnerApplicationStatusEntry.fromJson(<String, Object?>{
      'status': 'submitted',
      'eventCode': 'application_submitted_by_applicant',
      'note': null,
      'createdAt': '2026-07-20T08:00:00.000Z',
    });

    expect(entry.eventCode, 'application_submitted_by_applicant');
    expect(entry.note, isNull);
  });
}
