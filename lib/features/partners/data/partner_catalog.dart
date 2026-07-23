import 'package:address/features/partners/domain/models/partner_category.dart';

abstract final class PartnerCatalog {
  static const List<PartnerCategoryDefinition>
  categories = <PartnerCategoryDefinition>[
    PartnerCategoryDefinition(
      id: PartnerCategoryId.stores,
      imagePath: 'assets/images/partners/cat-stores.webp',
      selectionMode: PartnerSelectionMode.primarySecondary,
      items: <PartnerItemDefinition>[
        PartnerItemDefinition(id: PartnerItemId.storeSupermarket, emoji: '🏪'),
        PartnerItemDefinition(id: PartnerItemId.storeGrocery, emoji: '🧺'),
        PartnerItemDefinition(id: PartnerItemId.storeProtein, emoji: '🥩'),
        PartnerItemDefinition(
          id: PartnerItemId.storeFruitVegetable,
          emoji: '🍎',
        ),
        PartnerItemDefinition(id: PartnerItemId.storeBakeryPastry, emoji: '🥐'),
        PartnerItemDefinition(id: PartnerItemId.storeDairy, emoji: '🥛'),
        PartnerItemDefinition(id: PartnerItemId.storeBeautyHealth, emoji: '💄'),
      ],
    ),
    PartnerCategoryDefinition(
      id: PartnerCategoryId.companies,
      imagePath: 'assets/images/partners/cat-suppliers.webp',
      selectionMode: PartnerSelectionMode.multiple,
      items: <PartnerItemDefinition>[
        PartnerItemDefinition(
          id: PartnerItemId.companyFoodBeverage,
          emoji: '🍱',
        ),
        PartnerItemDefinition(
          id: PartnerItemId.companyBeautyHealth,
          emoji: '🧴',
        ),
        PartnerItemDefinition(id: PartnerItemId.companyCleaning, emoji: '🧼'),
        PartnerItemDefinition(
          id: PartnerItemId.companyPharmaMedical,
          emoji: '💊',
        ),
        PartnerItemDefinition(
          id: PartnerItemId.companyMotorcycleParts,
          emoji: '🏍️',
        ),
        PartnerItemDefinition(
          id: PartnerItemId.companyLightVehicleParts,
          emoji: '🚗',
        ),
        PartnerItemDefinition(
          id: PartnerItemId.companyHeavyVehicleParts,
          emoji: '🚛',
        ),
        PartnerItemDefinition(
          id: PartnerItemId.companyRetailEquipment,
          emoji: '🏷️',
        ),
        PartnerItemDefinition(
          id: PartnerItemId.companyPackagingDisposable,
          emoji: '📦',
        ),
      ],
    ),
    PartnerCategoryDefinition(
      id: PartnerCategoryId.drivers,
      imagePath: 'assets/images/partners/cat-drivers.webp',
      selectionMode: PartnerSelectionMode.driver,
      items: <PartnerItemDefinition>[
        PartnerItemDefinition(id: PartnerItemId.driverMotorcycle, emoji: '🏍️'),
        PartnerItemDefinition(
          id: PartnerItemId.driverPassengerCar,
          emoji: '🚗',
        ),
        PartnerItemDefinition(id: PartnerItemId.driverPickup, emoji: '🛻'),
        PartnerItemDefinition(id: PartnerItemId.driverVan, emoji: '🚐'),
        PartnerItemDefinition(id: PartnerItemId.driverMinibus, emoji: '🚌'),
        PartnerItemDefinition(id: PartnerItemId.driverBus, emoji: '🚍'),
        PartnerItemDefinition(id: PartnerItemId.driverLightTruck, emoji: '🚚'),
        PartnerItemDefinition(id: PartnerItemId.driverTruck, emoji: '🚛'),
        PartnerItemDefinition(
          id: PartnerItemId.driverTractorTrailer,
          emoji: '🚜',
        ),
      ],
    ),
    PartnerCategoryDefinition(
      id: PartnerCategoryId.food,
      imagePath: 'assets/images/partners/cat-food.webp',
      selectionMode: PartnerSelectionMode.primarySecondary,
      items: <PartnerItemDefinition>[
        PartnerItemDefinition(id: PartnerItemId.foodIranian, emoji: '🍚'),
        PartnerItemDefinition(id: PartnerItemId.foodInternational, emoji: '🍝'),
        PartnerItemDefinition(id: PartnerItemId.foodSeafood, emoji: '🦐'),
        PartnerItemDefinition(id: PartnerItemId.foodFastFood, emoji: '🍔'),
        PartnerItemDefinition(id: PartnerItemId.foodCafe, emoji: '☕'),
        PartnerItemDefinition(id: PartnerItemId.foodCatering, emoji: '🍲'),
        PartnerItemDefinition(id: PartnerItemId.foodBakeryDessert, emoji: '🧁'),
        PartnerItemDefinition(id: PartnerItemId.foodHealthyDiet, emoji: '🥗'),
      ],
    ),
    PartnerCategoryDefinition(
      id: PartnerCategoryId.other,
      imagePath: 'assets/images/partners/cat-services.webp',
      selectionMode: PartnerSelectionMode.multiple,
      items: <PartnerItemDefinition>[
        PartnerItemDefinition(id: PartnerItemId.otherLaundry, emoji: '🧺'),
        PartnerItemDefinition(id: PartnerItemId.otherEvents, emoji: '🎉'),
        PartnerItemDefinition(id: PartnerItemId.otherHospitality, emoji: '🏨'),
        PartnerItemDefinition(
          id: PartnerItemId.otherTechnicalRepair,
          emoji: '🔧',
        ),
        PartnerItemDefinition(id: PartnerItemId.otherHomeBuilding, emoji: '🏠'),
        PartnerItemDefinition(
          id: PartnerItemId.otherBeautyWellness,
          emoji: '💇',
        ),
        PartnerItemDefinition(id: PartnerItemId.otherBusiness, emoji: '🧩'),
      ],
    ),
  ];

  static PartnerCategoryDefinition byId(PartnerCategoryId id) {
    return categories.firstWhere((category) => category.id == id);
  }
}
