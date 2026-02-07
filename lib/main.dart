import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/service/background_service.dart';
import 'package:rainbow_partner/service/internet_checker_service.dart';
import 'package:rainbow_partner/service/ride_notification_helper.dart';
import 'package:rainbow_partner/utils/routes/routes.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';
import 'package:rainbow_partner/view/Cab%20Driver/ride_waiting_screen.dart';
import 'package:rainbow_partner/view/service/notification_service.dart';
import 'package:rainbow_partner/view_model/auth_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/accept_later_ride_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/active_ride_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_cancel_reason_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_earning_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_history_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/change_cab_order_status_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/delete_expired_order_view_model.dart';
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
import 'package:rainbow_partner/view_model/service_man/city_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/complete_booking_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/driver_online_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/job_request_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/payment_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/review_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_bank_edit_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_bank_update_view_model.dart';
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
import 'firebase_options.dart';

String? fcmToken;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const MethodChannel nativeChannel =
MethodChannel('rainbow_partner/native_callback');


@pragma('vm:entry-point')
Future<void> handleNativeCallback(MethodCall call) async {
  WidgetsFlutterBinding.ensureInitialized();

  switch (call.method) {
    case 'onRideEvent':
      final Map<String, dynamic> data =
      Map<String, dynamic>.from(call.arguments);

      debugPrint("🚖 Ride Event from Native: $data");

      await RideNotificationHelper.showIncomingRide(data);
      break;

    default:
      debugPrint("⚠️ Unknown native callback");
  }
}




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  fcmToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print("✅ FCM Token: $fcmToken");
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  nativeChannel.setMethodCallHandler(handleNativeCallback);

  runApp(const MyApp());
}



double topPadding = 0.0;
double bottomPadding = 0.0;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final InternetCheckerService _internetCheckerService =
  InternetCheckerService();
  final notificationService = NotificationService(navigatorKey: navigatorKey);

  Future<void> _startSocket() async {
    final userViewModel = UserViewModel();

    String? driverId = await userViewModel.getUser();

    if (driverId == null || driverId == 0) {
      debugPrint("❌ Driver ID not found, socket not started");
      return;
    }

    debugPrint("✅ Starting socket with driverId: $driverId");

    // Background service start
    initializeBackgroundService();

  }
  late final StreamSubscription rideActionSub;

  @override
  void initState() {
    super.initState();

    RideNotificationHelper.init();
    rideActionSub = RideNotificationHelper.actionStream.listen((action) async {
      if (action.type == ActionType.accept) {
        print("🚕 ACCEPT tapped");
        print("📦 Booking data: ${action.bookingData}");
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => RideWaitingScreen()),
        );

        // TODO later:
        // acceptRideApi(...)
      }

      if (action.type == ActionType.reject) {
        print("❌ REJECT tapped");
        print("📦 Booking data: ${action.bookingData}");

        final orderId = action.bookingData['order_id'];

        if (orderId == null) {
          print("❌ Order ID missing");
          return;
        }

        // 🔥 CALL IGNORE API
        final context = navigatorKey.currentContext;

        if (context == null) {
          print("❌ Context not available");
          return;
        }

        final ignoreVm =
        Provider.of<DriverIgnoreOrderViewModel>(context, listen: false);

        await ignoreVm.driverIgnoreOrderApi(
          orderId,
          context,
        );

        print("✅ IGNORE API CALLED FOR ORDER: $orderId");
      }
    });


    notificationService.requestedNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMassage(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _internetCheckerService.startMonitoring(navigatorKey.currentContext!);
      _startSocket();
    });
  }

  @override
  void dispose() {
    rideActionSub.cancel();
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
          ChangeNotifierProvider(create: (context)=>AuthViewModel()),
          ChangeNotifierProvider(create: (context)=>UserViewModel()),
          ChangeNotifierProvider(create: (context)=> ServicemanRegisterViewModel()),
          ChangeNotifierProvider(create: (context)=> ServicemanProfileViewModel()),
          ChangeNotifierProvider(create: (context)=> ServiceOnlineStatusViewModel()),
          ChangeNotifierProvider(create: (context)=> ServiceOnlineStatusViewModel()),
          ChangeNotifierProvider(create: (context)=> AddBankDetailViewModel()),
          ChangeNotifierProvider(create: (context)=> ServiceGetBankDetailViewModel()),
          ChangeNotifierProvider(create: (context)=> ServiceBankEditViewModel()),
          ChangeNotifierProvider(create: (context)=> ServiceBankUpdateViewModel()),
          ChangeNotifierProvider(create: (context)=> DeviceViewModel()),
          ChangeNotifierProvider(create: (context)=> CategoriesViewModel()),
          ChangeNotifierProvider(create: (context)=> CompleteBookingViewModel()),
          ChangeNotifierProvider(create: (context)=> JobRequestViewModel()),
          ChangeNotifierProvider(create: (context)=> CitiesViewModel()),
          ChangeNotifierProvider(create: (context)=> AcceptOrderViewModel()),
          ChangeNotifierProvider(create: (context)=> ChangeOrderStatusViewModel()),
          ChangeNotifierProvider(create: (context)=> TransactionHistoryViewModel()),
          ChangeNotifierProvider(create: (context)=> WithdrawRequestViewModel()),
          ChangeNotifierProvider(create: (context)=> ServiceWithdrawHistoryViewModel()),
          ChangeNotifierProvider(create: (context)=> PaymentViewModel()),
          ChangeNotifierProvider(create: (context)=> CallBackViewModel()),
          ChangeNotifierProvider(create: (context)=> ReviewViewModel()),
          ChangeNotifierProvider(create: (context)=> ServicemanEarningViewModel()),
          ChangeNotifierProvider(create: (context)=> ServiceInfoViewModel()),
          ChangeNotifierProvider(create: (context)=> ZoneCitiesViewModel()),
          ChangeNotifierProvider(create: (context)=> CabCancelReasonViewModel()),

          /// cab Driver
          ChangeNotifierProvider(create: (context)=> VehicleViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverRegisterOneViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverRegisterTwoViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverRegisterThreeViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverRegisterFourViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverRegisterFiveViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverRegisterSixViewModel()),
          ChangeNotifierProvider(create: (context)=> VehicleBrandViewModel()),
          ChangeNotifierProvider(create: (context)=> VehicleModelViewModel()),
          ChangeNotifierProvider(create: (context)=> VehicleColorsViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverProfileViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverOnlineStatusViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverCanDiscountViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverOfferViewModel()),
          ChangeNotifierProvider(create: (context)=> DeleteExpiredOrderViewModel()),
          ChangeNotifierProvider(create: (context)=> ChangeCabOrderStatusViewModel()),
          ChangeNotifierProvider(create: (context)=> CabEarningViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverTransactionViewModel()),
          ChangeNotifierProvider(create: (context)=> CabHistoryViewModel()),
          ChangeNotifierProvider(create: (context)=> ActiveRideViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverIgnoreOrderViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverWithdrawRequestViewModel()),
          ChangeNotifierProvider(create: (context)=> DriverWithdrawHistoryViewModel()),
          ChangeNotifierProvider(create: (context)=> AcceptLaterRideViewModel()),
          ChangeNotifierProvider(create: (context)=> PartnerNotificationViewModel()),
          ChangeNotifierProvider(create: (context)=> PolicyViewModel()),
          ChangeNotifierProvider(create: (context)=> HelpSupportViewModel()),

        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: RoutesName.splashScreen,
          onGenerateRoute: (settings){
            if (settings.name !=null){
              return CupertinoPageRoute(builder: Routers.generateRoute(settings.name!),
                settings: settings,
              );
            }
            return null;
          },
          title: 'rainboW Partner',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}


