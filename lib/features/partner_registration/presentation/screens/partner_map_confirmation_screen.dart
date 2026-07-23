import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerMapConfirmationArgs {
  const PartnerMapConfirmationArgs({
    required this.initialLatitude,
    required this.initialLongitude,
  });

  final double initialLatitude;
  final double initialLongitude;
}

class PartnerMapConfirmationScreen extends StatefulWidget {
  const PartnerMapConfirmationScreen({required this.args, super.key});

  final PartnerMapConfirmationArgs args;

  @override
  State<PartnerMapConfirmationScreen> createState() =>
      _PartnerMapConfirmationScreenState();
}

class _PartnerMapConfirmationScreenState
    extends State<PartnerMapConfirmationScreen> {
  late final MapController _mapController;
  late LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedLocation = LatLng(
      widget.args.initialLatitude,
      widget.args.initialLongitude,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return AppPageScaffold(
      navigationIcon: Icons.arrow_back_ios_new_rounded,
      navigationLabel: localizations.partnersBack,
      onNavigationPressed: () => context.pop(),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.contentMaxWidth,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppLayoutTokens.screenHorizontalPadding,
              AppSpacingTokens.small,
              AppLayoutTokens.screenHorizontalPadding,
              AppSpacingTokens.xxLarge,
            ),
            children: <Widget>[
              Text(
                localizations.partnerMapTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.small),
              Text(
                localizations.partnerMapSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.large),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  height: 430,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _selectedLocation,
                          initialZoom: 17,
                          minZoom: 4,
                          maxZoom: 19,
                          onPositionChanged: (camera, hasGesture) {
                            if (!hasGesture) {
                              return;
                            }

                            setState(() {
                              _selectedLocation = camera.center;
                            });
                          },
                        ),
                        children: <Widget>[
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.address.superapp',
                            maxNativeZoom: 19,
                          ),
                        ],
                      ),
                      IgnorePointer(
                        child: Center(
                          child: Transform.translate(
                            offset: const Offset(0, -24),
                            child: Icon(
                              Icons.location_pin,
                              size: 58,
                              color: colorScheme.primary,
                              shadows: const <Shadow>[
                                Shadow(
                                  blurRadius: 10,
                                  color: Color(0x66000000),
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        start: 10,
                        bottom: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              '© OpenStreetMap contributors',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              Container(
                padding: const EdgeInsets.all(AppSpacingTokens.medium),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      localizations.partnerMapHint,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacingTokens.small),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '${_selectedLocation.latitude.toStringAsFixed(6)}, '
                        '${_selectedLocation.longitude.toStringAsFixed(6)}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacingTokens.large),
              Text(
                localizations.partnerMapConfirmInstruction,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              Center(
                child: AnimatedStartButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => context.pop(_selectedLocation),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
