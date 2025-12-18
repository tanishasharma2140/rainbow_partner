import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/shimmer_loader.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_earning_view_model.dart';

class ServiceTotalRevenueEarning extends StatefulWidget {
  const ServiceTotalRevenueEarning({super.key});

  @override
  State<ServiceTotalRevenueEarning> createState() =>
      _ServiceTotalRevenueEarningState();
}

class _ServiceTotalRevenueEarningState
    extends State<ServiceTotalRevenueEarning> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ServicemanEarningViewModel>()
          .servicemanEarningApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final earningVm = Provider.of<ServicemanEarningViewModel>(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        /// ---------------- APPBAR ----------------
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const TextConst(
                title: "Earning List",
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------- TOTAL EARNINGS CARD ----------------
              earningVm.loading
                  ? const ShimmerLoader(height: 110, borderRadius: 18)
                  : totalEarningCard(earningVm),

              const SizedBox(height: 22),

              /// ---------------- SUMMARY ROW ----------------
              earningVm.loading
                  ? Row(
                children: const [
                  Expanded(child: ShimmerLoader(height: 80)),
                  SizedBox(width: 12),
                  Expanded(child: ShimmerLoader(height: 80)),
                  SizedBox(width: 12),
                  Expanded(child: ShimmerLoader(height: 80)),
                ],
              )
                  : Row(
                children: [
                  summaryBox(
                    "Today",
                    "₹${earningVm.servicemanEarningModel?.data?.todayEarning ?? "0"}",
                  ),
                  const SizedBox(width: 12),
                  summaryBox(
                    "Week",
                    "₹${earningVm.servicemanEarningModel?.data?.weekEarning ?? "0"}",
                  ),
                  const SizedBox(width: 12),
                  summaryBox(
                    "Month",
                    "₹${earningVm.servicemanEarningModel?.data?.monthEarning ?? "0"}",
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const TextConst(
                title: "Recent Earnings",
                size: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 14),

              /// ---------------- RECENT EARNINGS LIST ----------------
              recentEarningList(earningVm),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- TOTAL EARNING CARD ----------------
  Widget totalEarningCard(ServicemanEarningViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColor.royalBlue,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColor.royalBlue.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextConst(
            title: "Total Earnings",
            size: 16,
            color: Colors.white70,
          ),
          const SizedBox(height: 8),
          TextConst(
            title:
            "₹${vm.servicemanEarningModel?.data?.totalEarning ?? "0"}",
            size: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  /// ---------------- SUMMARY BOX ----------------
  Widget summaryBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColor.royalBlue.withOpacity(0.3),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            TextConst(
              title: title,
              size: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 6),
            TextConst(
              title: value,
              size: 16,
              color: AppColor.royalBlue,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- RECENT EARNING LIST ----------------
  Widget recentEarningList(ServicemanEarningViewModel earning) {
    if (earning.loading) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: RecentEarningShimmer(),
        ),
      );
    }

    final list = earning.servicemanEarningModel?.data?.recentEarnings;

    if (list == null || list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text(
            "No recent earnings found",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColor.royalBlue.withOpacity(0.15),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.royalBlue.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.home_repair_service_rounded,
                      color: AppColor.royalBlue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextConst(
                        title: item.serviceName ?? "--",
                        size: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 3),
                      TextConst(
                        title: item.serviceDatetime ?? "--",
                        size: 12,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ],
              ),
              TextConst(
                title: "₹${item.finalAmount ?? "0"}",
                size: 17,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ---------------- SHIMMER CARD ----------------
class RecentEarningShimmer extends StatelessWidget {
  const RecentEarningShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: const [
          ShimmerLoader(width: 44, height: 44, borderRadius: 22),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoader(width: 140, height: 14),
                SizedBox(height: 6),
                ShimmerLoader(width: 100, height: 12),
              ],
            ),
          ),
          ShimmerLoader(width: 50, height: 16, borderRadius: 6),
        ],
      ),
    );
  }
}
