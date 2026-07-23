import 'dart:async';

import 'package:flutter/material.dart';

import 'package:address/features/home/data/models/service_model.dart';
import 'package:address/features/home/presentation/layout/home_layout_metrics.dart';
import 'package:address/features/home/presentation/widgets/service_banner_card.dart';
import 'package:address/features/home/presentation/widgets/service_section_card.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  static const List<ServiceModel> _services =
      ServiceModel.featuredServices;
  static const List<ServiceModel> _sections =
      ServiceModel.serviceSections;

  static const int _initialPageMultiplier = 100;
  static const Duration _autoPlayInterval = Duration(seconds: 5);
  static const Duration _autoPlayDuration = Duration(milliseconds: 620);

  late final PageController _pageController;
  late final ValueNotifier<int> _selectedServiceIndex;
  late final ValueNotifier<int> _navigationIndex;

  Timer? _autoPlayTimer;
  Timer? _resumeTimer;

  int _currentPage = _services.length * _initialPageMultiplier;
  bool _isUserInteracting = false;
  bool _imagesWerePrecached = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.96,
    );

    _selectedServiceIndex = ValueNotifier<int>(
      _currentPage % _services.length,
    );

    _navigationIndex = ValueNotifier<int>(0);
    _startAutoPlay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_imagesWerePrecached) {
      return;
    }

    _imagesWerePrecached = true;

    final imagePaths = <String>{
      'assets/images/logo/address.png',
      for (final service in _services) service.image,
      for (final service in _services)
        if (service.secondaryImage.isNotEmpty)
          service.secondaryImage,
      for (final service in _sections) service.image,
    };

    for (final path in imagePaths) {
      precacheImage(AssetImage(path), context);
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();

    _autoPlayTimer = Timer.periodic(
      _autoPlayInterval,
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_isUserInteracting || !_pageController.hasClients) {
          return;
        }

        _currentPage++;

        _pageController.animateToPage(
          _currentPage,
          duration: _autoPlayDuration,
          curve: Curves.easeInOutCubic,
        );
      },
    );
  }

  void _pauseAutoPlay() {
    _resumeTimer?.cancel();
    _isUserInteracting = true;
  }

  void _resumeAutoPlayAfterDelay() {
    _resumeTimer?.cancel();

    _resumeTimer = Timer(
      const Duration(seconds: 2),
      () {
        _isUserInteracting = false;
      },
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _pauseAutoPlay();
    } else if (notification is ScrollEndNotification) {
      _resumeAutoPlayAfterDelay();
    }

    return false;
  }

  void _showComingSoon() {
    final localizations = AppLocalizations.of(context);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(localizations.comingSoon),
        ),
      );
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _resumeTimer?.cancel();
    _pageController.dispose();
    _selectedServiceIndex.dispose();
    _navigationIndex.dispose();
    super.dispose();
  }

  Widget _buildNavigationItem(
    BuildContext context,
    IconData icon,
    int index,
    int selectedIndex,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final active = selectedIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        _navigationIndex.value = index;

        if (index != 0) {
          _showComingSoon();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: active
              ? colorScheme.primary.withValues(alpha: 0.12)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 23,
          color: active
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.45),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: ValueListenableBuilder<int>(
                valueListenable: _navigationIndex,
                builder: (context, selectedIndex, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavigationItem(
                        context,
                        Icons.directions_car_filled_rounded,
                        0,
                        selectedIndex,
                      ),
                      _buildNavigationItem(
                        context,
                        Icons.local_shipping_rounded,
                        1,
                        selectedIndex,
                      ),
                      _buildNavigationItem(
                        context,
                        Icons.fastfood_rounded,
                        2,
                        selectedIndex,
                      ),
                      _buildNavigationItem(
                        context,
                        Icons.motorcycle_rounded,
                        3,
                        selectedIndex,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final metrics =
                HomeLayoutMetrics.fromWidth(constraints.maxWidth);

            final availableContentWidth = constraints.maxWidth -
                (metrics.horizontalPadding * 2);

            final contentWidth = availableContentWidth
                .clamp(280, metrics.contentMaxWidth)
                .toDouble();

            final carouselWidth =
                contentWidth.clamp(280, metrics.carouselMaxWidth).toDouble();

            final carouselHeight =
                metrics.carouselHeightFor(carouselWidth);

            return Column(
              children: [
                Expanded(
                  child: SafeArea(
                    bottom: false,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        metrics.horizontalPadding,
                        metrics.topPadding,
                        metrics.horizontalPadding,
                        28,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: contentWidth,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/images/logo/address.png',
                                  width: metrics.logoWidth,
                                  height: 106,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.medium,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: SizedBox(
                                  width: carouselWidth,
                                  height: carouselHeight,
                                  child: ClipRect(
                                    child:
                                        NotificationListener<
                                            ScrollNotification>(
                                      onNotification:
                                          _handleScrollNotification,
                                      child: PageView.builder(
                                        controller: _pageController,
                                        clipBehavior: Clip.hardEdge,
                                        onPageChanged: (index) {
                                          _currentPage = index;
                                          _selectedServiceIndex.value =
                                              index % _services.length;
                                        },
                                        itemBuilder: (context, index) {
                                          final service = _services[
                                              index % _services.length];

                                          return AnimatedBuilder(
                                            animation: _pageController,
                                            child: RepaintBoundary(
                                              child: ServiceBannerCard(
                                                service: service,
                                              ),
                                            ),
                                            builder: (context, child) {
                                              var pageOffset = 0.0;

                                              if (_pageController
                                                      .hasClients &&
                                                  _pageController.position
                                                      .haveDimensions) {
                                                pageOffset =
                                                    (_pageController.page ??
                                                        _currentPage
                                                            .toDouble()) -
                                                    index;
                                              } else {
                                                pageOffset =
                                                    _currentPage.toDouble() -
                                                    index;
                                              }

                                              final distance =
                                                  pageOffset.abs().clamp(
                                                    0,
                                                    1,
                                                  );

                                              final scale =
                                                  1 - (distance * 0.045);

                                              final opacity =
                                                  1 - (distance * 0.20);

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 10,
                                                    ),
                                                child: Opacity(
                                                  opacity: opacity,
                                                  child: Transform.scale(
                                                    scale: scale,
                                                    child: child,
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
                              ),
                              const SizedBox(height: 6),
                              Center(
                                child: ValueListenableBuilder<int>(
                                  valueListenable:
                                      _selectedServiceIndex,
                                  builder: (
                                    context,
                                    selectedIndex,
                                    child,
                                  ) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                        _services.length,
                                        (index) {
                                          final active =
                                              selectedIndex == index;

                                          return AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 240,
                                            ),
                                            margin:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                ),
                                            width: active ? 20 : 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: active
                                                  ? colorScheme.primary
                                                  : colorScheme.primary
                                                        .withValues(
                                                          alpha: 0.23,
                                                        ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 26),
                              GridView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          metrics.gridCrossAxisCount,
                                      crossAxisSpacing:
                                          metrics.gridSpacing,
                                      mainAxisSpacing:
                                          metrics.gridSpacing,
                                      childAspectRatio:
                                          metrics.gridAspectRatio,
                                    ),
                                itemCount: _sections.length,
                                itemBuilder: (context, index) {
                                  return RepaintBoundary(
                                    child: ServiceSectionCard(
                                      service: _sections[index],
                                      onTap: _showComingSoon,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildBottomNavigation(context),
              ],
            );
          },
        ),
      ),
    );
  }
}
