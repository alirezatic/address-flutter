import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/features/home/data/models/service_model.dart';
import 'package:address/features/home/presentation/widgets/service_banner_card.dart';
import 'package:address/features/home/presentation/widgets/service_section_card.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  static const List<ServiceModel> _services = ServiceModel.featuredServices;
  static const List<ServiceModel> _sections = ServiceModel.serviceSections;

  late final PageController _pageController;
  Timer? _autoPlayTimer;

  int _currentPage = _services.length * 100;
  int _navigationIndex = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.86,
    );

    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (!_isPaused && _pageController.hasClients) {
        _currentPage++;

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 850),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _showComingSoon() {
    final localizations = AppLocalizations.of(context);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(localizations.comingSoon)));
  }

  Future<void> _openDistributionOrders() async {
    if (_navigationIndex != 1) {
      setState(() {
        _navigationIndex = 1;
      });
    }

    await context.push(AppRoutePaths.distributionOrders);

    if (mounted && _navigationIndex == 1) {
      setState(() {
        _navigationIndex = 0;
      });
    }
  }

  Future<void> _openAddressPartners() async {
    await context.push(AppRoutePaths.addressPartners);
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildNavigationItem(BuildContext context, IconData icon, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final active = _navigationIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () async {
        if (index == 1) {
          await _openDistributionOrders();
          return;
        }

        setState(() {
          _navigationIndex = index;
        });

        if (index != 0) {
          _showComingSoon();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: active
              ? colorScheme.primary.withValues(alpha: 0.12)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 23,
          color: active ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Material(
        color: colorScheme.surface,
        child: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final viewportWidth = constraints.maxWidth;
                  final contentWidth = viewportWidth.clamp(0, 1120).toDouble();

                  final carouselWidth = contentWidth.clamp(300, 780).toDouble();

                  final carouselHeight = (carouselWidth * 0.47)
                      .clamp(250, 340)
                      .toDouble();

                  final logoWidth = (viewportWidth * 0.30)
                      .clamp(190, 280)
                      .toDouble();

                  final crossAxisCount = contentWidth < 680 ? 2 : 3;
                  final sectionAspectRatio = contentWidth < 430 ? 1.65 : 2.15;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 112),
                    child: Center(
                      child: SizedBox(
                        width: contentWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/logo/address1.png',
                                height: logoWidth,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Center(
                              child: SizedBox(
                                width: carouselWidth,
                                height: carouselHeight,
                                child: GestureDetector(
                                  onPanDown: (_) {
                                    _isPaused = true;
                                  },
                                  onPanEnd: (_) {
                                    _isPaused = false;
                                  },
                                  onPanCancel: () {
                                    _isPaused = false;
                                  },
                                  child: PageView.builder(
                                    controller: _pageController,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      final service =
                                          _services[index % _services.length];

                                      return AnimatedBuilder(
                                        animation: _pageController,
                                        child: RepaintBoundary(
                                          child: ServiceBannerCard(
                                            service: service,
                                          ),
                                        ),
                                        builder: (context, child) {
                                          var pageOffset = 0.0;

                                          if (_pageController.hasClients &&
                                              _pageController
                                                  .position
                                                  .haveDimensions) {
                                            pageOffset =
                                                (_pageController.page ?? 0) -
                                                index;
                                          } else {
                                            pageOffset =
                                                _currentPage.toDouble() - index;
                                          }

                                          final scale =
                                              (1 - pageOffset.abs() * 0.10)
                                                  .clamp(0.86, 1.0)
                                                  .toDouble();

                                          final tilt = (pageOffset * 0.10)
                                              .clamp(-0.16, 0.16);

                                          final parallax =
                                              pageOffset *
                                              ((Directionality.of(context) ==
                                                      TextDirection.rtl)
                                                  ? 24
                                                  : -24);

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  (Directionality.of(context) ==
                                                      TextDirection.rtl)
                                                  ? 2
                                                  : 8,
                                              vertical: 30,
                                            ),
                                            child: Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.identity()
                                                ..setEntry(3, 2, 0.001)
                                                ..rotateY(tilt),
                                              child: Transform.scale(
                                                scale: scale,
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Transform.translate(
                                                      offset: Offset(
                                                        parallax,
                                                        0,
                                                      ),
                                                      child: child,
                                                    ),
                                                    if (pageOffset.abs() > 0.15)
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              24,
                                                            ),
                                                        child: BackdropFilter(
                                                          filter: ImageFilter.blur(
                                                            sigmaX:
                                                                (pageOffset.abs() *
                                                                        1.5)
                                                                    .clamp(0, 3),
                                                            sigmaY:
                                                                (pageOffset.abs() *
                                                                        1.5)
                                                                    .clamp(0, 3),
                                                          ),
                                                          child:
                                                              const SizedBox.expand(),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(_services.length, (
                                  index,
                                ) {
                                  final active =
                                      _currentPage % _services.length == index;

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 280),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: active ? 18 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: active
                                          ? colorScheme.primary
                                          : colorScheme.primary.withValues(
                                              alpha: 0.24,
                                            ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 28),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: sectionAspectRatio,
                                  ),
                              itemCount: _sections.length,
                              itemBuilder: (context, index) {
                                final service = _sections[index];

                                return ServiceSectionCard(
                                  service: service,
                                  onTap: switch (service.key) {
                                    ServiceKey.cargo => _openDistributionOrders,
                                    ServiceKey.insurance =>
                                      _openAddressPartners,
                                    _ => _showComingSoon,
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.94,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.45,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildNavigationItem(
                            context,
                            Icons.directions_car_filled_rounded,
                            0,
                          ),
                          _buildNavigationItem(
                            context,
                            Icons.local_shipping_rounded,
                            1,
                          ),
                          _buildNavigationItem(
                            context,
                            Icons.fastfood_rounded,
                            2,
                          ),
                          _buildNavigationItem(
                            context,
                            Icons.motorcycle_rounded,
                            3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
