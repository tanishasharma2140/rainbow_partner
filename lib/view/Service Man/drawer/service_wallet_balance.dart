import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service Man/drawer/service_withdraw_request.dart';
import 'package:rainbow_partner/view_model/service_man/service_withdraw_history_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';
import 'package:rainbow_partner/model/service_withdraw_history_model.dart';

class ServiceWalletBalance extends StatefulWidget {
  const ServiceWalletBalance({super.key});

  @override
  State<ServiceWalletBalance> createState() => _ServiceWalletBalanceState();
}

class _ServiceWalletBalanceState extends State<ServiceWalletBalance> {
  int selectedTab = 0; // 0=All, 1=Pending, 2=Success, 3=Reject

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceWithdrawHistoryViewModel>(
        context,
        listen: false,
      ).serviceWithdrawHistoryApi("", context);
    });
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";

    try {
      // API format: yyyy-MM-dd HH:mm:ss
      final DateTime dt = DateTime.parse(date.replaceAll(' ', 'T'));

      return "${dt.day.toString().padLeft(2, '0')} "
          "${_monthName(dt.month)} ${dt.year}, "
          "${_formatTime(dt)}";
    } catch (e) {
      return date; // fallback
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
    final int minute = dt.minute;
    final String amPm = hour >= 12 ? "PM" : "AM";

    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;

    return "${hour.toString().padLeft(2, '0')}:"
        "${minute.toString().padLeft(2, '0')} $amPm";
  }


  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ServicemanProfileViewModel>(context);
    final historyVm = Provider.of<ServiceWithdrawHistoryViewModel>(context);

    final List<Data> history =
        historyVm.serviceWithdrawHistoryModel?.data ?? <Data>[];

    final List<Data> filteredHistory = getFilteredHistory(history);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),

        // ---------------- APP BAR ----------------
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const TextConst(
                title: "Withdraw",
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildBalanceCard(profile),
              const SizedBox(height: 25),
              buildTabs(),
              const SizedBox(height: 20),
              filteredHistory.isEmpty
                  ? buildEmptyHistory()
                  : buildHistoryList(filteredHistory),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildBalanceCard(ServicemanProfileViewModel profile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.royalBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const SizedBox(height: 18),

          // WHITE CARD
          Container(
            height: 140,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextConst(
                  title: "Available Balance",
                  size: 15,
                  color: Colors.grey,
                ),
                const SizedBox(height: 6),
                TextConst(
                  title:
                  "₹${profile.servicemanProfileModel?.data?.wallet ?? "0"}",
                  size: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.poppinsReg,
                  color: AppColor.royalBlue,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // WITHDRAW BUTTON
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => const ServiceWithdrawRequest(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                TextConst(
                  title: "Withdraw",
                  color: Colors.white,
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.add_box_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }


  Widget buildTabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          tabItem("All", 0),
          tabItem("Pending", 1),
          tabItem("Success", 2),
          tabItem("Reject", 3),
        ],
      ),
    );
  }

  Widget tabItem(String title, int index) {
    final bool selected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedTab = index);
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColor.royalBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextConst(
            title: title,
            size: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // FILTER LOGIC (MODEL SAFE)
  // ----------------------------------------------------
  List<Data> getFilteredHistory(List<Data> history) {
    if (selectedTab == 0) return history;
    if (selectedTab == 1) {
      return history.where((e) => e.status == 0).toList();
    } else if (selectedTab == 2) {
      return history.where((e) => e.status == 1).toList();
    } else {
      return history.where((e) => e.status == 2).toList();
    }
  }

  // ----------------------------------------------------
  // EMPTY STATE
  // ----------------------------------------------------
  Widget buildEmptyHistory() {
    return Center(
      child: Column(
        children: const [
          SizedBox(height: 150),
          TextConst(
            title: "No Withdraw History Found",
            size: 17,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 6),
          TextConst(
            title: "Your withdraw history will appear here",
            size: 13,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // HISTORY LIST
  // ----------------------------------------------------
  Widget buildHistoryList(List<Data> history) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final Data item = history[index];
        final int status = item.status ?? 0;

        Color statusColor;
        String statusText;

        if (status == 0) {
          statusText = "Pending";
          statusColor = Colors.orange;
        } else if (status == 1) {
          statusText = "Success";
          statusColor = Colors.green;
        } else {
          statusText = "Rejected";
          statusColor = Colors.red;
        }

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey.withOpacity(0.15),
              width: 1,
            ),

            // 🌟 SOFT SHADOW
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextConst(
                    title: "₹${item.amount ?? "0"}",
                    size: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextConst(
                      title: statusText,
                      size: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextConst(
                title: "Txn ID: ${item.transactionId ?? "-"}",
                size: 12,
                color: Colors.grey,
              ),
              const SizedBox(height: 4),
              TextConst(
                title: formatDate(item.createdAt),
                size: 11,
                color: Colors.grey,
              ),
              if (status == 2 && item.rejectedReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextConst(
                          title: item.rejectedReason!,
                          size: 12,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
