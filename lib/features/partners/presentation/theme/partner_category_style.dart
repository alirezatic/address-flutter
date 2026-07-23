import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';

extension PartnerCategoryStyle on PartnerCategoryId {
  AppFeaturePalette get palette {
    return switch (this) {
      PartnerCategoryId.stores => AppFeaturePalettes.stores,
      PartnerCategoryId.companies => AppFeaturePalettes.companies,
      PartnerCategoryId.drivers => AppFeaturePalettes.drivers,
      PartnerCategoryId.food => AppFeaturePalettes.food,
      PartnerCategoryId.other => AppFeaturePalettes.other,
    };
  }
}
