import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/utils/routes/routes.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';
import 'package:rainbow_partner/view_model/auth_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/add_bank_detail_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_online_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_register_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FilePicker.platform;
  runApp(const MyApp());
}

double topPadding = 0.0;
double bottomPadding = 0.0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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


