import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/buttons/app_top_navigation_button.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.body,
    required this.navigationIcon,
    required this.onNavigationPressed,
    this.navigationLabel,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget body;
  final IconData navigationIcon;
  final VoidCallback onNavigationPressed;
  final String? navigationLabel;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final mediaPadding = MediaQuery.paddingOf(context);
    final reservedTop =
        mediaPadding.top +
        AppLayoutTokens.topButtonTop +
        AppLayoutTokens.topButtonSize +
        AppLayoutTokens.topButtonContentGap;

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor:
          backgroundColor ??
          Theme.of(context).colorScheme.surfaceContainerLowest,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: reservedTop),
              child: body,
            ),
          ),
          PositionedDirectional(
            top: mediaPadding.top + AppLayoutTokens.topButtonTop,
            start: AppLayoutTokens.topButtonSide,
            child: AppTopNavigationButton(
              icon: navigationIcon,
              semanticLabel: navigationLabel,
              onPressed: onNavigationPressed,
            ),
          ),
        ],
      ),
    );
  }
}
