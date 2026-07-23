import 'package:address/core/extensions/context/build_context_extension.dart';
import 'package:address/core/extensions/context/context_extension.dart';
import 'package:flutter/material.dart';
import '../../data/models/service_model.dart';

class VCard extends StatefulWidget {
  const VCard({super.key, required this.service});
  final ServiceModel service;

  @override
  State<VCard> createState() => _VCardState();
}

class _VCardState extends State<VCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: 0,
      end: -10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ۱. دریافت تمام مقادیر وابسته به context در اینجا (قبل از انیمیشن)
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final textContext = context.text;
    final title = widget.service.getTitle(context);
    final subtitle = widget.service.getSubtitle(context);
    final caption = widget.service.getCaption(context);

    // تمام ابعاد از پیش محاسبه می‌شوند تا داخل انیمیشن نیازی به context نباشد
    final width90 = context.w(90);
    final height25 = context.h(25);
    final padding3 = context.w(3);
    final radius18 = context.sp(18);
    final spacing05 = context.h(0.5);
    final radius30 = context.sp(30);
    final imgHeight8 = context.h(8);
    final imgWidth58 = context.w(58);
    final imgWidth20 = context.w(20);

    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (_, _) {
        // از context داخلی استفاده نمی‌کنیم
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Container(
            width: width90,
            height: height25,
            padding: EdgeInsets.all(padding3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.service.color,
                  widget.service.color.withValues(alpha: 0.5),
                ],
                begin: isRTL ? Alignment.topRight : Alignment.topLeft,
                end: isRTL ? Alignment.bottomLeft : Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(radius18),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textContext.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: spacing05), // استفاده از متغیر
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textContext.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: spacing05), // استفاده از متغیر
                    Text(
                      caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textContext.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          radius30,
                        ), // استفاده از متغیر
                        child: Image.asset(
                          widget.service.image1,
                          height: imgHeight8, // استفاده از متغیر
                          width: imgWidth58, // استفاده از متغیر
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

                if (widget.service.image2.isNotEmpty)
                  PositionedDirectional(
                    end: 0,
                    top: 0,
                    child: Transform.translate(
                      offset: Offset(0, _floatAnimation.value * 0.5),
                      child: Image.asset(
                        widget.service.image2,
                        height: imgHeight8, // استفاده از متغیر
                        width: imgWidth20, // استفاده از متغیر
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
