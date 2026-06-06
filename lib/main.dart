import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/controller/language_controller.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/service/internet_checker_service.dart';
import 'package:rainbow_partner/utils/routes/routes.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';
import 'package:rainbow_partner/view/service/notification_service.dart';
import 'package:rainbow_partner/view_model/auth_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/accept_later_ride_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/active_ride_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_cancel_reason_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_earning_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_history_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_payment_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/change_cab_order_status_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/change_paymode_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/check_payment_status_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_can_discount_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_ignore_order_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_offer_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_five_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_four_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_one_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_six_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_three_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_two_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_transaction_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_withdraw_history_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_withdraw_request_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/partner_notification_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_colors_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_fuel_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_model_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_view_model.dart';
import 'package:rainbow_partner/view_model/device_view_model.dart';
import 'package:rainbow_partner/view_model/help_support_view_model.dart';
import 'package:rainbow_partner/view_model/policy_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/accept_order_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/add_bank_detail_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/call_back_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/categories_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/change_order_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/change_service_pay_mode_vm.dart';
import 'package:rainbow_partner/view_model/service_man/city_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/complete_booking_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/driver_online_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/ignore_service_order_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/job_request_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/payment_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/review_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_bank_edit_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_bank_update_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_check_payment_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_get_bank_detail_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_info_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_online_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_withdraw_history_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_earning_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_register_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/transaction_history_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_brand_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/withdraw_request_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/zone_cities_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const MethodChannel nativeChannel =
MethodChannel('rainbow_partner/native_callback');
const MethodChannel overlayChannel = MethodChannel('rapido_background_button');

@pragma('vm:entry-point')
void servicemanNotificationBackgroundTap(NotificationResponse response) {
  debugPrint("🔥 BACKGROUND TAP RECEIVED");
}

@pragma('vm:entry-point')
Future<void> handleNativeCallback(MethodCall call) async {
  WidgetsFlutterBinding.ensureInitialized();

  switch (call.method) {
    case 'onRideEvent':
      final Map<String, dynamic> data =
      Map<String, dynamic>.from(call.arguments);
      debugPrint("🚖 Ride Event from Native: $data");
      break;
    default:
      debugPrint("⚠️ Unknown native callback");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  final String languageCode = sp.getString('language_code') ?? '';

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  nativeChannel.setMethodCallHandler(handleNativeCallback);

  runApp( MyApp(
    locale: languageCode,
  ));
}

double topPadding = 0.0;
double bottomPadding = 0.0;

class MyApp extends StatefulWidget {
  final String locale;
  const MyApp({super.key, required this.locale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final InternetCheckerService _internetCheckerService =
  InternetCheckerService();
  final notificationService = NotificationService(navigatorKey: navigatorKey);

  Map<String, dynamic>? _pendingOverlayAccept;
  Map<String, dynamic>? _pendingOverlayIgnore;
  bool _overlayAcceptBusy = false;
  bool _overlayIgnoreBusy = false;

  Future<BuildContext?> _waitForNavigatorContext() async {
    for (var i = 0; i < 80; i++) {
      final ctx = navigatorKey.currentContext;
      if (ctx != null && ctx.mounted) return ctx;
      await Future<void>.delayed(
        i == 0 ? Duration.zero : const Duration(milliseconds: 50),
      );
    }
    return null;
  }

  Future<void> _handleOverlayAcceptRide(Map<String, dynamic> data) async {
    if (_overlayAcceptBusy) return;
    _overlayAcceptBusy = true;

    try {
      var ctx = await _waitForNavigatorContext();
      ctx ??= navigatorKey.currentContext;

      if (ctx == null || !ctx.mounted) {
        _pendingOverlayAccept = Map<String, dynamic>.from(data);
        debugPrint('overlay accept: navigator not ready, will retry on resume');
        return;
      }

      final panel = data['panel'] as String? ?? 'driver';
      final int orderType = int.tryParse(data['order_type']?.toString() ?? '1') ?? 1;

      if (panel == 'serviceman') {
        final String orderId = data['id']?.toString() ?? '';
        final String distanceKm = data['distance_km']?.toString() ?? '';
        final String distanceRaw = data['distance']?.toString() ?? '';

        // Priority for distance_km if it's not empty and not "0.0" (or fallback to distance)
        String finalDistance = (distanceKm.isNotEmpty && distanceKm != "0.0")
            ? distanceKm
            : (distanceRaw.isNotEmpty ? distanceRaw : "0.0");

        debugPrint("📍 Distance KM (Overlay): $distanceKm");
        debugPrint("📍 Distance Raw (Overlay): $distanceRaw");
        debugPrint("📍 Sending Distance to API: $finalDistance");

        if (orderId.isNotEmpty) {
          await Provider.of<AcceptOrderViewModel>(ctx, listen: false)
              .acceptOrderApiSilent(int.parse(orderId), finalDistance);
          navigatorKey.currentState?.pushNamed(RoutesName.acceptedBooking);
        }
      } else {
        final String orderId = data['id']?.toString() ?? '';
        final String userIdOrder = data['user_id']?.toString() ?? '';
        final int amount = int.tryParse(data['amount']?.toString() ?? '0') ?? 0;

        if (orderType == 2) {
          if (orderId.isNotEmpty) {
            await Provider.of<AcceptLaterRideViewModel>(ctx, listen: false)
                .acceptLaterRideApiSilent(orderId);
            navigatorKey.currentState?.pushNamed(RoutesName.cabRideHistory);
          }
        } else {
          if (orderId.isNotEmpty && userIdOrder.isNotEmpty) {
            Provider.of<DriverOfferViewModel>(ctx, listen: false).driverOfferApi(
              userIdOrder, orderId, amount, amount, ctx,
            );
          }
          navigatorKey.currentState?.pushNamed(RoutesName.rideWaiting);
        }
      }
    } finally {
      _overlayAcceptBusy = false;
    }
  }

  Future<void> _handleOverlayIgnoreRide(Map<String, dynamic> data) async {
    if (_overlayIgnoreBusy) return;
    _overlayIgnoreBusy = true;

    try {
      var ctx = await _waitForNavigatorContext();
      ctx ??= navigatorKey.currentContext;

      if (ctx == null || !ctx.mounted) {
        _pendingOverlayIgnore = Map<String, dynamic>.from(data);
        debugPrint('overlay ignore: navigator not ready, will retry on resume');
        return;
      }

      final panel = data['panel'] as String? ?? 'driver';
      final orderId = (data['id'] as String? ?? '').isNotEmpty
          ? data['id'] as String
          : data['order_id'] as String? ?? '';

      if (orderId.isNotEmpty) {
        if (panel == 'serviceman') {
          Provider.of<IgnoreServiceOrderViewModel>(ctx, listen: false)
              .ignoreServiceOrderApi(int.parse(orderId), ctx);
        } else {
          Provider.of<DriverIgnoreOrderViewModel>(ctx, listen: false)
              .driverIgnoreOrderApi(orderId, ctx);
        }
      }
    } finally {
      _overlayIgnoreBusy = false;
    }
  }

  Future<void> _flushPendingOverlayIntents() async {
    final accept = _pendingOverlayAccept;
    if (accept != null) {
      _pendingOverlayAccept = null;
      await _handleOverlayAcceptRide(accept);
    }
    final ign = _pendingOverlayIgnore;
    if (ign != null) {
      _pendingOverlayIgnore = null;
      await _handleOverlayIgnoreRide(ign);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_flushPendingOverlayIntents());
    }

    final context = navigatorKey.currentContext;
    if (context != null) {
      final driverProfile =
      Provider.of<DriverProfileViewModel>(context, listen: false);
      final bool isDriverOnline =
          driverProfile.driverProfileModel?.data?.onlineStatus.toString() ==
              "1";

      final servicemanProfile =
      Provider.of<ServicemanProfileViewModel>(context, listen: false);
      final bool isServicemanOnline =
          servicemanProfile.servicemanProfileModel?.data?.onlineStatus == 1;

      final bool isOnline = isDriverOnline || isServicemanOnline;

      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.hidden) {
        if (isOnline) {
          _safeInvoke('showBackgroundButton');
        } else {
          _safeInvoke('hideBackgroundButton');
          _safeInvoke('cancelIncomingOrderOverlay');
        }
      } else if (state == AppLifecycleState.resumed ||
          state == AppLifecycleState.inactive) {
        _safeInvoke('hideBackgroundButton');
        _safeInvoke('cancelIncomingOrderOverlay');
      }
    }
  }

  Future<void> _safeInvoke(String method) async {
    try {
      await overlayChannel.invokeMethod<void>(method);
    } catch (_) {
    }
  }

  Future<void> _tryHandleLaunchRoute() async {
    try {
      final String? route =
      await overlayChannel.invokeMethod<String>('getLaunchRoute');
      if (route != null && route.isNotEmpty) {
        navigatorKey.currentState?.pushNamed(route);
      }
    } catch (_) {
    }
  }

  void _setupOverlayChannel() {
    overlayChannel.setMethodCallHandler((call) async {
      debugPrint("🔥 MethodChannel call received: ${call.method}");

      final data = call.arguments is Map
          ? Map<String, dynamic>.from(call.arguments as Map)
          : <String, dynamic>{};

      if (call.method == 'onOverlayAcceptRide') {
        debugPrint("🔥 FULL OVERLAY DATA: $data");
        await _handleOverlayAcceptRide(data);
      } else if (call.method == 'onOverlayIgnoreRide') {
        await _handleOverlayIgnoreRide(data);
      } else if (call.method == 'navigateTo') {
        final route = call.arguments as String?;
        if (route != null && route.isNotEmpty) {
          navigatorKey.currentState?.pushNamed(route);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _setupOverlayChannel();

    notificationService.requestedNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMassage(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _internetCheckerService.startMonitoring(navigatorKey.currentContext!);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryHandleLaunchRoute();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    topPadding = MediaQuery.of(context).padding.top;
    bottomPadding = MediaQuery.of(context).padding.bottom;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthViewModel()),
          ChangeNotifierProvider(create: (context) => UserViewModel()),
          ChangeNotifierProvider(
              create: (context) => ServicemanRegisterViewModel()),
          ChangeNotifierProvider(
              create: (context) => ServicemanProfileViewModel()),
          ChangeNotifierProvider(
              create: (context) => ServiceOnlineStatusViewModel()),
          ChangeNotifierProvider(
              create: (context) => AddBankDetailViewModel()),
          ChangeNotifierProvider(
              create: (context) => ServiceGetBankDetailViewModel()),
          ChangeNotifierProvider(
              create: (context) => ServiceBankEditViewModel()),
          ChangeNotifierProvider(
              create: (context) => ServiceBankUpdateViewModel()),
          ChangeNotifierProvider(create: (context) => DeviceViewModel()),
          ChangeNotifierProvider(create: (context) => CategoriesViewModel()),
          ChangeNotifierProvider(
              create: (context) => CompleteBookingViewModel()),
          ChangeNotifierProvider(create: (context) => JobRequestViewModel()),
          ChangeNotifierProvider(create: (context) => CitiesViewModel()),
          ChangeNotifierProvider(create: (context) => AcceptOrderViewModel()),
          ChangeNotifierProvider(
              create: (context) => ChangeOrderStatusViewModel()),
          ChangeNotifierProvider(
              create: (context) => TransactionHistoryViewModel()),
          ChangeNotifierProvider(
              create: (context) => WithdrawRequestViewModel()),
          ChangeNotifierProvider(
              create: (context) => ServiceWithdrawHistoryViewModel()),
          ChangeNotifierProvider(create: (context) => PaymentViewModel()),
          ChangeNotifierProvider(create: (context) => CallBackViewModel()),
          ChangeNotifierProvider(create: (context) => ReviewViewModel()),
          ChangeNotifierProvider(
              create: (context) => ServicemanEarningViewModel()),
          ChangeNotifierProvider(create: (context) => ServiceInfoViewModel()),
          ChangeNotifierProvider(create: (context) => ZoneCitiesViewModel()),
          ChangeNotifierProvider(
              create: (context) => CabCancelReasonViewModel()),
          ChangeNotifierProvider(
              create: (context) => IgnoreServiceOrderViewModel()),
          ChangeNotifierProvider(
              create: (context) => ChangeServicePayModeVm()),
          ChangeNotifierProvider(create: (context) => VehicleViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverRegisterOneViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverRegisterTwoViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverRegisterThreeViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverRegisterFourViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverRegisterFiveViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverRegisterSixViewModel()),
          ChangeNotifierProvider(create: (context) => VehicleBrandViewModel()),
          ChangeNotifierProvider(create: (context) => VehicleModelViewModel()),
          ChangeNotifierProvider(
              create: (context) => VehicleColorsViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverProfileViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverOnlineStatusViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverCanDiscountViewModel()),
          ChangeNotifierProvider(create: (context) => DriverOfferViewModel()),
          ChangeNotifierProvider(
              create: (context) => ChangeCabOrderStatusViewModel()),
          ChangeNotifierProvider(create: (context) => CabEarningViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverTransactionViewModel()),
          ChangeNotifierProvider(create: (context) => CabHistoryViewModel()),
          ChangeNotifierProvider(create: (context) => ActiveRideViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverIgnoreOrderViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverWithdrawRequestViewModel()),
          ChangeNotifierProvider(
              create: (context) => DriverWithdrawHistoryViewModel()),
          ChangeNotifierProvider(
              create: (context) => AcceptLaterRideViewModel()),
          ChangeNotifierProvider(
              create: (context) => PartnerNotificationViewModel()),
          ChangeNotifierProvider(create: (context) => PolicyViewModel()),
          ChangeNotifierProvider(create: (context) => HelpSupportViewModel()),
          ChangeNotifierProvider(create: (context) => VehicleFuelViewModel()),
          ChangeNotifierProvider(
              create: (context) => ChangeCabPayModeViewModel()),
          ChangeNotifierProvider(create: (context) => CabPaymentViewmodel()),
          ChangeNotifierProvider(create: (context) => LanguageController()),
          ChangeNotifierProvider(create: (context) => CheckPaymentStatusViewModel()),
          ChangeNotifierProvider(create: (context) => ServiceCheckPaymentStatusViewModel()),
        ],
        child: Consumer<LanguageController>(
            builder: (context, provider, child) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                initialRoute: RoutesName.splashScreen,
                onGenerateRoute: (settings) {
                  if (settings.name != null) {
                    return CupertinoPageRoute(
                      builder: Routers.generateRoute(settings.name!),
                      settings: settings,
                    );
                  }
                  return null;
                },
                title: 'Rainbow Partner',
                locale: provider.appLocale,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('hi'),
                ],
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
              );
            }
        ),
      ),
    );
  }
}
