import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/model/driver_transaction_model.dart';
import 'package:rainbow_partner/res/animated_gradient_border.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/shimmer_loader.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/driver_withdraw_history.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_payment_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_transaction_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_withdraw_request_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/payment_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_get_bank_detail_view_model.dart';

import 'add_bank.dart' show AddBank;

class WalletSettlement extends StatefulWidget {
  const WalletSettlement({super.key});

  @override
  State<WalletSettlement> createState() => _WalletSettlementState();
}

class _WalletSettlementState extends State<WalletSettlement> {
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final driverTransactionVm = Provider.of<DriverTransactionViewModel>(context, listen: false);
       driverTransactionVm.driverTransactionApi(context);
      Provider.of<ServiceGetBankDetailViewModel>(
        context,
        listen: false,
      ).serviceBankDetailApi(2, context);

    });
  }

  Future<void> _refreshWalletData() async {
    final profileVm =
    Provider.of<DriverProfileViewModel>(context, listen: false);
    final transactionVm =
    Provider.of<DriverTransactionViewModel>(context, listen: false);
    final bankVm =
    Provider.of<ServiceGetBankDetailViewModel>(context, listen: false);

    final position = await LocationUtils.getLocation();

    await profileVm.driverProfileApi(
      position.latitude.toString(),
      position.longitude.toString(),
      context,
    );

    await transactionVm.driverTransactionApi(context);
    await bankVm.serviceBankDetailApi(2, context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          title: TextConst(
            title: loc.wallet_settlements,
            size: 18,
            color:  AppColor.white,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: RefreshIndicator(
          color: AppColor.royalBlue,
          backgroundColor: AppColor.white,
          onRefresh: _refreshWalletData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: Sizes.screenHeight * 0.02,
                ),
                _buildBalanceCard(),
                SizedBox(height: Sizes.screenHeight * 0.02),
                _buildQuickActions(),
                SizedBox(height: 20),
                _buildTransactionHistory(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    final loc = AppLocalizations.of(context)!;
    final profileVm = Provider.of<DriverProfileViewModel>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.screenWidth * 0.045),
      child: AnimatedGradientBorder(
        borderSize: 0.2,
        glowSize: 0,
        gradientColors: [
          AppColor.royalBlue,
          Colors.transparent,
          AppColor.royalBlue,
        ],
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColor.royalBlue.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildWalletCard(
                  title: loc.wallet,
                  amount:
                  "₹${profileVm.driverProfileModel?.data?.wallet ?? "0"}",
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: Colors.green,
                ),
              ),

              Container(
                height: 60,
                width: 1,
                color: Colors.grey.shade300,
              ),

              Expanded(
                child: _buildWalletCard(
                  title: loc.due_wallet,
                  amount:
                  "₹${profileVm.driverProfileModel?.data?.dueWallet ?? "0"}",
                  icon: Icons.pending_actions_rounded,
                  iconColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          amount,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: AppFonts.kanitReg
          ),
        ),

        const SizedBox(height: 4),

        TextConst(
          title: title,
          color: Colors.grey,
          size: 14,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(loc.withdraw, Icons.currency_rupee, _showWithdrawalDialog),
          _buildActionButton(loc.history, Icons.history, (){
            Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverWithdrawHistory()));
          }),
          _buildActionButton(loc.due_wallet, Icons.wallet, _showDueWalletDialog),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.royalBlue.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.royalBlue),
            ),
            child: Icon(icon, color: AppColor.royalBlue, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory() {
    final loc = AppLocalizations.of(context)!;
    final driverTransactionVm = Provider.of<DriverTransactionViewModel>(context);

    final transactions = driverTransactionVm.driverTransactionsModel?.data ?? [];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.recent_transactions,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (driverTransactionVm.loading)
            _transactionShimmerList()

          else if (transactions.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Text(
                  loc.no_transactions_found,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )

          // 🔹 3. DATA FOUND
          else
            ListView.builder(
              itemCount: transactions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final data = transactions[index];

                final int sectionStatus = data.sectionStatus ?? 0;
                final Payment? payment = data.payment;

                final String statusText = _getStatusText(sectionStatus, loc);
                final String paymentStatus = _getPaymentStatus(sectionStatus, loc);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(sectionStatus).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getStatusColor(sectionStatus).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getStatusIcon(sectionStatus),
                          color: _getStatusColor(sectionStatus),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (sectionStatus == 1) ...[
                              _buildTransactionText(loc.amount, payment?.amount, Colors.green),
                              _buildTransactionText(loc.platform_fee, payment?.platformFee, Colors.orange),
                              _buildTransactionText(loc.final_amount, payment?.finalAmount, Colors.blue),
                            ],

                            if (sectionStatus == 2) ...[
                              _buildTransactionText(loc.amount, payment?.amount, Colors.green),
                              SizedBox(height: 5),
                              _buildTransactionText(loc.platform_fee, payment?.platformFee, Colors.orange),
                            ],

                            if (sectionStatus == 3) ...[
                              _buildTransactionText(loc.amount, payment?.amount, Colors.green),
                              _buildTransactionText(loc.platform_fee, payment?.platformFee, Colors.orange),
                            ],

                            if (sectionStatus == 5) ...[
                              _buildTransactionText(loc.amount, payment?.amount, Colors.purple),
                              _buildTransactionText(loc.type, loc.due_wallet, Colors.purple),
                            ],

                            const SizedBox(height: 6),
                            Text(
                              '${loc.txn_id}: ${payment?.id ?? loc.na}',
                              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            ),
                            Text(
                              _formatDate(payment?.paymentDate ?? ''),
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            const SizedBox(height: 6),
                            _buildStatusBadge(statusText, sectionStatus),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${_getDisplayAmount(payment, sectionStatus)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getAmountColor(sectionStatus),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getAmountLabel(sectionStatus, loc),
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                          Text(
                            paymentStatus,
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _transactionShimmerList() {
    return ListView.builder(
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // LEFT ICON SHIMMER
              const ShimmerLoader(
                width: 40,
                height: 40,
                borderRadius: 50,
              ),

              const SizedBox(width: 12),

              // CENTER TEXT SHIMMER
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerLoader(height: 12, width: 120),
                    SizedBox(height: 8),
                    ShimmerLoader(height: 10, width: 80),
                  ],
                ),
              ),

              // RIGHT AMOUNT SHIMMER
              const ShimmerLoader(height: 14, width: 60),
            ],
          ),
        );
      },
    );
  }




  Widget _buildTransactionText(String label, dynamic value, Color color) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: '₹$value',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, int paymentBy) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _getStatusColor(paymentBy).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _getStatusColor(paymentBy).withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(paymentBy),
            size: 10,
            color: _getStatusColor(paymentBy),
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: _getStatusColor(paymentBy),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentStatus(int sectionStatus, AppLocalizations loc) {
    switch (sectionStatus) {
      case 1:
        return loc.online_payment;
      case 2:
        return loc.cash_payment;
      case 3:
        return loc.wallet_payment;
      case 5:
        return loc.paid;
      default:
        return '-';
    }
  }



  String _getStatusText(int sectionStatus, AppLocalizations loc) {
    switch (sectionStatus) {
      case 1:
        return loc.online;
      case 2:
        return loc.offline;
      case 3:
        return loc.wallet;
      case 5:
        return loc.due_cleared;
      default:
        return loc.unknown;
    }
  }



  Color _getStatusColor(int sectionStatus) {
    switch (sectionStatus) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 5:
        return Colors.purple; // due cleared color
      default:
        return Colors.grey;
    }
  }



  IconData _getStatusIcon(int sectionStatus) {
    switch (sectionStatus) {
      case 1:
        return Icons.wifi;
      case 2:
        return Icons.money;
      case 3:
        return Icons.account_balance_wallet;
      case 5:
        return Icons.task_alt;
      default:
        return Icons.help;
    }
  }



  String _getDisplayAmount(Payment? payment, int sectionStatus) {
    if (payment == null) return '0';

    switch (sectionStatus) {
      case 1:
        return payment.finalAmount?.toString() ?? '0';
      case 2:
        return payment.finalAmount?.toString() ?? '0';
      case 3:
        return payment.finalAmount?.toString() ?? '0';
      case 5:
        return payment.finalAmount?.toString() ?? payment.amount?.toString() ?? '0';
      default:
        return '0';
    }
  }



  Color _getAmountColor(int sectionStatus) {
    switch (sectionStatus) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  String _getAmountLabel(int sectionStatus, AppLocalizations loc) {
    switch (sectionStatus) {
      case 1:
        return loc.after_fee;
      case 2:
        return loc.cash_in;
      case 3:
        return loc.wallet;
      case 5:
        return loc.due_paid;
      default:
        return loc.amount;
    }
  }



  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  void _showWithdrawalDialog() {
    final loc = AppLocalizations.of(context)!;
    final profileVm = Provider.of<DriverProfileViewModel>(context,listen: false);
    final getBankVm = Provider.of<ServiceGetBankDetailViewModel>(context,listen: false);
    final driverWithdrawVm = Provider.of<DriverWithdrawRequestViewModel>(context,listen: false);
    final hasBank =
        getBankVm.serviceBankDetailModel?.bankDetails != null;
    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.royalBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.currency_rupee,
                      color: AppColor.royalBlue,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    loc.withdraw_funds,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.royalBlue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColor.royalBlue.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet,
                              color: AppColor.royalBlue, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.available_balance,
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  '₹${profileVm.driverProfileModel?.data?.wallet??"0"}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.royalBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: loc.enter_amount,
                        prefixIcon:
                        Icon(Icons.currency_rupee, color: AppColor.royalBlue),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    if (!hasBank) ...[
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          loc.no_bank_account_added,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        bgColor: AppColor.royalBlue,
                        title: loc.add_bank,
                        onTap: () {
                          Navigator.pop(context);  // Close dialog first
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context) => AddBank()),
                            );
                          });
                        },
                      ),
                    ]
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColor.royalBlue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.account_balance,
                                  color: AppColor.royalBlue, size: 16),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getBankVm.serviceBankDetailModel?.bankDetails?.bankName??"",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  Text(
                                    '${loc.account}: ${getBankVm.serviceBankDetailModel?.bankDetails?.accountNumber??""}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(loc.cancel, style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: driverWithdrawVm.loading
                                ? null
                                : () async {
                              final amount = amountController.text.trim();
                              if (amount.isEmpty) {
                                Utils.showErrorMessage(context, loc.enter_amount);
                                return;
                              }

                              // Run Loader
                              driverWithdrawVm.setLoading(true);
                              setStateDialog(() {});

                              await driverWithdrawVm.driverWithdrawRequestApi(amount, context);

                              driverWithdrawVm.setLoading(false);
                              setStateDialog(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.royalBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: driverWithdrawVm.loading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : TextConst(title: loc.withdraw, color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],

            );
          },
        );
      },
    );
  }

  void _showDueWalletDialog() {
    final loc = AppLocalizations.of(context)!;
    final profileVm = Provider.of<DriverProfileViewModel>(context, listen: false);
    final payment = Provider.of<CabPaymentViewmodel>(context, listen: false);

    final double dueAmount = double.tryParse(
      profileVm.driverProfileModel?.data?.dueWallet?.toString() ?? "0",
    ) ?? 0;

    showDialog(
      context: context,
      builder: (ctx) {

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.royalBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.wallet, color: AppColor.royalBlue, size: 30),
                  ),
                  const SizedBox(height: 8),
                  TextConst(
                    title: loc.due_wallet_payment,
                    size: 20, fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.royalBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.royalBlue.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.pending, color: AppColor.royalBlue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextConst(
                                title: loc.due_wallet_balance,
                                  size: 12, color: Colors.grey
                              ),
                              TextConst(
                                title:
                                "₹$dueAmount",
                                size: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColor.royalBlue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextConst(
                    textAlign: TextAlign.center,
                    title: loc.pay_full_due_wallet,
                    size: 13, color: Colors.grey
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(loc.close,style: TextStyle(color: Colors.black),),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Consumer<CabPaymentViewmodel>(
                        builder: (context, payVm, _) {
                          final isLoading = payVm.loading;

                          return ElevatedButton(
                            onPressed: (dueAmount == 0 || isLoading)
                                ? null
                                : () {
                              payment.cabPaymentApi(
                                dueAmount.toString(),   // full due
                                5,                      // payment mode
                                "",
                                context// serviceOrderId
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.royalBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              "${loc.pay_now} ₹$dueAmount",
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),



                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
