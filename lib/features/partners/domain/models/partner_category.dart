enum PartnerCategoryId {
  stores,
  companies,
  drivers,
  food,
  other;

  static PartnerCategoryId? tryParse(String value) {
    for (final id in values) {
      if (id.name == value) {
        return id;
      }
    }
    return null;
  }
}

enum PartnerSelectionMode { primarySecondary, multiple, driver }

enum PartnerDriverMode { personal, company }

enum PartnerItemId {
  storeSupermarket,
  storeGrocery,
  storeProtein,
  storeFruitVegetable,
  storeBakeryPastry,
  storeDairy,
  storeBeautyHealth,
  storePharmacy,
  storeStationery,
  storeCulturalProducts,

  companyFoodBeverage,
  companyBeautyHealth,
  companyCleaning,
  companyPharmaMedical,
  companyMotorcycleParts,
  companyLightVehicleParts,
  companyHeavyVehicleParts,
  companyRetailEquipment,
  companyPackagingDisposable,

  driverMotorcycle,
  driverPassengerCar,
  driverPickup,
  driverVan,
  driverMinibus,
  driverBus,
  driverLightTruck,
  driverTruck,
  driverTractorTrailer,

  foodIranian,
  foodInternational,
  foodSeafood,
  foodFastFood,
  foodCafe,
  foodCatering,
  foodBakeryDessert,
  foodHealthyDiet,

  otherLaundry,
  otherCarpetCleaning,
  otherEvents,
  otherHospitality,
  otherTechnicalRepair,
  otherHomeBuilding,
  otherBeautyWellness,
  otherBusiness,
}

class PartnerItemDefinition {
  const PartnerItemDefinition({required this.id, required this.emoji});

  final PartnerItemId id;
  final String emoji;
}

class PartnerCategoryDefinition {
  const PartnerCategoryDefinition({
    required this.id,
    required this.imagePath,
    required this.selectionMode,
    required this.items,
  });

  final PartnerCategoryId id;
  final String imagePath;
  final PartnerSelectionMode selectionMode;
  final List<PartnerItemDefinition> items;
}

class PartnerSelectionResult {
  const PartnerSelectionResult({
    required this.categoryId,
    required this.driverMode,
    required this.primaryItemId,
    required this.selectedItemIds,
  });

  final PartnerCategoryId categoryId;
  final PartnerDriverMode driverMode;
  final PartnerItemId? primaryItemId;
  final Set<PartnerItemId> selectedItemIds;

  int get selectionCount =>
      (primaryItemId == null ? 0 : 1) + selectedItemIds.length;
}
