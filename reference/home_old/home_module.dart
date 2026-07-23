// lib/modules/home/home_module.dart
import 'package:address/platform/module_system/module_context.dart';

import 'package:address/platform/navigation/providers/route_provider.dart';
import 'package:address/platform/navigation/registry/route_registry.dart';
import 'package:address/platform/core/di/di_container.dart';

import '../../platform/module_system/app_module.dart';
import '../../platform/bus/events/event_bus.dart';
import '../../platform/bus/events/auth_events.dart';
// ... سایر ایمپورت‌ها

class HomeModule implements AppModule {
  @override
  String get id => 'home_module';

  // ... سایر متدها

  @override
  void registerEvents(EventBus bus) {
    // ماژول Home همیشه گوش به زنگ رویداد لاگین است
    bus.on<UserLoggedInEvent>().listen((event) {
      print('🏠 Home Module: متوجه ورود کاربر شدیم! شناسه: ${event.userId}');
      // اینجا می‌توانید دستور رفرش شدن لیست رستوران‌ها، کیف پول و ... را بدهید
    });
  }

  Future<void> init(ModuleContext context) {
    // TODO: implement init
    throw UnimplementedError();
  }

  // TODO: implement routeProvider
  RouteProvider? get routeProvider => throw UnimplementedError();

  @override
  void registerDependencies(DiContainer di) {
    // TODO: implement registerDependencies
  }

  @override
  void registerRoutes(RouteRegistry routes) {
    // TODO: implement registerRoutes
  }
}
