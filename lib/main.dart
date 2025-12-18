import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/utils/routes/routes.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';
import 'package:rainbow_partner/view/service/notification_service.dart';
import 'package:rainbow_partner/view_model/auth_view_model.dart';
import 'package:rainbow_partner/view_model/device_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/accept_order_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/add_bank_detail_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/call_back_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/categories_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/change_order_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/city_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/complete_booking_view_model.dart';
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
import 'package:rainbow_partner/view_model/service_man/withdraw_request_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';
import 'firebase_options.dart';

String? fcmToken;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // 🔹 Get FCM Token
  fcmToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print("✅ FCM Token: $fcmToken");
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //

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
  final notificationService = NotificationService(navigatorKey: navigatorKey);

  @override
  void initState() {
    super.initState();
    notificationService.requestedNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMassage(context);
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
        ],
        child: MaterialApp(
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


