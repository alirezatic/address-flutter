import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/l10n/generated/app_localizations.dart';

extension PartnerCategoryLocalization on PartnerCategoryId {
  String title(AppLocalizations localizations) {
    return switch (this) {
      PartnerCategoryId.stores => localizations.partnerGroupStores,
      PartnerCategoryId.companies => localizations.partnerGroupCompanies,
      PartnerCategoryId.drivers => localizations.partnerGroupDrivers,
      PartnerCategoryId.food => localizations.partnerGroupFood,
      PartnerCategoryId.other => localizations.partnerGroupOther,
    };
  }

  String subtitle(AppLocalizations localizations) {
    return switch (this) {
      PartnerCategoryId.stores => localizations.partnerGroupStoresSubtitle,
      PartnerCategoryId.companies =>
        localizations.partnerGroupCompaniesSubtitle,
      PartnerCategoryId.drivers => localizations.partnerGroupDriversSubtitle,
      PartnerCategoryId.food => localizations.partnerGroupFoodSubtitle,
      PartnerCategoryId.other => localizations.partnerGroupOtherSubtitle,
    };
  }
}

extension PartnerItemLocalization on PartnerItemId {
  String title(AppLocalizations localizations) {
    return switch (this) {
      PartnerItemId.storeSupermarket => localizations.storeSupermarket,
      PartnerItemId.storeGrocery => localizations.storeGrocery,
      PartnerItemId.storeProtein => localizations.storeProtein,
      PartnerItemId.storeFruitVegetable => localizations.storeFruitVegetable,
      PartnerItemId.storeBakeryPastry => localizations.storeBakeryPastry,
      PartnerItemId.storeDairy => localizations.storeDairy,
      PartnerItemId.storeBeautyHealth => localizations.storeBeautyHealth,
      PartnerItemId.companyFoodBeverage => localizations.companyFoodBeverage,
      PartnerItemId.companyBeautyHealth => localizations.companyBeautyHealth,
      PartnerItemId.companyCleaning => localizations.companyCleaning,
      PartnerItemId.companyPharmaMedical => localizations.companyPharmaMedical,
      PartnerItemId.companyMotorcycleParts =>
        localizations.companyMotorcycleParts,
      PartnerItemId.companyLightVehicleParts =>
        localizations.companyLightVehicleParts,
      PartnerItemId.companyHeavyVehicleParts =>
        localizations.companyHeavyVehicleParts,
      PartnerItemId.companyRetailEquipment =>
        localizations.companyRetailEquipment,
      PartnerItemId.companyPackagingDisposable =>
        localizations.companyPackagingDisposable,
      PartnerItemId.driverMotorcycle => localizations.driverMotorcycle,
      PartnerItemId.driverPassengerCar => localizations.driverPassengerCar,
      PartnerItemId.driverPickup => localizations.driverPickup,
      PartnerItemId.driverVan => localizations.driverVan,
      PartnerItemId.driverMinibus => localizations.driverMinibus,
      PartnerItemId.driverBus => localizations.driverBus,
      PartnerItemId.driverLightTruck => localizations.driverLightTruck,
      PartnerItemId.driverTruck => localizations.driverTruck,
      PartnerItemId.driverTractorTrailer => localizations.driverTractorTrailer,
      PartnerItemId.foodIranian => localizations.foodIranian,
      PartnerItemId.foodInternational => localizations.foodInternational,
      PartnerItemId.foodSeafood => localizations.foodSeafood,
      PartnerItemId.foodFastFood => localizations.foodFastFood,
      PartnerItemId.foodCafe => localizations.foodCafe,
      PartnerItemId.foodCatering => localizations.foodCatering,
      PartnerItemId.foodBakeryDessert => localizations.foodBakeryDessert,
      PartnerItemId.foodHealthyDiet => localizations.foodHealthyDiet,
      PartnerItemId.otherLaundry => localizations.otherLaundry,
      PartnerItemId.otherEvents => localizations.otherEvents,
      PartnerItemId.otherHospitality => localizations.otherHospitality,
      PartnerItemId.otherTechnicalRepair => localizations.otherTechnicalRepair,
      PartnerItemId.otherHomeBuilding => localizations.otherHomeBuilding,
      PartnerItemId.otherBeautyWellness => localizations.otherBeautyWellness,
      PartnerItemId.otherBusiness => localizations.otherBusiness,
    };
  }

  String? description(AppLocalizations localizations) {
    return switch (this) {
      PartnerItemId.storeSupermarket =>
        localizations.storeSupermarketDescription,
      PartnerItemId.storeGrocery => localizations.storeGroceryDescription,
      PartnerItemId.storeProtein => localizations.storeProteinDescription,
      PartnerItemId.storeFruitVegetable =>
        localizations.storeFruitVegetableDescription,
      PartnerItemId.storeBakeryPastry =>
        localizations.storeBakeryPastryDescription,
      PartnerItemId.storeDairy => localizations.storeDairyDescription,
      PartnerItemId.storeBeautyHealth =>
        localizations.storeBeautyHealthDescription,
      PartnerItemId.foodIranian => localizations.foodIranianDescription,
      PartnerItemId.foodInternational =>
        localizations.foodInternationalDescription,
      PartnerItemId.foodSeafood => localizations.foodSeafoodDescription,
      PartnerItemId.foodFastFood => localizations.foodFastFoodDescription,
      PartnerItemId.foodCafe => localizations.foodCafeDescription,
      PartnerItemId.foodCatering => localizations.foodCateringDescription,
      PartnerItemId.foodBakeryDessert =>
        localizations.foodBakeryDessertDescription,
      PartnerItemId.foodHealthyDiet => localizations.foodHealthyDietDescription,
      _ => null,
    };
  }
}

extension PartnerSelectionLocalization on PartnerCategoryDefinition {
  String selectionHint(
    AppLocalizations localizations,
    PartnerDriverMode driverMode,
  ) {
    return switch (selectionMode) {
      PartnerSelectionMode.primarySecondary =>
        localizations.partnersHintPrimarySecondary,
      PartnerSelectionMode.multiple => localizations.partnersHintMultiple,
      PartnerSelectionMode.driver =>
        driverMode == PartnerDriverMode.personal
            ? localizations.partnersHintDriverPersonal
            : localizations.partnersHintDriverCompany,
    };
  }
}
