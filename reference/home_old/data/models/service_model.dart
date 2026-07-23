// ignore_for_file: constant_identifier_names

import 'package:address/core/design_system/colors/app_colors.dart';
import 'package:address/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum ServiceKey {
  ride,
  deliver,
  airport,
  bike,
  sectionPassenger,
  sectionCargo,
  sectionFood,
  sectionServices,
  sectionRepair,
  sectionInsurance,
  sectionPage1,
  transportation,
  food,
  services,
  garage,
  insurance,
}

class ServiceModel {
  ServiceModel({
    required this.key,
    required this.titleKey,
    required this.captionKey,
    required this.subtitleKey,
    required this.image1,
    required this.image2,
    required this.color,
    this.secondaryColor, // اضافه شده برای گرادیانت‌های خاص (اختیاری)
  });

  final UniqueKey id = UniqueKey();

  final ServiceKey key;
  final String titleKey;
  final String captionKey;
  final String subtitleKey;
  final String image1;
  final String image2;
  final Color color;
  final Color? secondaryColor;

  // استفاده از Switch Expression دارت ۳ برای کدهای بسیار تمیزتر و کوتاه‌تر
  String getTitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return switch (titleKey) {
      'ride' => loc.ride,
      'deliver' => loc.deliver,
      'airport' => loc.airport,
      'bike' => loc.bike,
      'passengerServices' => loc.passengerServices,
      'cargoServices' => loc.cargoServices,
      'foodServices' => loc.foodServices,
      'generalServices' => loc.generalServices,
      'repairServices' => loc.repairServices,
      'insuranceServices' => loc.insuranceServices,
      _ => '',
    };
  }

  String getCaption(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return switch (captionKey) {
      'safeYourTrip' => loc.safeYourTrip,
      'fastAndSafe' => loc.fastAndSafe,
      'cityAndRoad' => loc.cityAndRoad,
      _ => '',
    };
  }

  String getSubtitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return switch (subtitleKey) {
      'anywhereCityTrip' => loc.anywhereCityTrip,
      'cityOrIntercityTrip' => loc.cityOrIntercityTrip,
      _ => '',
    };
  }

  // ==========================================
  // لیست داده‌ها
  // ==========================================

  // خدمات (بنر بالای صفحه - VCard)
  static final List<ServiceModel> services = [
    ServiceModel(
      key: ServiceKey.ride,
      titleKey: 'ride',
      captionKey: 'safeYourTrip',
      subtitleKey: 'anywhereCityTrip',
      image1: "assets/images/address/image1.png",
      image2: "assets/images/vehicles/Eco.png",
      color: AppColors.background, // از رنگ‌های تم خودتان
    ),
    ServiceModel(
      key: ServiceKey.deliver,
      titleKey: 'deliver',
      captionKey: 'safeYourTrip',
      subtitleKey: 'anywhereCityTrip',
      image1: "assets/images/address/image2.png",
      image2: "assets/images/vehicles/Bike.png",
      color: AppColors.blue,
    ),
    ServiceModel(
      key: ServiceKey.airport,
      titleKey: 'airport',
      captionKey: 'safeYourTrip',
      subtitleKey: 'cityOrIntercityTrip',
      image1: "assets/images/address/image3.png",
      image2: "assets/images/vehicles/Airport.png",
      color: AppColors.red,
    ),
    ServiceModel(
      key: ServiceKey.bike,
      titleKey: 'bike',
      captionKey: 'fastAndSafe',
      subtitleKey: '',
      image1: "assets/images/address/images4.png",
      image2: "assets/images/vehicles/Bike.png",
      color: AppColors.orange,
    ),
  ];

  // بخش‌های خدمات (گرید ۶ تایی پایین - HCard)
  // رنگ‌های متمایز اختصاص داده شده تا گرادیانت ملایم ایجاد کنند
  static final List<ServiceModel> serviceSections = [
    ServiceModel(
      key: ServiceKey.sectionPassenger,
      titleKey: 'passengerServices',
      captionKey: '',
      subtitleKey: '',
      image1: "assets/images/vehicles/Eco.png",
      image2: "",
      color: const Color(0xFFFF9800),
    ),
    ServiceModel(
      key: ServiceKey.sectionCargo,
      titleKey: 'cargoServices',
      captionKey: '',
      subtitleKey: '',
      image1: "assets/images/vehicles/Airport.png",
      image2: "",
      color: const Color(0xFF2196F3),
    ),
    ServiceModel(
      key: ServiceKey.sectionFood,
      titleKey: 'foodServices',
      captionKey: '',
      subtitleKey: '',
      image1: "assets/images/vehicles/Bike.png",
      image2: "",
      color: const Color(0xFF00BFA5), // سبزآبی برای غذا
    ),
    ServiceModel(
      key: ServiceKey.sectionServices,
      titleKey: 'generalServices',
      captionKey: '',
      subtitleKey: '',
      image1: "assets/images/vehicles/Carseat.png",
      image2: "",
      color: const Color(0xFF9C27B0), // بنفش برای خدمات عمومی
    ),
    ServiceModel(
      key: ServiceKey.sectionRepair,
      titleKey: 'repairServices',
      captionKey: '',
      subtitleKey: '',
      image1: "assets/images/vehicles/Lux.png",
      image2: "",
      color: const Color(0xFF607D8B), // خاکستری مایل به آبی برای تعمیرات
    ),
    ServiceModel(
      key: ServiceKey.sectionInsurance,
      titleKey: 'insuranceServices',
      captionKey: '',
      subtitleKey: '',
      image1: "assets/images/vehicles/Pet.png",
      image2: "",
      color: const Color(0xFF3F51B5), // نیلی برای بیمه
    ),
  ];
}
