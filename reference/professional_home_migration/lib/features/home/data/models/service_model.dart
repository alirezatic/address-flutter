import 'package:flutter/material.dart';

import 'package:address/l10n/generated/app_localizations.dart';

enum ServiceKey {
  ride,
  deliver,
  airport,
  bike,
  passenger,
  cargo,
  food,
  general,
  repair,
  insurance,
}

class ServiceModel {
  const ServiceModel({
    required this.key,
    required this.image,
    required this.secondaryImage,
    required this.color,
    this.secondaryColor,
  });

  final ServiceKey key;
  final String image;
  final String secondaryImage;
  final Color color;
  final Color? secondaryColor;

  String title(AppLocalizations localizations) {
    return switch (key) {
      ServiceKey.ride => localizations.ride,
      ServiceKey.deliver => localizations.deliver,
      ServiceKey.airport => localizations.airport,
      ServiceKey.bike => localizations.bike,
      ServiceKey.passenger => localizations.passengerServices,
      ServiceKey.cargo => localizations.cargoServices,
      ServiceKey.food => localizations.foodServices,
      ServiceKey.general => localizations.generalServices,
      ServiceKey.repair => localizations.repairServices,
      ServiceKey.insurance => localizations.insuranceServices,
    };
  }

  String subtitle(AppLocalizations localizations) {
    return switch (key) {
      ServiceKey.ride ||
      ServiceKey.deliver => localizations.anywhereCityTrip,
      ServiceKey.airport => localizations.cityOrIntercityTrip,
      ServiceKey.bike => localizations.fastAndSafe,
      _ => '',
    };
  }

  String caption(AppLocalizations localizations) {
    return switch (key) {
      ServiceKey.ride ||
      ServiceKey.deliver ||
      ServiceKey.airport => localizations.safeYourTrip,
      ServiceKey.bike => localizations.fastAndSafe,
      _ => '',
    };
  }

  static const List<ServiceModel> featuredServices = [
    ServiceModel(
      key: ServiceKey.ride,
      image: 'assets/images/address/image1.png',
      secondaryImage: 'assets/images/vehicles/Eco.png',
      color: Color(0xFF092347),
      secondaryColor: Color(0xFF254D82),
    ),
    ServiceModel(
      key: ServiceKey.deliver,
      image: 'assets/images/address/image2.png',
      secondaryImage: 'assets/images/vehicles/Bike.png',
      color: Color(0xFF1464B8),
      secondaryColor: Color(0xFF4E9BE8),
    ),
    ServiceModel(
      key: ServiceKey.airport,
      image: 'assets/images/address/image3.png',
      secondaryImage: 'assets/images/vehicles/Airport.png',
      color: Color(0xFFC83D4D),
      secondaryColor: Color(0xFFF17886),
    ),
    ServiceModel(
      key: ServiceKey.bike,
      image: 'assets/images/address/images4.png',
      secondaryImage: 'assets/images/vehicles/Bike.png',
      color: Color(0xFFE77619),
      secondaryColor: Color(0xFFFFB257),
    ),
  ];

  static const List<ServiceModel> serviceSections = [
    ServiceModel(
      key: ServiceKey.passenger,
      image: 'assets/images/vehicles/Eco.png',
      secondaryImage: '',
      color: Color(0xFFFF9800),
    ),
    ServiceModel(
      key: ServiceKey.cargo,
      image: 'assets/images/vehicles/Airport.png',
      secondaryImage: '',
      color: Color(0xFF2196F3),
    ),
    ServiceModel(
      key: ServiceKey.food,
      image: 'assets/images/vehicles/Bike.png',
      secondaryImage: '',
      color: Color(0xFF00A98F),
    ),
    ServiceModel(
      key: ServiceKey.general,
      image: 'assets/images/vehicles/Carseat.png',
      secondaryImage: '',
      color: Color(0xFF9C27B0),
    ),
    ServiceModel(
      key: ServiceKey.repair,
      image: 'assets/images/vehicles/Lux.png',
      secondaryImage: '',
      color: Color(0xFF607D8B),
    ),
    ServiceModel(
      key: ServiceKey.insurance,
      image: 'assets/images/vehicles/Pet.png',
      secondaryImage: '',
      color: Color(0xFF3F51B5),
    ),
  ];
}
