import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/shimmer_loader.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_withdraw_history_view_model.dart';
import 'package:rainbow_partner/model/driver_withdraw_history_model.dart';

class DriverWithdrawHistory extends StatefulWidget {
  const DriverWithdrawHistory({super.key});

  @override
  State<DriverWithdrawHistory> createState() => _DriverWithdrawHistoryState();
}

class _DriverWithdrawHistoryState extends State<DriverWithdrawHistory> {
  int selectedTab = 0; // 0=All, 1=Pending, 2=Success, 3=Reject

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DriverWithdrawHistoryViewModel>(context, listen: false)
          .driverWithdrawHistoryApi("", context); // All = ""
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverWithdrawHistoryViewModel>(context);
    final List<Data> history = vm.driverWithdrawHistoryModel?.data ?? <Data>[];

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const TextConst(
                title: "Withdraw History",
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 25),
            buildTabs(),
            const SizedBox(height: 20),

            Expanded(
              child: vm.loading
                  ? ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: 4,
                itemBuilder: (_, __) => _buildShimmerCard(),
              )
                  : history.isEmpty
                  ? Center(child: buildEmptyHistory())
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: history.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = history[index];
                  final status = item.status ?? 0;

                  String statusText;
                  Color statusColor;

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
                      border: Border.all(color: Colors.grey.withOpacity(0.15)),
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
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                          title: item.createdAt ?? "-",
                          size: 11,
                          color: Colors.grey,
                        ),

                        if (status == 2 && item.rejectedReason != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, size: 16, color: Colors.red),
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
              ),
            ),
          ],
        ),
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

          String status = "";
          if (index == 1) status = "0";
          if (index == 2) status = "1";
          if (index == 3) status = "2";

          Provider.of<DriverWithdrawHistoryViewModel>(context, listen: false)
              .driverWithdrawHistoryApi(status, context);
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColor.royalBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerLoader(width: 100, height: 16),
              ShimmerLoader(width: 70, height: 18),
            ],
          ),
          SizedBox(height: 8),
          ShimmerLoader(width: 130, height: 14),
          SizedBox(height: 6),
          ShimmerLoader(width: 160, height: 12),
          SizedBox(height: 10),
          ShimmerLoader(width: double.infinity, height: 10),
        ],
      ),
    );
  }

  Widget buildEmptyHistory() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
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
    );
  }
}
