import 'dart:async';
import 'dart:ui';
import 'package:address/core/design_system/colors/app_colors.dart';
import 'package:address/modules/home/presentation/widgets/h_card.dart';
import 'package:address/modules/home/data/models/service_model.dart';
import 'package:address/modules/home/presentation/widgets/v_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<ServiceModel> _services = ServiceModel.services;
  final List<ServiceModel> _serviceSections = ServiceModel.serviceSections;

  late final PageController _pageController;
  Timer? _timer;

  int _currentPage = 0;
  bool _isPaused = false;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();

    _currentPage = _services.length * 100;

    _pageController = PageController(
      viewportFraction: 0.82,
      initialPage: _currentPage,
    );

    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (!_isPaused && _pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isActive = _navIndex == index;

    return GestureDetector(
      onTap: () {
        if (!mounted) return;
        setState(() => _navIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive
              ? AppColors.background1.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 22,
          color: isActive ? AppColors.background1 : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final padding = media.padding;

    final carouselHeight = size.height * 0.35;
    final logoHeight = size.height * 0.10;

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: padding.top - 50,
            bottom: padding.bottom + 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      "assets/images/logo/address.png",
                      height: logoHeight,
                    ),
                  ),
                ),
              ),

              /// Carousel
              SizedBox(
                height: carouselHeight,
                child: GestureDetector(
                  onPanDown: (_) => _isPaused = true,
                  onPanEnd: (_) => _isPaused = false,
                  onPanCancel: () => _isPaused = false,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      if (!mounted) return;
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        // ۱. ویجت VCard را اینجا به child پاس می‌دهیم تا درگیر رندر ۶۰ فریم بر ثانیه نشود
                        child: RepaintBoundary(
                          child: VCard(
                            service: _services[index % _services.length],
                          ),
                        ),
                        builder: (context, child) {
                          double pageOffset = 0;

                          if (_pageController.hasClients &&
                              _pageController.position.haveDimensions) {
                            pageOffset = (_pageController.page ?? 0) - index;
                          } else {
                            pageOffset = _currentPage.toDouble() - index;
                          }

                          final double scale = (1 - (pageOffset.abs() * 0.12))
                              .clamp(0.8, 1.2);

                          final double tilt = pageOffset * 0.15;
                          final double parallax = pageOffset * 40;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(tilt),
                              child: Transform.scale(
                                scale: scale,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (pageOffset.abs() < 0.5)
                                      Container(
                                        margin: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.background1
                                                  .withValues(alpha: 0.2),
                                              blurRadius: 25,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),

                                    // ۲. در اینجا فقط child (که همان VCard است) را فراخوانی می‌کنیم
                                    Transform.translate(
                                      offset: Offset(parallax, 0),
                                      child: child,
                                    ),

                                    if (pageOffset.abs() > 0.1)
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: (pageOffset.abs() * 2)
                                                  .clamp(0, 4),
                                              sigmaY: (pageOffset.abs() * 2)
                                                  .clamp(0, 4),
                                            ),
                                            child: const SizedBox(),
                                          ),
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

              /// Indicators
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_services.length, (index) {
                      final bool isActive =
                          (_currentPage % _services.length) == index;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.background1
                              : AppColors.background1.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              /// Sections (تبدیل شده به ۲ ستون)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // برای جلوگیری از تداخل اسکرول
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // ۲ ستون
                    crossAxisSpacing: 5, // فاصله افقی بین کارت‌ها
                    mainAxisSpacing: 8, // فاصله عمودی بین کارت‌ها
                    childAspectRatio:
                        2, // تناسب عرض به ارتفاع. (این عدد را بسته به طراحی HCard می‌توانید بین 1.5 تا 2.5 تغییر دهید تا زیباتر شود)
                  ),
                  itemCount: _serviceSections.length,
                  itemBuilder: (context, index) {
                    return HCard(section: _serviceSections[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      /// Floating Bottom Navigation
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(
          size.width * 0.04,
          0,
          size.width * 0.04,
          size.height * 0.02,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background3.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.directions_car, 0),
            _buildNavItem(Icons.local_shipping, 1),
            _buildNavItem(Icons.fastfood, 2),
            _buildNavItem(Icons.motorcycle, 3),
          ],
        ),
      ),
    );
  }
}
