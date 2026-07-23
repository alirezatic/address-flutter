// ignore_for_file: deprecated_member_use

import 'package:address/core/extensions/context/build_context_extension.dart';
import 'package:address/core/extensions/context/context_extension.dart';
import 'package:address/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // استفاده از توکن‌ها و تم پروژه برای هماهنگی کامل
    final colors = context.colors;
    final text = context.text;
    final tokens = BuildContextExtension(context).tokens;

    // رنگ‌های استخراج شده از تم جایگزین رنگ‌های هاردکد شده شدند
    final primaryColor = colors.primary;
    final onSurfaceColor = colors.onSurface;
    final unselectedColor = colors.onSurfaceVariant;

    final List<(IconData, String)> accountButtons = [
      (CupertinoIcons.circle_grid_3x3_fill, l10n?.services ?? "Services"),
      (CupertinoIcons.square_list_fill, l10n?.activity ?? "Activity"),
      (CupertinoIcons.gift_fill, l10n?.sendGift ?? "Send a gift"),
      (CupertinoIcons.gear_alt_fill, l10n?.settings ?? "Settings"),
      (CupertinoIcons.envelope_fill, l10n?.messages ?? "Messages"),
      (CupertinoIcons.briefcase_fill, l10n?.businessHub ?? "Business hub"),

      (
        CupertinoIcons.person_fill,
        l10n?.manageAddressAccount ?? "Manage Address account",
      ),
      (CupertinoIcons.square_list_fill, l10n?.language ?? "Laguage"),
      (CupertinoIcons.power, l10n?.logOut ?? "Log out"),
    ];

    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest.withOpacity(
        0.0,
      ), // جایگزین AppColors.grey50
      body: SafeArea(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 350, minWidth: 250),
            width: 288.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colors.surfaceContainerHighest,
                        foregroundColor: primaryColor,
                        child: const Icon(Icons.person_outline),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Alireza",
                            // استفاده از فونت خوانا و استاندارد
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: onSurfaceColor,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "Heshmati",
                            // استفاده از فونت خوانا و استاندارد
                            style: text.bodyMedium?.copyWith(
                              color: unselectedColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(15)),
                    ],
                  ),
                ),

                Expanded(
                  // تبدیل به ListView.separated برای قرار دادن خط جداکننده
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: accountButtons.length,
                    separatorBuilder: (context, index) => Divider(
                      // خط جداکننده بین عناوین
                      color: colors.outlineVariant.withValues(alpha: 0.3),
                      thickness: 1,
                      height: 8,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedIndex;
                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        // طراحی اصلی شما (Stack) دقیقاً حفظ شده است
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: isSelected ? (288.0 - 32.0) : 0,
                              height: 56.0,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colors
                                          .primary // بک‌گراند در حالت انتخاب
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  tokens.radiusS,
                                ),
                              ),
                            ),
                            Container(
                              height: 58.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    accountButtons[index].$1,
                                    color: isSelected
                                        ? colors.onPrimary
                                        : unselectedColor,
                                    size: 28.0,
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Text(
                                      accountButtons[index].$2,
                                      // بزرگ و خوانا شدن فونت منوها
                                      style: text.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? colors.onPrimary
                                            : onSurfaceColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  color: colors.outlineVariant.withValues(alpha: 0.5),
                  thickness: 0.5,
                  height: 0,
                  indent: 9,
                  endIndent: 124,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
