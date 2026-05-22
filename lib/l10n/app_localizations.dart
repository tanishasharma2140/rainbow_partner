import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @join_us_via.
  ///
  /// In en, this message translates to:
  /// **'Join us via phone number'**
  String get join_us_via;

  /// No description provided for @we_will_text.
  ///
  /// In en, this message translates to:
  /// **'We’ll text a code to verify your phone'**
  String get we_will_text;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @please_enter_valid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit mobile number'**
  String get please_enter_valid;

  /// No description provided for @please_enter_valid_four.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 4-digit OTP.'**
  String get please_enter_valid_four;

  /// No description provided for @enter_the_code.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get enter_the_code;

  /// No description provided for @we_sent_your_code.
  ///
  /// In en, this message translates to:
  /// **'We sent your code via SMS to'**
  String get we_sent_your_code;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resend_code;

  /// No description provided for @choose_your_profile.
  ///
  /// In en, this message translates to:
  /// **'Choose your profile'**
  String get choose_your_profile;

  /// No description provided for @please_note_one_profile.
  ///
  /// In en, this message translates to:
  /// **'*Please Note : One mobile number one Profile'**
  String get please_note_one_profile;

  /// No description provided for @rainbow_driver.
  ///
  /// In en, this message translates to:
  /// **'rainboW Driver'**
  String get rainbow_driver;

  /// No description provided for @rainbow_driver_description.
  ///
  /// In en, this message translates to:
  /// **'Drive customers safely with real-time navigation and trip updates.'**
  String get rainbow_driver_description;

  /// No description provided for @service_man.
  ///
  /// In en, this message translates to:
  /// **'Service Man'**
  String get service_man;

  /// No description provided for @service_man_description.
  ///
  /// In en, this message translates to:
  /// **'Provide on-demand home services at customer\'s location.'**
  String get service_man_description;

  /// No description provided for @need_a_job.
  ///
  /// In en, this message translates to:
  /// **'Need a Job'**
  String get need_a_job;

  /// No description provided for @need_a_job_description.
  ///
  /// In en, this message translates to:
  /// **'Offer professional repair, installation and maintenance services.'**
  String get need_a_job_description;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personal_information;

  /// No description provided for @select_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get select_from_gallery;

  /// No description provided for @take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get take_photo;

  /// No description provided for @personal_picture.
  ///
  /// In en, this message translates to:
  /// **'Personal picture'**
  String get personal_picture;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get date_of_birth;

  /// No description provided for @please_select_personal_picture.
  ///
  /// In en, this message translates to:
  /// **'Please select personal picture'**
  String get please_select_personal_picture;

  /// No description provided for @please_enter_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get please_enter_name;

  /// No description provided for @please_enter_surname.
  ///
  /// In en, this message translates to:
  /// **'Please enter surname'**
  String get please_enter_surname;

  /// No description provided for @please_select_date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Please select date of birth'**
  String get please_select_date_of_birth;

  /// No description provided for @driver_license.
  ///
  /// In en, this message translates to:
  /// **'Driver license'**
  String get driver_license;

  /// No description provided for @driver_license_front.
  ///
  /// In en, this message translates to:
  /// **'Driver license\n(front)'**
  String get driver_license_front;

  /// No description provided for @driver_license_back.
  ///
  /// In en, this message translates to:
  /// **'Driver license\n(back side)'**
  String get driver_license_back;

  /// No description provided for @validity_date.
  ///
  /// In en, this message translates to:
  /// **'Validity date'**
  String get validity_date;

  /// No description provided for @please_upload_license_front_image.
  ///
  /// In en, this message translates to:
  /// **'Please upload license front image'**
  String get please_upload_license_front_image;

  /// No description provided for @please_upload_license_back_image.
  ///
  /// In en, this message translates to:
  /// **'Please upload license back image'**
  String get please_upload_license_back_image;

  /// No description provided for @please_enter_license_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter license number'**
  String get please_enter_license_number;

  /// No description provided for @please_enter_valid_license_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid license number'**
  String get please_enter_valid_license_number;

  /// No description provided for @please_select_validity_date.
  ///
  /// In en, this message translates to:
  /// **'Please select validity date'**
  String get please_select_validity_date;

  /// No description provided for @driver_license_number.
  ///
  /// In en, this message translates to:
  /// **'Driver license number'**
  String get driver_license_number;

  /// No description provided for @invalid_license_example.
  ///
  /// In en, this message translates to:
  /// **'Invalid license (example: MH12AB1234567)'**
  String get invalid_license_example;

  /// No description provided for @aadhaar_card.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Card'**
  String get aadhaar_card;

  /// No description provided for @aadhaar_front_side.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar\nFront Side'**
  String get aadhaar_front_side;

  /// No description provided for @aadhaar_back_side.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar\nBack Side'**
  String get aadhaar_back_side;

  /// No description provided for @aadhaar_number.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Number'**
  String get aadhaar_number;

  /// No description provided for @pan_card.
  ///
  /// In en, this message translates to:
  /// **'PAN Card'**
  String get pan_card;

  /// No description provided for @pan_card_front_side.
  ///
  /// In en, this message translates to:
  /// **'PAN Card\nFront Side'**
  String get pan_card_front_side;

  /// No description provided for @pan_number.
  ///
  /// In en, this message translates to:
  /// **'PAN Number'**
  String get pan_number;

  /// No description provided for @please_upload_aadhaar_front_side.
  ///
  /// In en, this message translates to:
  /// **'Please upload Aadhaar front side'**
  String get please_upload_aadhaar_front_side;

  /// No description provided for @please_upload_aadhaar_back_side.
  ///
  /// In en, this message translates to:
  /// **'Please upload Aadhaar back side'**
  String get please_upload_aadhaar_back_side;

  /// No description provided for @please_enter_aadhaar_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter Aadhaar number'**
  String get please_enter_aadhaar_number;

  /// No description provided for @please_upload_pan_card_front_side.
  ///
  /// In en, this message translates to:
  /// **'Please upload PAN card front side'**
  String get please_upload_pan_card_front_side;

  /// No description provided for @please_enter_pan_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter PAN number'**
  String get please_enter_pan_number;

  /// No description provided for @vehicle_information.
  ///
  /// In en, this message translates to:
  /// **'Vehicle information'**
  String get vehicle_information;

  /// No description provided for @please_upload_vehicle_photo.
  ///
  /// In en, this message translates to:
  /// **'Please upload vehicle photo'**
  String get please_upload_vehicle_photo;

  /// No description provided for @please_select_vehicle_brand.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle brand'**
  String get please_select_vehicle_brand;

  /// No description provided for @please_select_vehicle_model.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle model'**
  String get please_select_vehicle_model;

  /// No description provided for @please_select_vehicle_color.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle color'**
  String get please_select_vehicle_color;

  /// No description provided for @please_enter_vehicle_plate_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter vehicle plate number'**
  String get please_enter_vehicle_plate_number;

  /// No description provided for @please_enter_valid_vehicle_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid vehicle number'**
  String get please_enter_valid_vehicle_number;

  /// No description provided for @please_select_vehicle_production_year.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle production year'**
  String get please_select_vehicle_production_year;

  /// No description provided for @select_production_year.
  ///
  /// In en, this message translates to:
  /// **'Select Production Year'**
  String get select_production_year;

  /// No description provided for @vehicle_brand.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Brand'**
  String get vehicle_brand;

  /// No description provided for @no_brands_found.
  ///
  /// In en, this message translates to:
  /// **'No brands found'**
  String get no_brands_found;

  /// No description provided for @please_select_vehicle_brand_first.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle brand first!'**
  String get please_select_vehicle_brand_first;

  /// No description provided for @vehicle_model.
  ///
  /// In en, this message translates to:
  /// **'Vehicle model'**
  String get vehicle_model;

  /// No description provided for @no_models_found.
  ///
  /// In en, this message translates to:
  /// **'No models found'**
  String get no_models_found;

  /// No description provided for @vehicle_color.
  ///
  /// In en, this message translates to:
  /// **'Vehicle color'**
  String get vehicle_color;

  /// No description provided for @fuel_type.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuel_type;

  /// No description provided for @no_fuel_types_found.
  ///
  /// In en, this message translates to:
  /// **'No fuel types found'**
  String get no_fuel_types_found;

  /// No description provided for @photo_of_your_vehicle.
  ///
  /// In en, this message translates to:
  /// **'Photo of your\nvehicle'**
  String get photo_of_your_vehicle;

  /// No description provided for @vehicle_brand_hint.
  ///
  /// In en, this message translates to:
  /// **'Vehicle brand'**
  String get vehicle_brand_hint;

  /// No description provided for @vehicle_model_hint.
  ///
  /// In en, this message translates to:
  /// **'Vehicle model'**
  String get vehicle_model_hint;

  /// No description provided for @vehicle_color_hint.
  ///
  /// In en, this message translates to:
  /// **'Vehicle color'**
  String get vehicle_color_hint;

  /// No description provided for @fuel_type_hint.
  ///
  /// In en, this message translates to:
  /// **'Fuel type'**
  String get fuel_type_hint;

  /// No description provided for @vehicle_number.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Number'**
  String get vehicle_number;

  /// No description provided for @vehicle_production_year.
  ///
  /// In en, this message translates to:
  /// **'Vehicle production year'**
  String get vehicle_production_year;

  /// No description provided for @enter_valid_vehicle_number.
  ///
  /// In en, this message translates to:
  /// **'Enter valid vehicle number'**
  String get enter_valid_vehicle_number;

  /// No description provided for @upload_required_certificates.
  ///
  /// In en, this message translates to:
  /// **'Upload Required Certificates'**
  String get upload_required_certificates;

  /// No description provided for @fitness_certificate.
  ///
  /// In en, this message translates to:
  /// **'Fitness\nCertificate'**
  String get fitness_certificate;

  /// No description provided for @pollution_certificate_optional.
  ///
  /// In en, this message translates to:
  /// **'Pollution (PUC)\nCertificate\n(Optional)'**
  String get pollution_certificate_optional;

  /// No description provided for @insurance_certificate.
  ///
  /// In en, this message translates to:
  /// **'Insurance Certificate'**
  String get insurance_certificate;

  /// No description provided for @police_verification_certificate_optional.
  ///
  /// In en, this message translates to:
  /// **'Police Verification\nCertificate\n(Optional)'**
  String get police_verification_certificate_optional;

  /// No description provided for @upload_pdf_document.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF Document'**
  String get upload_pdf_document;

  /// No description provided for @choose_image_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose Image From Gallery'**
  String get choose_image_from_gallery;

  /// No description provided for @please_upload_all_required_certificates.
  ///
  /// In en, this message translates to:
  /// **'Please upload all required certificates'**
  String get please_upload_all_required_certificates;

  /// No description provided for @vehicle_documents.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Documents'**
  String get vehicle_documents;

  /// No description provided for @vehicle_permit_part_a.
  ///
  /// In en, this message translates to:
  /// **'Vehicle permit -\npart A'**
  String get vehicle_permit_part_a;

  /// No description provided for @vehicle_permit_part_b.
  ///
  /// In en, this message translates to:
  /// **'Vehicle permit -\npart B'**
  String get vehicle_permit_part_b;

  /// No description provided for @vehicle_registration_certificate.
  ///
  /// In en, this message translates to:
  /// **'Vehicle registration certificate'**
  String get vehicle_registration_certificate;

  /// No description provided for @back_side_of_registration_certificate.
  ///
  /// In en, this message translates to:
  /// **'Back side of\nregistration certificate'**
  String get back_side_of_registration_certificate;

  /// No description provided for @choose_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose From Gallery'**
  String get choose_from_gallery;

  /// No description provided for @take_a_photo.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get take_a_photo;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @please_upload_all_required_vehicle_documents.
  ///
  /// In en, this message translates to:
  /// **'Please upload all required vehicle documents'**
  String get please_upload_all_required_vehicle_documents;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @verification_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Verification in Progress'**
  String get verification_in_progress;

  /// No description provided for @verification_in_progress_description.
  ///
  /// In en, this message translates to:
  /// **'We\'re currently reviewing your documents.\nYou\'ll be notified once completed.'**
  String get verification_in_progress_description;

  /// No description provided for @pending_verification.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification'**
  String get pending_verification;

  /// No description provided for @documents_verified.
  ///
  /// In en, this message translates to:
  /// **'Documents Verified'**
  String get documents_verified;

  /// No description provided for @documents_verified_description.
  ///
  /// In en, this message translates to:
  /// **'You are ready to accept ride requests'**
  String get documents_verified_description;

  /// No description provided for @verification_rejected.
  ///
  /// In en, this message translates to:
  /// **'Verification Rejected'**
  String get verification_rejected;

  /// No description provided for @verification_rejected_description.
  ///
  /// In en, this message translates to:
  /// **'Some documents were rejected. Please fix them to continue.'**
  String get verification_rejected_description;

  /// No description provided for @fix_documents.
  ///
  /// In en, this message translates to:
  /// **'Fix Documents'**
  String get fix_documents;

  /// No description provided for @go_to_setup.
  ///
  /// In en, this message translates to:
  /// **'Go to setup'**
  String get go_to_setup;

  /// No description provided for @choose_your_vehicle.
  ///
  /// In en, this message translates to:
  /// **'Choose your vehicle'**
  String get choose_your_vehicle;

  /// No description provided for @no_vehicle_found.
  ///
  /// In en, this message translates to:
  /// **'No vehicle found'**
  String get no_vehicle_found;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcome_back;

  /// No description provided for @rides.
  ///
  /// In en, this message translates to:
  /// **'Rides'**
  String get rides;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @quick_actions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quick_actions;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @wallet_settlement.
  ///
  /// In en, this message translates to:
  /// **'Wallet Settlement'**
  String get wallet_settlement;

  /// No description provided for @add_bank.
  ///
  /// In en, this message translates to:
  /// **'Add Bank'**
  String get add_bank;

  /// No description provided for @bank_update_status.
  ///
  /// In en, this message translates to:
  /// **'Bank Update Status'**
  String get bank_update_status;

  /// No description provided for @ride_history_schedule_booking.
  ///
  /// In en, this message translates to:
  /// **'Ride History & Schedule Booking'**
  String get ride_history_schedule_booking;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @overlay_permission.
  ///
  /// In en, this message translates to:
  /// **'Overlay Permission'**
  String get overlay_permission;

  /// No description provided for @enable_display_over_apps.
  ///
  /// In en, this message translates to:
  /// **'Enable Display over other apps to continue.'**
  String get enable_display_over_apps;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @overlay_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Overlay permission is required'**
  String get overlay_permission_required;

  /// No description provided for @you_are_online_now.
  ///
  /// In en, this message translates to:
  /// **'You are online now'**
  String get you_are_online_now;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @you_are_offline_now.
  ///
  /// In en, this message translates to:
  /// **'You are offline now'**
  String get you_are_offline_now;

  /// No description provided for @foreground_location_access_permissions_required.
  ///
  /// In en, this message translates to:
  /// **'Foreground Location Access Permissions Required'**
  String get foreground_location_access_permissions_required;

  /// No description provided for @location_permission_description.
  ///
  /// In en, this message translates to:
  /// **'This app collects your location even when the app is closed or not in use to enable ride matching, show nearby ride requests, and keep you available while you are online as a driver.'**
  String get location_permission_description;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @location_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required'**
  String get location_permission_required;

  /// No description provided for @ride_ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ride ongoing'**
  String get ride_ongoing;

  /// No description provided for @drive_safely.
  ///
  /// In en, this message translates to:
  /// **'You\'re on duty — drive safely!'**
  String get drive_safely;

  /// No description provided for @exit_app.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exit_app;

  /// No description provided for @are_you_sure_exit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get are_you_sure_exit;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @earnings_report.
  ///
  /// In en, this message translates to:
  /// **'Earnings Report'**
  String get earnings_report;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @total_earnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get total_earnings;

  /// No description provided for @trips_completed.
  ///
  /// In en, this message translates to:
  /// **'Trips Completed'**
  String get trips_completed;

  /// No description provided for @online_hours.
  ///
  /// In en, this message translates to:
  /// **'Online Hours'**
  String get online_hours;

  /// No description provided for @no_trips_found.
  ///
  /// In en, this message translates to:
  /// **'No trips found'**
  String get no_trips_found;

  /// No description provided for @trip_details.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get trip_details;

  /// No description provided for @trip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get trip;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @drop.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get drop;

  /// No description provided for @driver_profile.
  ///
  /// In en, this message translates to:
  /// **'Driver Profile'**
  String get driver_profile;

  /// No description provided for @driver_photo.
  ///
  /// In en, this message translates to:
  /// **'Driver Photo'**
  String get driver_photo;

  /// No description provided for @personal_details.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personal_details;

  /// No description provided for @mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobile_number;

  /// No description provided for @driving_license.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get driving_license;

  /// No description provided for @front_side.
  ///
  /// In en, this message translates to:
  /// **'Front Side'**
  String get front_side;

  /// No description provided for @back_side.
  ///
  /// In en, this message translates to:
  /// **'Back Side'**
  String get back_side;

  /// No description provided for @license_number.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get license_number;

  /// No description provided for @vehicle_details.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicle_details;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @plate_number.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plate_number;

  /// No description provided for @production_year.
  ///
  /// In en, this message translates to:
  /// **'Production Year'**
  String get production_year;

  /// No description provided for @vehicle_photo.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photo'**
  String get vehicle_photo;

  /// No description provided for @rc_front.
  ///
  /// In en, this message translates to:
  /// **'RC Front'**
  String get rc_front;

  /// No description provided for @rc_back.
  ///
  /// In en, this message translates to:
  /// **'RC Back'**
  String get rc_back;

  /// No description provided for @permit_part_a.
  ///
  /// In en, this message translates to:
  /// **'Permit Part A'**
  String get permit_part_a;

  /// No description provided for @permit_part_b.
  ///
  /// In en, this message translates to:
  /// **'Permit Part B'**
  String get permit_part_b;

  /// No description provided for @certificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get certificates;

  /// No description provided for @rc_certificate.
  ///
  /// In en, this message translates to:
  /// **'RC Certificate'**
  String get rc_certificate;

  /// No description provided for @pollution_certificate.
  ///
  /// In en, this message translates to:
  /// **'Pollution Certificate'**
  String get pollution_certificate;

  /// No description provided for @police_verification.
  ///
  /// In en, this message translates to:
  /// **'Police Verification'**
  String get police_verification;

  /// No description provided for @view_pdf.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get view_pdf;

  /// No description provided for @are_you_sure_logout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get are_you_sure_logout;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @wallet_settlements.
  ///
  /// In en, this message translates to:
  /// **'Wallet & Settlements'**
  String get wallet_settlements;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @due_wallet.
  ///
  /// In en, this message translates to:
  /// **'Due Wallet'**
  String get due_wallet;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @recent_transactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recent_transactions;

  /// No description provided for @no_transactions_found.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get no_transactions_found;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @platform_fee.
  ///
  /// In en, this message translates to:
  /// **'Platform Fee'**
  String get platform_fee;

  /// No description provided for @final_amount.
  ///
  /// In en, this message translates to:
  /// **'Final Amount'**
  String get final_amount;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @txn_id.
  ///
  /// In en, this message translates to:
  /// **'Txn ID'**
  String get txn_id;

  /// No description provided for @online_payment.
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get online_payment;

  /// No description provided for @cash_payment.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment'**
  String get cash_payment;

  /// No description provided for @wallet_payment.
  ///
  /// In en, this message translates to:
  /// **'Wallet Payment'**
  String get wallet_payment;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @due_cleared.
  ///
  /// In en, this message translates to:
  /// **'Due Cleared'**
  String get due_cleared;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @after_fee.
  ///
  /// In en, this message translates to:
  /// **'After Fee'**
  String get after_fee;

  /// No description provided for @cash_in.
  ///
  /// In en, this message translates to:
  /// **'Cash In'**
  String get cash_in;

  /// No description provided for @due_paid.
  ///
  /// In en, this message translates to:
  /// **'Due Paid'**
  String get due_paid;

  /// No description provided for @withdraw_funds.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Funds'**
  String get withdraw_funds;

  /// No description provided for @available_balance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get available_balance;

  /// No description provided for @enter_amount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enter_amount;

  /// No description provided for @no_bank_account_added.
  ///
  /// In en, this message translates to:
  /// **'No bank account added. Please add a bank account first.'**
  String get no_bank_account_added;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @due_wallet_payment.
  ///
  /// In en, this message translates to:
  /// **'Due Wallet Payment'**
  String get due_wallet_payment;

  /// No description provided for @due_wallet_balance.
  ///
  /// In en, this message translates to:
  /// **'Due Wallet Balance'**
  String get due_wallet_balance;

  /// No description provided for @pay_full_due_wallet.
  ///
  /// In en, this message translates to:
  /// **'You need to pay the full due wallet amount.'**
  String get pay_full_due_wallet;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @pay_now.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get pay_now;

  /// No description provided for @add_bank_account.
  ///
  /// In en, this message translates to:
  /// **'Add Bank Account'**
  String get add_bank_account;

  /// No description provided for @bank_account_information.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Information'**
  String get bank_account_information;

  /// No description provided for @bank_name.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bank_name;

  /// No description provided for @enter_bank_name.
  ///
  /// In en, this message translates to:
  /// **'Enter bank name'**
  String get enter_bank_name;

  /// No description provided for @account_holder_name.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get account_holder_name;

  /// No description provided for @enter_full_name_bank_records.
  ///
  /// In en, this message translates to:
  /// **'Enter full name as per bank records'**
  String get enter_full_name_bank_records;

  /// No description provided for @account_number.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get account_number;

  /// No description provided for @enter_account_number.
  ///
  /// In en, this message translates to:
  /// **'Enter Account Number'**
  String get enter_account_number;

  /// No description provided for @confirm_account_number.
  ///
  /// In en, this message translates to:
  /// **'Confirm Account Number'**
  String get confirm_account_number;

  /// No description provided for @re_enter_account_number.
  ///
  /// In en, this message translates to:
  /// **'Re-enter Account Number'**
  String get re_enter_account_number;

  /// No description provided for @ifsc_code.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifsc_code;

  /// No description provided for @enter_ifsc_code.
  ///
  /// In en, this message translates to:
  /// **'Enter IFSC Code'**
  String get enter_ifsc_code;

  /// No description provided for @add_bank_account_button.
  ///
  /// In en, this message translates to:
  /// **'ADD BANK ACCOUNT'**
  String get add_bank_account_button;

  /// No description provided for @your_bank_details_secure.
  ///
  /// In en, this message translates to:
  /// **'Your bank details are secure and encrypted'**
  String get your_bank_details_secure;

  /// No description provided for @bank_details.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bank_details;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @no_bank_details_found.
  ///
  /// In en, this message translates to:
  /// **'No bank details found'**
  String get no_bank_details_found;

  /// No description provided for @bank_account_verified.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Verified'**
  String get bank_account_verified;

  /// No description provided for @your_account_ready_withdrawals.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready for withdrawals'**
  String get your_account_ready_withdrawals;

  /// No description provided for @edit_bank_details.
  ///
  /// In en, this message translates to:
  /// **'Edit Bank Details'**
  String get edit_bank_details;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @no_update_request_found.
  ///
  /// In en, this message translates to:
  /// **'No update request found'**
  String get no_update_request_found;

  /// No description provided for @request_status.
  ///
  /// In en, this message translates to:
  /// **'Request Status'**
  String get request_status;

  /// No description provided for @account_holder.
  ///
  /// In en, this message translates to:
  /// **'Account Holder'**
  String get account_holder;

  /// No description provided for @requested_on.
  ///
  /// In en, this message translates to:
  /// **'Requested On'**
  String get requested_on;

  /// No description provided for @updated_on.
  ///
  /// In en, this message translates to:
  /// **'Updated On'**
  String get updated_on;

  /// No description provided for @not_updated_yet.
  ///
  /// In en, this message translates to:
  /// **'Not updated yet'**
  String get not_updated_yet;

  /// No description provided for @bank_update_request.
  ///
  /// In en, this message translates to:
  /// **'Bank Update Request'**
  String get bank_update_request;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @ride_history.
  ///
  /// In en, this message translates to:
  /// **'Ride History'**
  String get ride_history;

  /// No description provided for @no_rides_found.
  ///
  /// In en, this message translates to:
  /// **'No rides found'**
  String get no_rides_found;

  /// No description provided for @no_scheduled_rides_found.
  ///
  /// In en, this message translates to:
  /// **'No scheduled rides found'**
  String get no_scheduled_rides_found;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @unknown_user.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknown_user;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @fare.
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get fare;

  /// No description provided for @cancellation_reason.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get cancellation_reason;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @start_ride.
  ///
  /// In en, this message translates to:
  /// **'Start Ride'**
  String get start_ride;

  /// No description provided for @verify_ride_otp.
  ///
  /// In en, this message translates to:
  /// **'Verify Ride OTP'**
  String get verify_ride_otp;

  /// No description provided for @enter_customer_otp_start_ride.
  ///
  /// In en, this message translates to:
  /// **'Enter customer OTP to start the ride'**
  String get enter_customer_otp_start_ride;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @scheduled_ride.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Ride'**
  String get scheduled_ride;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled_by_user.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by User'**
  String get cancelled_by_user;

  /// No description provided for @cancelled_by_me.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by Me'**
  String get cancelled_by_me;

  /// No description provided for @booking_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed'**
  String get booking_confirmed;

  /// No description provided for @driver_on_way.
  ///
  /// In en, this message translates to:
  /// **'Driver On Way'**
  String get driver_on_way;

  /// No description provided for @ride_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Ride in progress'**
  String get ride_in_progress;

  /// No description provided for @cancelled_by_driver.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by Driver'**
  String get cancelled_by_driver;

  /// No description provided for @pending_waiting.
  ///
  /// In en, this message translates to:
  /// **'Pending / Waiting'**
  String get pending_waiting;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @ride_alerts_app_notifications.
  ///
  /// In en, this message translates to:
  /// **'Ride alerts & app notifications'**
  String get ride_alerts_app_notifications;

  /// No description provided for @help_support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help_support;

  /// No description provided for @for_help_support.
  ///
  /// In en, this message translates to:
  /// **'For Help & Support'**
  String get for_help_support;

  /// No description provided for @terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_conditions;

  /// No description provided for @read_terms_service.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get read_terms_service;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @how_we_use_data.
  ///
  /// In en, this message translates to:
  /// **'How we use your data'**
  String get how_we_use_data;

  /// No description provided for @refund_policy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get refund_policy;

  /// No description provided for @read_refund_cancellation_policy.
  ///
  /// In en, this message translates to:
  /// **'Read our refund & Cancellation policy'**
  String get read_refund_cancellation_policy;

  /// No description provided for @service_description.
  ///
  /// In en, this message translates to:
  /// **'Service Description'**
  String get service_description;

  /// No description provided for @read_service_description.
  ///
  /// In en, this message translates to:
  /// **'Read our service description'**
  String get read_service_description;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contact_us;

  /// No description provided for @reach_out_help_support.
  ///
  /// In en, this message translates to:
  /// **'Reach out for help and support'**
  String get reach_out_help_support;

  /// No description provided for @about_us.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get about_us;

  /// No description provided for @know_more_services.
  ///
  /// In en, this message translates to:
  /// **'Know more about our services'**
  String get know_more_services;

  /// No description provided for @you_are_all_up_to_date.
  ///
  /// In en, this message translates to:
  /// **'You are all up to date'**
  String get you_are_all_up_to_date;

  /// No description provided for @no_new_notifications_come_back_soon.
  ///
  /// In en, this message translates to:
  /// **'No new notifications — come back soon'**
  String get no_new_notifications_come_back_soon;

  /// No description provided for @need_help_services.
  ///
  /// In en, this message translates to:
  /// **'Need help with services?'**
  String get need_help_services;

  /// No description provided for @help_support_description.
  ///
  /// In en, this message translates to:
  /// **'If you are facing issues related to adding, updating, or managing your services, we are here to help.\n\nOur support team is always available.'**
  String get help_support_description;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support;

  /// No description provided for @need_quick_support.
  ///
  /// In en, this message translates to:
  /// **'Need Quick Support?'**
  String get need_quick_support;

  /// No description provided for @terms_and_condition.
  ///
  /// In en, this message translates to:
  /// **'Terms and Condition'**
  String get terms_and_condition;

  /// No description provided for @no_data_found.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get no_data_found;

  /// No description provided for @searching_ride.
  ///
  /// In en, this message translates to:
  /// **'Searching Ride'**
  String get searching_ride;

  /// No description provided for @loading_driver_profile.
  ///
  /// In en, this message translates to:
  /// **'Loading driver profile...'**
  String get loading_driver_profile;

  /// No description provided for @waiting_for_ride.
  ///
  /// In en, this message translates to:
  /// **'Waiting for ride...'**
  String get waiting_for_ride;

  /// No description provided for @please_stay_online.
  ///
  /// In en, this message translates to:
  /// **'Please stay online'**
  String get please_stay_online;

  /// No description provided for @error_loading_rides.
  ///
  /// In en, this message translates to:
  /// **'Error loading rides'**
  String get error_loading_rides;

  /// No description provided for @new_ride_requests.
  ///
  /// In en, this message translates to:
  /// **'New Ride Requests'**
  String get new_ride_requests;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @passenger_note.
  ///
  /// In en, this message translates to:
  /// **'Passenger Note'**
  String get passenger_note;

  /// No description provided for @estimated_amount.
  ///
  /// In en, this message translates to:
  /// **'Estimated Amount'**
  String get estimated_amount;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @invalid_offer_amount.
  ///
  /// In en, this message translates to:
  /// **'Invalid offer amount'**
  String get invalid_offer_amount;

  /// No description provided for @ride_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Ride Cancelled'**
  String get ride_cancelled;

  /// No description provided for @user_has_cancelled_this_ride.
  ///
  /// In en, this message translates to:
  /// **'User has cancelled this ride'**
  String get user_has_cancelled_this_ride;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @payment_successful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get payment_successful;

  /// No description provided for @customer_has_completed_the_payment.
  ///
  /// In en, this message translates to:
  /// **'Customer has completed the payment'**
  String get customer_has_completed_the_payment;

  /// No description provided for @ride_completed.
  ///
  /// In en, this message translates to:
  /// **'Ride Completed'**
  String get ride_completed;

  /// No description provided for @thank_you_for_riding_with_us.
  ///
  /// In en, this message translates to:
  /// **'Thank you for riding with us'**
  String get thank_you_for_riding_with_us;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @enter_valid_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter valid OTP'**
  String get enter_valid_otp;

  /// No description provided for @waiting_at_pickup_point.
  ///
  /// In en, this message translates to:
  /// **'waiting at pickup point'**
  String get waiting_at_pickup_point;

  /// No description provided for @arrived_at_pickup.
  ///
  /// In en, this message translates to:
  /// **'Arrived at pickup'**
  String get arrived_at_pickup;

  /// No description provided for @otp_verified_ride_started.
  ///
  /// In en, this message translates to:
  /// **'OTP verified - Ride started'**
  String get otp_verified_ride_started;

  /// No description provided for @ride_completed_status.
  ///
  /// In en, this message translates to:
  /// **'Ride completed'**
  String get ride_completed_status;

  /// No description provided for @error_loading_ride_data.
  ///
  /// In en, this message translates to:
  /// **'Error loading ride data'**
  String get error_loading_ride_data;

  /// No description provided for @please_complete_the_ride_before_going_back.
  ///
  /// In en, this message translates to:
  /// **'Please complete the ride before going back.'**
  String get please_complete_the_ride_before_going_back;

  /// No description provided for @back_disabled_during_active_ride.
  ///
  /// In en, this message translates to:
  /// **'Back disabled during active ride'**
  String get back_disabled_during_active_ride;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @im_here.
  ///
  /// In en, this message translates to:
  /// **'I\'m Here'**
  String get im_here;

  /// No description provided for @completing.
  ///
  /// In en, this message translates to:
  /// **'Completing...'**
  String get completing;

  /// No description provided for @reached_destination.
  ///
  /// In en, this message translates to:
  /// **'Reached Destination'**
  String get reached_destination;

  /// No description provided for @cancel_ride.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride'**
  String get cancel_ride;

  /// No description provided for @navigate_to_drop.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Drop'**
  String get navigate_to_drop;

  /// No description provided for @please_tell_us_why_you_want_to_cancel.
  ///
  /// In en, this message translates to:
  /// **'Please tell us why you want to cancel?'**
  String get please_tell_us_why_you_want_to_cancel;

  /// No description provided for @no_cancel_reasons_available.
  ///
  /// In en, this message translates to:
  /// **'No cancel reasons available'**
  String get no_cancel_reasons_available;

  /// No description provided for @confirm_cancel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancel'**
  String get confirm_cancel;

  /// No description provided for @enter_ride_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter Ride OTP'**
  String get enter_ride_otp;

  /// No description provided for @enter_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enter_otp;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @verify_otp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verify_otp;

  /// No description provided for @change_payment_mode.
  ///
  /// In en, this message translates to:
  /// **'Change Payment Mode'**
  String get change_payment_mode;

  /// No description provided for @upi_card.
  ///
  /// In en, this message translates to:
  /// **'UPI / Card'**
  String get upi_card;

  /// No description provided for @collect_from_passenger.
  ///
  /// In en, this message translates to:
  /// **'Collect from passenger'**
  String get collect_from_passenger;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @change_pay_mode.
  ///
  /// In en, this message translates to:
  /// **'Change pay mode'**
  String get change_pay_mode;

  /// No description provided for @waiting_for_payment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Payment'**
  String get waiting_for_payment;

  /// No description provided for @to_complete_payment.
  ///
  /// In en, this message translates to:
  /// **'to complete payment'**
  String get to_complete_payment;

  /// No description provided for @please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get please_wait;

  /// No description provided for @collect_cash.
  ///
  /// In en, this message translates to:
  /// **'Collect Cash'**
  String get collect_cash;

  /// No description provided for @collect_cash_payment.
  ///
  /// In en, this message translates to:
  /// **'Collect Cash Payment'**
  String get collect_cash_payment;

  /// No description provided for @collect_cash_from.
  ///
  /// In en, this message translates to:
  /// **'Collect cash from'**
  String get collect_cash_from;

  /// No description provided for @amount_to_collect.
  ///
  /// In en, this message translates to:
  /// **'Amount to Collect'**
  String get amount_to_collect;

  /// No description provided for @withdraw_history.
  ///
  /// In en, this message translates to:
  /// **'Withdraw History'**
  String get withdraw_history;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @no_withdraw_history_found.
  ///
  /// In en, this message translates to:
  /// **'No Withdraw History Found'**
  String get no_withdraw_history_found;

  /// No description provided for @your_withdraw_history_will_appear_here.
  ///
  /// In en, this message translates to:
  /// **'Your withdraw history will appear here'**
  String get your_withdraw_history_will_appear_here;

  /// No description provided for @upload_file.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get upload_file;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @upload_pdf.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get upload_pdf;

  /// No description provided for @create_your_account.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get create_your_account;

  /// No description provided for @fill_your_details_below.
  ///
  /// In en, this message translates to:
  /// **'Fill your details below'**
  String get fill_your_details_below;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @email_address_optional.
  ///
  /// In en, this message translates to:
  /// **'Email Address (Optional)'**
  String get email_address_optional;

  /// No description provided for @full_address.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get full_address;

  /// No description provided for @select_category.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get select_category;

  /// No description provided for @select_gender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get select_gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @dont_have_any_skill.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have any skill?'**
  String get dont_have_any_skill;

  /// No description provided for @upload_experience_certificate.
  ///
  /// In en, this message translates to:
  /// **'Upload Experience Certificate (Image/PDF)'**
  String get upload_experience_certificate;

  /// No description provided for @upload_aadhaar_front.
  ///
  /// In en, this message translates to:
  /// **'Upload Aadhaar Front'**
  String get upload_aadhaar_front;

  /// No description provided for @upload_aadhaar_back.
  ///
  /// In en, this message translates to:
  /// **'Upload Aadhaar Back'**
  String get upload_aadhaar_back;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @location_permission_denied_permanently.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied permanently'**
  String get location_permission_denied_permanently;

  /// No description provided for @error_fetching_location.
  ///
  /// In en, this message translates to:
  /// **'Error fetching location'**
  String get error_fetching_location;

  /// No description provided for @no_cities_found.
  ///
  /// In en, this message translates to:
  /// **'No Cities Found'**
  String get no_cities_found;

  /// No description provided for @select_city.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get select_city;

  /// No description provided for @you_can_select_maximum_3_categories.
  ///
  /// In en, this message translates to:
  /// **'You can select maximum 3 categories'**
  String get you_can_select_maximum_3_categories;

  /// No description provided for @please_enter_first_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter first name'**
  String get please_enter_first_name;

  /// No description provided for @please_enter_last_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter last name'**
  String get please_enter_last_name;

  /// No description provided for @please_select_city.
  ///
  /// In en, this message translates to:
  /// **'Please select city'**
  String get please_select_city;

  /// No description provided for @please_enter_address.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get please_enter_address;

  /// No description provided for @please_fetch_current_location.
  ///
  /// In en, this message translates to:
  /// **'Please click on the location icon in address field to fetch your current location'**
  String get please_fetch_current_location;

  /// No description provided for @select_gender_error.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get select_gender_error;

  /// No description provided for @select_at_least_one_category.
  ///
  /// In en, this message translates to:
  /// **'Select at least one category'**
  String get select_at_least_one_category;

  /// No description provided for @upload_experience_certificate_error.
  ///
  /// In en, this message translates to:
  /// **'Upload Experience Certificate'**
  String get upload_experience_certificate_error;

  /// No description provided for @upload_aadhaar_front_back.
  ///
  /// In en, this message translates to:
  /// **'Upload Aadhaar front & back'**
  String get upload_aadhaar_front_back;

  /// No description provided for @upload_profile_photo.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile Photo'**
  String get upload_profile_photo;

  /// No description provided for @verification_pending.
  ///
  /// In en, this message translates to:
  /// **'Verification Pending'**
  String get verification_pending;

  /// No description provided for @admin_is_verifying_your_profile.
  ///
  /// In en, this message translates to:
  /// **'Admin is verifying your profile.\nPlease wait for approval.'**
  String get admin_is_verifying_your_profile;

  /// No description provided for @account_inactive.
  ///
  /// In en, this message translates to:
  /// **'Account Inactive'**
  String get account_inactive;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @enable_display_over_other_apps.
  ///
  /// In en, this message translates to:
  /// **'Enable display over other apps'**
  String get enable_display_over_other_apps;

  /// No description provided for @are_you_sure_you_want_to_exit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get are_you_sure_you_want_to_exit;

  /// No description provided for @handyman_home.
  ///
  /// In en, this message translates to:
  /// **'Handyman Home'**
  String get handyman_home;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @total_cash_in_hand.
  ///
  /// In en, this message translates to:
  /// **'Total Cash in Hand'**
  String get total_cash_in_hand;

  /// No description provided for @find_services.
  ///
  /// In en, this message translates to:
  /// **'Find Services'**
  String get find_services;

  /// No description provided for @accepted_bookings.
  ///
  /// In en, this message translates to:
  /// **'Accepted Bookings'**
  String get accepted_bookings;

  /// No description provided for @booking_history.
  ///
  /// In en, this message translates to:
  /// **'Booking History'**
  String get booking_history;

  /// No description provided for @total_revenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get total_revenue;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @updating_status.
  ///
  /// In en, this message translates to:
  /// **'Updating status...'**
  String get updating_status;

  /// No description provided for @no_reviews_found.
  ///
  /// In en, this message translates to:
  /// **'No reviews found'**
  String get no_reviews_found;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @location_services_are_disabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get location_services_are_disabled;

  /// No description provided for @location_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get location_permission_denied;

  /// No description provided for @location_permission_permanently_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get location_permission_permanently_denied;

  /// No description provided for @no_address.
  ///
  /// In en, this message translates to:
  /// **'No address'**
  String get no_address;

  /// No description provided for @pending_bookings.
  ///
  /// In en, this message translates to:
  /// **'Pending Bookings'**
  String get pending_bookings;

  /// No description provided for @no_pending_bookings_available.
  ///
  /// In en, this message translates to:
  /// **'No pending bookings available'**
  String get no_pending_bookings_available;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @desc.
  ///
  /// In en, this message translates to:
  /// **'Desc'**
  String get desc;

  /// No description provided for @ignore.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get ignore;

  /// No description provided for @reject_booking.
  ///
  /// In en, this message translates to:
  /// **'Reject Booking'**
  String get reject_booking;

  /// No description provided for @please_mention_rejection_reason.
  ///
  /// In en, this message translates to:
  /// **'Please mention rejection reason'**
  String get please_mention_rejection_reason;

  /// No description provided for @enter_reason.
  ///
  /// In en, this message translates to:
  /// **'Enter reason...'**
  String get enter_reason;

  /// No description provided for @please_enter_reason.
  ///
  /// In en, this message translates to:
  /// **'Please enter reason'**
  String get please_enter_reason;

  /// No description provided for @please_select_your_preferred_payment_mode.
  ///
  /// In en, this message translates to:
  /// **'Please select your preferred payment mode'**
  String get please_select_your_preferred_payment_mode;

  /// No description provided for @pay_online.
  ///
  /// In en, this message translates to:
  /// **'Pay Online'**
  String get pay_online;

  /// No description provided for @pay_offline.
  ///
  /// In en, this message translates to:
  /// **'Pay Offline'**
  String get pay_offline;

  /// No description provided for @please_collect_amount_from_customer.
  ///
  /// In en, this message translates to:
  /// **'Please collect ₹amount from customer'**
  String get please_collect_amount_from_customer;

  /// No description provided for @cash_collected.
  ///
  /// In en, this message translates to:
  /// **'Cash Collected'**
  String get cash_collected;

  /// No description provided for @meter.
  ///
  /// In en, this message translates to:
  /// **'meter'**
  String get meter;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @accept_booking.
  ///
  /// In en, this message translates to:
  /// **'Accept Booking'**
  String get accept_booking;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @hide_details.
  ///
  /// In en, this message translates to:
  /// **'Hide Details'**
  String get hide_details;

  /// No description provided for @view_order_detail.
  ///
  /// In en, this message translates to:
  /// **'View Order Detail'**
  String get view_order_detail;

  /// No description provided for @customer_name.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customer_name;

  /// No description provided for @customer_mobile.
  ///
  /// In en, this message translates to:
  /// **'Customer Mobile'**
  String get customer_mobile;

  /// No description provided for @payment_mode.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get payment_mode;

  /// No description provided for @service_date.
  ///
  /// In en, this message translates to:
  /// **'Service Date'**
  String get service_date;

  /// No description provided for @current_pay_mode.
  ///
  /// In en, this message translates to:
  /// **'Current Pay Mode'**
  String get current_pay_mode;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @verify_start.
  ///
  /// In en, this message translates to:
  /// **'Verify & Start'**
  String get verify_start;

  /// No description provided for @work_completed_collect_cash.
  ///
  /// In en, this message translates to:
  /// **'Work Completed Collect Cash'**
  String get work_completed_collect_cash;

  /// No description provided for @update_complete_status.
  ///
  /// In en, this message translates to:
  /// **'Update Complete Status'**
  String get update_complete_status;

  /// No description provided for @waiting_for_user_payment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for User Payment'**
  String get waiting_for_user_payment;

  /// No description provided for @service_completed_payment_done.
  ///
  /// In en, this message translates to:
  /// **'Service Completed • Payment Done'**
  String get service_completed_payment_done;

  /// No description provided for @service_started_successfully_message.
  ///
  /// In en, this message translates to:
  /// **'Service has started successfully. Please complete the job and update the status once done.'**
  String get service_started_successfully_message;

  /// No description provided for @rejected_by_me.
  ///
  /// In en, this message translates to:
  /// **'Rejected by Me'**
  String get rejected_by_me;

  /// No description provided for @address_not_available.
  ///
  /// In en, this message translates to:
  /// **'Address not available'**
  String get address_not_available;

  /// No description provided for @date_time.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get date_time;

  /// No description provided for @reason_not_available.
  ///
  /// In en, this message translates to:
  /// **'Reason not available'**
  String get reason_not_available;

  /// No description provided for @payment_status.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get payment_status;

  /// No description provided for @offline_payment.
  ///
  /// In en, this message translates to:
  /// **'Offline Payment'**
  String get offline_payment;

  /// No description provided for @by_wallet.
  ///
  /// In en, this message translates to:
  /// **'By Wallet'**
  String get by_wallet;

  /// No description provided for @earning_list.
  ///
  /// In en, this message translates to:
  /// **'Earning List'**
  String get earning_list;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @recent_earnings.
  ///
  /// In en, this message translates to:
  /// **'Recent Earnings'**
  String get recent_earnings;

  /// No description provided for @no_recent_earnings_found.
  ///
  /// In en, this message translates to:
  /// **'No recent earnings found'**
  String get no_recent_earnings_found;

  /// No description provided for @no_profile_found.
  ///
  /// In en, this message translates to:
  /// **'No Profile Found'**
  String get no_profile_found;

  /// No description provided for @basic_details.
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get basic_details;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @service_name.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get service_name;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @aadhaar_front.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Front'**
  String get aadhaar_front;

  /// No description provided for @aadhaar_back.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Back'**
  String get aadhaar_back;

  /// No description provided for @experience_certificate.
  ///
  /// In en, this message translates to:
  /// **'Experience Certificate'**
  String get experience_certificate;

  /// No description provided for @other_info.
  ///
  /// In en, this message translates to:
  /// **'Other Info'**
  String get other_info;

  /// No description provided for @created_at.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get created_at;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @transaction_history.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transaction_history;

  /// No description provided for @clear_due_amount.
  ///
  /// In en, this message translates to:
  /// **'Clear Due Amount'**
  String get clear_due_amount;

  /// No description provided for @due_amount.
  ///
  /// In en, this message translates to:
  /// **'Due Amount'**
  String get due_amount;

  /// No description provided for @no_due_amount_available.
  ///
  /// In en, this message translates to:
  /// **'No due amount available'**
  String get no_due_amount_available;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @wallet_balance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get wallet_balance;

  /// No description provided for @clear_due.
  ///
  /// In en, this message translates to:
  /// **'Clear Due'**
  String get clear_due;

  /// No description provided for @from_wallet.
  ///
  /// In en, this message translates to:
  /// **'From Wallet'**
  String get from_wallet;

  /// No description provided for @service_transaction.
  ///
  /// In en, this message translates to:
  /// **'Service Transaction'**
  String get service_transaction;

  /// No description provided for @please_enter_bank_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter bank name'**
  String get please_enter_bank_name;

  /// No description provided for @please_re_enter_account_number.
  ///
  /// In en, this message translates to:
  /// **'Please re-enter account number'**
  String get please_re_enter_account_number;

  /// No description provided for @account_numbers_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Account numbers do not match'**
  String get account_numbers_do_not_match;

  /// No description provided for @enter_account_holder_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Account Holder Name'**
  String get enter_account_holder_name;

  /// No description provided for @please_enter_account_holder_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter account holder name'**
  String get please_enter_account_holder_name;

  /// No description provided for @please_enter_ifsc_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter IFSC code'**
  String get please_enter_ifsc_code;

  /// No description provided for @state_bank_of_india.
  ///
  /// In en, this message translates to:
  /// **'State Bank of India'**
  String get state_bank_of_india;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get change_language;

  /// No description provided for @choose_image_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose Image from Gallery'**
  String get choose_image_gallery;

  /// No description provided for @upload_pdf_document_affidavit_allowed.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF Document (Affidavit allowed)'**
  String get upload_pdf_document_affidavit_allowed;

  /// No description provided for @designation_certificates_affidavits_cv.
  ///
  /// In en, this message translates to:
  /// **'Designation Certificates / Affidavits / CV'**
  String get designation_certificates_affidavits_cv;

  /// No description provided for @doc.
  ///
  /// In en, this message translates to:
  /// **'Doc'**
  String get doc;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @designation_certificate_affidavit_message.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t have a designation certificate, upload an affidavit (PDF) as alternate.'**
  String get designation_certificate_affidavit_message;

  /// No description provided for @search_city.
  ///
  /// In en, this message translates to:
  /// **'Search city...'**
  String get search_city;

  /// No description provided for @uttar_pradesh_india.
  ///
  /// In en, this message translates to:
  /// **'Uttar Pradesh, India'**
  String get uttar_pradesh_india;

  /// No description provided for @hello_user.
  ///
  /// In en, this message translates to:
  /// **'Hello User !'**
  String get hello_user;

  /// No description provided for @create_account_better_experience.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account for Better\nExperience'**
  String get create_account_better_experience;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @designation_example.
  ///
  /// In en, this message translates to:
  /// **'Designation (e.g. Plumber)'**
  String get designation_example;

  /// No description provided for @dont_know_any_skill.
  ///
  /// In en, this message translates to:
  /// **'Don\'t know any skill'**
  String get dont_know_any_skill;

  /// No description provided for @request_submitted.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted!'**
  String get request_submitted;

  /// No description provided for @job_request_successfully_submitted.
  ///
  /// In en, this message translates to:
  /// **'Your job request has been successfully submitted.\nNow please wait for the job to be assigned'**
  String get job_request_successfully_submitted;

  /// No description provided for @go_to_home.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get go_to_home;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
