import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/animated_gradient_border.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/service_man/payment_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/transaction_history_view_model.dart';
import 'package:rainbow_partner/model/transaction_history_model.dart';

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

  void _showClearDuePopup(BuildContext context) {
    final payment = Provider.of<PaymentViewModel>(context, listen: false);
    final profile = Provider.of<ServicemanProfileViewModel>(context,listen: false);

    final double dueAmount = double.tryParse(
        profile.servicemanProfileModel?.data?.dueWallet?.toString() ?? "0"
    ) ?? 0;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const TextConst(
            title: "Clear Due Amount",
            size: 16,
            fontWeight: FontWeight.w600,
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Colors.red),
                    const SizedBox(width: 8),
                    TextConst(
                      title: "Due Amount: ₹$dueAmount",
                      size: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const TextConst(title: "Cancel", color: Colors.grey),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (dueAmount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No due amount available")),
                  );
                  return;
                }

                payment.paymentApi(
                    dueAmount.toInt().toString(), // full due amount
                  5, // due wallet mode
                  "", // order
                  1, // module
                  context,
                );

                // Navigator.pop(context);
              },
              child: const TextConst(
                title: "Submit",
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  String getPaymentType(int? type) {
    switch (type) {
      case 1:
        return "Online";
      case 2:
        return "Offline";
      case 3:
        return "Wallet";
      case 5:
        return "Due Wallet";
      default:
        return "Unknown";
    }
  }

  Color getPaymentTypeColor(int? type) {
    switch (type) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatus(int? status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Success";
      case 2:
        return "Failed";
      default:
        return "Unknown";
    }
  }

  Color getStatusColor(int? status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ServicemanProfileViewModel>(context);
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
                                  children: [
                                    TextConst(
                                      title: "Wallet Balance",
                                      size: 15,
                                      color: AppColor.black,
                                    ),
                                    SizedBox(height: 4),
                                    TextConst(
                                      title:
                                          "₹ ${profile.servicemanProfileModel?.data?.wallet ?? "0"}",
                                      size: 22,
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
                                      child: TextConst(
                                        title:
                                            "₹${profile.servicemanProfileModel?.data?.dueWallet ?? "0"}",
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
                            child: GestureDetector(
                              onTap: () {
                                _showClearDuePopup(context);
                              },
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
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, index) {
                        final item = filters[index];
                        final bool selected = selectedType == item["type"];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = item["type"];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColor.royalBlue
                                  : AppColor.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColor.blackLight,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              item["title"],
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black54,
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
                      physics: const NeverScrollableScrollPhysics(),
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
// ================= TRANSACTION TILE =================
  Widget _transactionTile(payment) {
    final typeInfo = _getTypeInfo(payment.paymentType);
    final statusInfo = _getStatusInfo(payment.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Title + Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextConst(
                title: "Service Transaction",
                size: 15,
                fontWeight: FontWeight.w600,
              ),
              Text(
                "₹ ${payment.amount ?? "0"}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.royalBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Row 2: Type Badge + Status Badge
          Row(
            children: [
              _badge(typeInfo["label"], typeInfo["color"]),
              const SizedBox(width: 8),
              _badge(statusInfo["label"], statusInfo["color"]),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 10),

          // Row 3: Final Amount + Platform Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Final Amount",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "₹ ${payment.finalAmount ?? "0"}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Platform Fee",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${payment.platformFee ?? "0"}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Row 4: Date
          Row(
            children: [
              const Icon(Icons.access_time, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                payment.paymentDate ?? "",
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

// ================= BADGE WIDGET =================
  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

// ================= TYPE LABEL =================
  Map<String, dynamic> _getTypeInfo(dynamic paymentType) {
    switch (paymentType) {
      case 1:
        return {"label": "Online", "color": Colors.blue};
      case 2:
        return {"label": "Offline", "color": Colors.orange};
      case 3:
        return {"label": "Wallet", "color": Colors.purple};
      case 5:
        return {"label": "Due Wallet", "color": Colors.red};
      default:
        return {"label": "Unknown", "color": Colors.grey};
    }
  }

// ================= STATUS LABEL =================
  Map<String, dynamic> _getStatusInfo(dynamic status) {
    switch (status) {
      case 0:
        return {"label": "Pending", "color": Colors.orange};
      case 1:
        return {"label": "Success", "color": Colors.green};
      case 2:
        return {"label": "Failed", "color": Colors.red};
      default:
        return {"label": "Unknown", "color": Colors.grey};
    }
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
