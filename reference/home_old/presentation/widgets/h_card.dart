import 'package:address/core/extensions/context/build_context_extension.dart';
import 'package:address/core/extensions/context/context_extension.dart';
import 'package:address/modules/rider/presentation/screens/transportation_screen.dart';
import 'package:flutter/material.dart';
import '../../data/models/service_model.dart';

class HCard extends StatelessWidget {
  const HCard({super.key, required this.section});

  final ServiceModel section;

  void navigateToPage(BuildContext context) {
    Widget? page;

    switch (section.key) {
      case ServiceKey.sectionPassenger:
        page = TransportationPage(onLocaleChange: (Locale locale) {});
        break;
      default:
        page = null;
    }

    if (page != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('صفحه مرتبط با این سرویس تعریف نشده است.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    final title = section.getTitle(context);
    final caption = section.getCaption(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.sp(16)),
        boxShadow: [
          BoxShadow(
            color: section.color.withValues(alpha: 0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(context.sp(16)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => navigateToPage(context),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  section.color.withValues(alpha: 0.08),
                  section.color.withValues(alpha: 0.01),
                ],
              ),
              border: Border.all(
                color: section.color.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                PositionedDirectional(
                  end: -context.w(5),
                  top: -context.h(2),
                  bottom: -context.h(2),
                  child: Container(
                    width: context.w(35),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          section.color.withValues(alpha: 0.25),
                          section.color.withValues(alpha: 0.0),
                        ],
                        stops: const [0.2, 1.0],
                      ),
                    ),
                  ),
                ),

                // تغییرات در این بخش اعمال شده است 👇
                Padding(
                  // پدینگ عمودی از 1.5 به 1.0 کاهش یافت
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(4),
                    vertical: context.h(1.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // افزودن این خط برای تراز بهتر
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: text.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurface,
                                ),
                              ),
                              // فاصله بین تیتر و کپشن از 0.5 به 0.2 کاهش یافت
                              SizedBox(height: context.h(0.2)),
                              Text(
                                caption,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: text.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  // کاهش جزئی ارتفاع خطوط برای جلوگیری از اورفلو در متن‌های دو خطی
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: context.w(3)),

                      Container(
                        padding: EdgeInsets.all(context.sp(2)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.surface,
                          boxShadow: [
                            BoxShadow(
                              color: section.color.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            section.image1,
                            // تغییر اندازه عکس به مقدار ثابت نسبی برای اطمینان از عدم تغییر سایز غیرمنتظره
                            width: context.h(5.5),
                            height: context.h(5.5),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
