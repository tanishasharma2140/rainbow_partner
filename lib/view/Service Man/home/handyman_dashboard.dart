import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/service_custom_drawer.dart';
import 'package:rainbow_partner/res/shimmer_loader.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/view/Service%20Man/home/accepted_booking.dart';
import 'package:rainbow_partner/view/Service%20Man/home/complete_booking.dart';
import 'package:rainbow_partner/view/Service%20Man/home/service_total_booking.dart';
import 'package:rainbow_partner/view/Service%20Man/home/service_total_revenue_earning.dart';
import 'package:rainbow_partner/view_model/service_man/complete_booking_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/review_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_info_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';

class HandymanDashboard extends StatefulWidget {
  const HandymanDashboard({super.key});

  @override
  State<HandymanDashboard> createState() => _HandymanDashboardState();
}

class _HandymanDashboardState extends State<HandymanDashboard> {


  List<double> animatedValues = List.filled(8, 0.0);
  List<double> finalValues = [10000, 5000, 8000];


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      final position = await LocationUtils.getLocation();

      final lat = position.latitude.toString();
      final lng = position.longitude.toString();

      context.read<ServicemanProfileViewModel>()
          .servicemanProfileApi(lat,lng,context);
      Provider.of<ReviewViewModel>(context,listen: false).reviewApi(context);
      Provider.of<ServiceInfoViewModel>(context,listen: false).serviceInfoApi(context);

      final vm = context.read<ServicemanProfileViewModel>();
      if (vm.servicemanProfileModel?.data?.loginStatus == 0) {
        _showBlockedDialog();
        return;
      }

      final completeVm = context.read<CompleteBookingViewModel>();
      await completeVm.completeBookingApi([1, 2, 3], context);

      if (!mounted) return;

      // ✅ FIRST run animation
      setState(() {
        animatedValues[0] = finalValues[0];
        animatedValues[1] = finalValues[1];
        animatedValues[2] = finalValues[2];
      });

      // ✅ THEN navigate after animation delay
      if (completeVm.completeBookingModel?.data?.isNotEmpty == true) {
        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;

        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => AcceptedBooking()),
        );
      }
    });
  }

  void _showBlockedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// ICON
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.block,
                    color: Colors.red,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 16),

                /// TITLE
                const TextConst(
                  title: "Account Blocked",
                  size: 18,
                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 8),

                /// MESSAGE
                const TextConst(
                  title:
                  "Your account has been blocked by the admin.\nPlease contact admin for further assistance.",
                  size: 14,
                  color: Colors.grey,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 22),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.royalBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const TextConst(
                      title: "OK",
                      color: Colors.white,
                      size: 15,
                      fontWeight: FontWeight.w600,
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

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return "--";

    try {
      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();

      // 🔹 Format: 12 Sep 2025, 10:45 AM
      return "${dateTime.day.toString().padLeft(2, '0')} "
          "${_monthName(dateTime.month)} "
          "${dateTime.year}, "
          "${_formatTime(dateTime)}";
    } catch (e) {
      return "--";
    }
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime dt) {
    int hour = dt.hour;
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    if (hour == 0) hour = 12;

    return "$hour:${dt.minute.toString().padLeft(2, '0')} $period";
  }



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final serviceProfileVm = Provider.of<ServicemanProfileViewModel>(context);
    final reviewVm = Provider.of<ReviewViewModel>(context);
    final serviceVm = Provider.of<ServiceInfoViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          drawer: const ServiceCustomDrawer(),
          appBar: AppBar(
            backgroundColor: AppColor.royalBlue,
            elevation: 0,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                SizedBox(width: 18),
                TextConst(
                  title: "Handyman Home",
                  color: Colors.white,
                  size: 20,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 18),
                child: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: Icon(Icons.menu, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  serviceProfileVm.loading ||
                      serviceProfileVm.servicemanProfileModel == null ||
                      serviceProfileVm.servicemanProfileModel!.data == null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerLoader(width: 180, height: 18),
                      SizedBox(height: 6),
                      ShimmerLoader(width: 120, height: 14),
                    ],
                  )
                      : TextConst(
                    title:
                    "Hello, ${serviceProfileVm.servicemanProfileModel!.data!.firstName} ${serviceProfileVm.servicemanProfileModel!.data!.lastName}",
                    size: 18,
                    fontWeight: FontWeight.w600,
                  ),

                  TextConst(title: "Welcome back!", size: 13, color: Colors.grey),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColor.royalBlue,
                          child: const Icon(Icons.account_balance_wallet,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                            child: TextConst(title: "Total Cash in Hand", size: 16)),
                        serviceProfileVm.loading ||
                            serviceProfileVm.servicemanProfileModel == null ||
                            serviceProfileVm.servicemanProfileModel!.data == null
                            ? const ShimmerLoader(
                          width: 80,
                          height: 18,
                          borderRadius: 6,
                        )
                            : TextConst(
                          title:
                          "₹${serviceProfileVm.servicemanProfileModel!.data!.wallet ?? "0.00"}",
                          size: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.royalBlue,
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: statBox(
                          title: "Find Services",
                          imagePath: "assets/sandy_loading.gif",
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => ServiceTotalBooking(),
                              ),
                            );
                          },
                        ),
                      ),


                      const SizedBox(width: 15),
                      Expanded(
                        child: statBox(
                          value: serviceVm.serviceInfoModel?.data?.acceptedBooking.toString()??"0",
                          title: "Accepted Bookings",
                          icon: Icons.design_services,
                          onTap: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (_) => AcceptedBooking()));
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: statBox(
                          value: serviceVm.serviceInfoModel?.data?.completedBooking.toString()??"",
                          title: "Booking History",
                          icon:  Icons.list_alt_outlined,
                          onTap: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (_) => CompleteBooking()));
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: statBox(
                          value: "₹${serviceVm.serviceInfoModel?.data?.totalEarning??""}",
                          title: "Total Revenue",
                          icon: Icons.monetization_on_outlined,
                          onTap: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (_) => ServiceTotalRevenueEarning()));
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  TextConst(title: "Monthly Revenue USD", size: 18, fontWeight: FontWeight.w600),
                  const SizedBox(height: 15),

                  // ------------------------------------------------------------------
                  //                          BAR CHART 8 MONTHS
                  // ------------------------------------------------------------------
                  Container(
                    height: 190,
                    padding: const EdgeInsets.fromLTRB(12, 15, 12, 12),
                    decoration: BoxDecoration(
                      color: AppColor.whiteDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 15000,
                        minY: 0,
                        barTouchData: BarTouchData(enabled: false),

                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 5000,
                          getDrawingHorizontalLine: (value) =>
                              FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                        ),

                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 5000,
                              reservedSize: 40,
                              getTitlesWidget: (v, meta) => Text(
                                v.toInt().toString(),
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                const months = [
                                  "Jan", "Feb", "Mar", "Apr",
                                  "May", "Jun", "Jul", "Aug"
                                ];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(months[value.toInt()],
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),

                        // ⭐ ANIMATED ONLY FIRST 3 MONTHS ⭐
                        barGroups: List.generate(8, (i) {
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: animatedValues[i],
                                width: 18,
                                color: i < 3
                                    ? AppColor.royalBlue
                                    : const Color(0xFF2E5F4D),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),

                      swapAnimationDuration: const Duration(milliseconds: 900),
                      swapAnimationCurve: Curves.easeOutBack,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextConst(title: "Reviews", size: 20, fontWeight: FontWeight.w600),
                  const SizedBox(height: 15),

                  reviewList(reviewVm)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget reviewList(ReviewViewModel reviewVm) {
    // 🔹 SHIMMER STATE
    if (reviewVm.loading) {
      return ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: ReviewShimmerCard(),
          );
        },
      );
    }

    final reviews = reviewVm.reviewModel?.data;

    // 🔹 EMPTY STATE
    if (reviews == null || reviews.isEmpty) {
      return const Center(
        child: Text(
          "No reviews found",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // 🔹 DATA STATE
    return ListView.builder(
      itemCount: reviews.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final review = reviews[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: reviewCard(
            name: review.userName ?? "Anonymous",
            date: formatDateTime(review.createdAt),
            service: review.serviceName ?? "--",
            rating: review.rating?.toString() ?? "0",
            image: review.image,
          ),
        );
      },
    );
  }
  
  Widget reviewCard({
    required String name,
    required String date,
    required String service,
    required String rating,
    String? image,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.royalBlue,width: 0.4),
        boxShadow: [
          BoxShadow(
            color: AppColor.royalBlue.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage:
            image != null && image.isNotEmpty ? NetworkImage(image) : null,
            child: image == null || image.isEmpty
                ? const Icon(Icons.person, size: 28)
                : null,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextConst(
                        title: name,
                        fontWeight: FontWeight.w600,
                        size: 16,
                      ),
                    ),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          TextConst(
                            title: rating,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                TextConst(title: date, size: 13, color: Colors.grey),
                TextConst(
                  title: "Service: $service",
                  size: 13,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget dashboardShimmer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 20),
          ShimmerLoader(width: 180, height: 18),
          const SizedBox(height: 6),
          ShimmerLoader(width: 120, height: 14),

          const SizedBox(height: 25),
          ShimmerLoader(height: 80, borderRadius: 20),

          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(child: ShimmerLoader(height: 120)),
              const SizedBox(width: 15),
              Expanded(child: ShimmerLoader(height: 120)),
            ],
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: ShimmerLoader(height: 120)),
              const SizedBox(width: 15),
              Expanded(child: ShimmerLoader(height: 120)),
            ],
          ),

          const SizedBox(height: 25),
          ShimmerLoader(width: 180, height: 18),
          const SizedBox(height: 15),
          ShimmerLoader(height: 190, borderRadius: 12),

          const SizedBox(height: 25),
          ShimmerLoader(width: 120, height: 18),
          const SizedBox(height: 15),

          ShimmerLoader(height: 90),
          const SizedBox(height: 12),
          ShimmerLoader(height: 90),
        ],
      ),
    );
  }


  Widget statBox({
    String? value,
    required String title,
    IconData? icon,
    String? imagePath,
    required VoidCallback onTap,
  }) {
    final bool isImageOnlyCard =
        imagePath != null && (value == null || value.isEmpty);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColor.royalBlue.withOpacity(0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        /// 🔥 IMAGE ONLY CARD
        child: isImageOnlyCard
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 55,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            TextConst(
              title: title,
              size: 15,
              fontWeight: FontWeight.w600,
              color: AppColor.royalBlue,
            ),
          ],
        )

        /// 🔵 NORMAL STAT CARD
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextConst(
                  title: value ?? "",
                  size: 22,
                  fontWeight: FontWeight.w700,
                ),

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.royalBlue.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: imagePath != null
                      ? Image.asset(
                    imagePath,
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  )
                      : Icon(
                    icon ?? Icons.image,
                    size: 20,
                    color: AppColor.royalBlue,
                  ),
                ),
              ],
            ),
            const Spacer(),
            TextConst(
              title: title,
              size: 15,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }


}

class ReviewShimmerCard extends StatelessWidget {
  const ReviewShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerLoader(
            width: 56,
            height: 56,
            borderRadius: 28,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerLoader(width: double.infinity, height: 14),
                SizedBox(height: 8),
                ShimmerLoader(width: 120, height: 12),
                SizedBox(height: 6),
                ShimmerLoader(width: 160, height: 12),
              ],
            ),
          ),

          const SizedBox(width: 8),
          const ShimmerLoader(width: 40, height: 20, borderRadius: 6),
        ],
      ),
    );
  }
}
