import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/animated_gradient_border.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/service_man/transaction_history_view_model.dart';

class ServiceDueWallet extends StatefulWidget {
  const ServiceDueWallet({super.key});

  @override
  State<ServiceDueWallet> createState() => _ServiceDueWalletState();
}

class _ServiceDueWalletState extends State<ServiceDueWallet> {
  int selectedType = 0; // 0 = All

  final List<Map<String, dynamic>> filters = [
    {"title": "All", "type": 0},
    {"title": "Online", "type": 1},
    {"title": "Offline", "type": 2},
    {"title": "From Wallet", "type": 3},
    {"title": "Due Wallet", "type": 5},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionHistoryViewModel>(
        context,
        listen: false,
      ).transactionApi("", context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        // ---------------- APP BAR ----------------
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.royalBlue,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const TextConst(
            title: "Transaction History",
            color: Colors.white,
            size: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        // ---------------- BODY ----------------
        body: Consumer<TransactionHistoryViewModel>(
          builder: (context, vm, _) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final list = _getFilteredList(vm);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  AnimatedGradientBorder(
                    borderSize: 3, // 🔹 thinner border
                    glowSize: 0,
                    gradientColors: const [
                      AppColor.royalBlue,
                      Colors.transparent,
                      AppColor.royalBlue,
                    ],
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16), // 🔹 reduced padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColor.royalBlue.withOpacity(0.12),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.royalBlue.withOpacity(0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // 🔹 auto height
                        children: [
                          Row(
                            children: [
                              // TOTAL WALLET
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    TextConst(
                                      title: "Wallet Balance",
                                      size: 15,
                                      color: AppColor.black,
                                    ),
                                    SizedBox(height: 4),
                                    TextConst(
                                      title: "₹ 1,250",
                                      size: 24, // 🔹 slightly smaller
                                      color: AppColor.royalBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),

                              // DIVIDER
                              Container(
                                height: 44,
                                width: 1,
                                color: Colors.grey.shade300,
                              ),

                              // DUE WALLET
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const TextConst(
                                      title: "Due Amount",
                                      size: 15,
                                      color: AppColor.black,
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const TextConst(
                                        title: "₹ 469",
                                        size: 22,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // -------- CLEAR DUE BUTTON --------
                          SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {},
                              child: Container(
                                height: 40, // 🔹 reduced height
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 1.4,
                                  ),
                                ),
                                child: const TextConst(
                                  title: "Clear Due",
                                  color: Colors.red,
                                  size: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),




                  const SizedBox(height: 24),

                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(width: 10),
                      itemBuilder: (_, index) {
                        final item = filters[index];
                        final bool selected =
                            selectedType == item["type"];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = item["type"];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColor.royalBlue
                                  : AppColor.white,
                              borderRadius:
                              BorderRadius.circular(10),
                              border: Border.all(color: AppColor.blackLight,width: 0.5)
                            ),
                            child: Text(
                              item["title"],
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= TRANSACTION LIST =================
                  if (list.isEmpty)
                    _emptyState()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        final payment = list[index].payment;

                        return _transactionTile(payment);
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= SUMMARY CARD =================
  // Widget _summaryCard({
  //   required String title,
  //   required String amount,
  //   required IconData icon,
  //   required Color color,
  //   bool showButton = false,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: color.withOpacity(0.15),
  //           blurRadius: 8,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Icon(icon, color: color),
  //         const SizedBox(height: 10),
  //         TextConst(title: title, size: 13, color: Colors.black54),
  //         const SizedBox(height: 6),
  //         TextConst(
  //           title: amount,
  //           size: 22,
  //           color: color,
  //           fontWeight: FontWeight.bold,
  //         ),
  //         if (showButton) ...[
  //           const SizedBox(height: 10),
  //           CustomButton(
  //             title: "Clear Due",
  //             height: 36,
  //             bgColor: color,
  //             textColor: Colors.white,
  //             onTap: () {},
  //           ),
  //         ]
  //       ],
  //     ),
  //   );
  // }

  // ================= TRANSACTION TILE =================
  Widget _transactionTile(payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextConst(
                title: "Service Transaction",
                size: 15,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 4),
              Text(
                payment.paymentDate ?? "",
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Text(
            "₹ ${payment.amount}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.royalBlue,
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILTER LOGIC =================
  List _getFilteredList(TransactionHistoryViewModel vm) {
    final list = vm.transactionHistoryModel?.data ?? [];

    if (selectedType == 0) return list;

    return list.where((item) {
      return item.payment?.paymentType == selectedType;
    }).toList();
  }

  // ================= EMPTY STATE =================
  Widget _emptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40),
        child: TextConst(
          title: "No transactions found",
          size: 16,
          color: Colors.black54,
        ),
      ),
    );
  }
}
