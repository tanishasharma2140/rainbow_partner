import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/model/driver_transaction_model.dart';
import 'package:rainbow_partner/res/animated_gradient_border.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/shimmer_loader.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_transaction_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/service_get_bank_detail_view_model.dart';

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


  // Static transaction data

  // Static bank details
  // final Map<String, dynamic> bankDetails = {
  //   'hasBank': true,
  //   'bankName': 'HDFC Bank',
  //   'accountNumber': 'XXXXXX4567',
  //   'accountHolder': 'John Doe',
  //   'ifscCode': 'HDFC0001234'
  // };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          title: TextConst(
            title:
            'Wallet & Settlements',
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
        body: SingleChildScrollView(
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
    );
  }

  Widget _buildBalanceCard() {
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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColor.royalBlue.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 8),
              // Total Balance
              Text(
                '₹${profileVm.driverProfileModel?.data?.wallet??"0"}',
                style: TextStyle(
                  color: AppColor.black,
                  fontFamily: AppFonts.kanitReg,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              TextConst(
                title:
                'Total Balance',

              ),
              SizedBox(height: 20),
              // Two wallets
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildWalletItem(
                      'Main Wallet',
                      '₹${profileVm.driverProfileModel?.data?.wallet??"0"}',
                      Icons.account_balance_wallet,
                      Colors.green,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildWalletItem(
                      'Due Wallet',
                      '₹${profileVm.driverProfileModel?.data?.dueWallet??"0"}',
                      Icons.pending,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletItem(
      String title,
      String amount,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.blackLight,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
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
          _buildActionButton('Withdraw', Icons.currency_rupee, _showWithdrawalDialog),
          _buildActionButton('History', Icons.history, _viewHistory),
            // bankDetails['hasBank'] ? 'Bank History' : 'Add Bank',
            // bankDetails['hasBank'] ? Icons.history : Icons.account_balance,
            // bankDetails['hasBank'] ? _goToBankHistory : _addBankAccount,

          _buildActionButton('Due Wallet', Icons.wallet, _showDueWalletDialog),
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
    final driverTransactionVm = Provider.of<DriverTransactionViewModel>(context);

    final transactions = driverTransactionVm.driverTransactionsModel?.data ?? [];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (driverTransactionVm.loading)
            _transactionShimmerList()

          else if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Text(
                  "No Transactions Found",
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

                final String statusText = _getStatusText(sectionStatus);
                final String paymentStatus = _getPaymentStatus(sectionStatus);

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
                              _buildTransactionText('Amount', payment?.amount, Colors.green),
                              _buildTransactionText('Platform Fee', payment?.platformFee, Colors.orange),
                              _buildTransactionText('Final Amount', payment?.finalAmount, Colors.blue),
                            ],

                            if (sectionStatus == 2)
                              _buildTransactionText('Amount', payment?.amount, Colors.green),

                            if (sectionStatus == 3) ...[
                              _buildTransactionText('Amount', payment?.amount, Colors.green),
                              _buildTransactionText('Platform Fee', payment?.platformFee, Colors.orange),
                            ],

                            const SizedBox(height: 6),
                            Text(
                              'Txn ID: ${payment?.id ?? 'N/A'}',
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
                            _getAmountLabel(sectionStatus),
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

  String _getPaymentStatus(int sectionStatus) {
    switch (sectionStatus) {
      case 1:
        return 'Online Payment';
      case 2:
        return 'Offline Payment';
      case 3:
        return 'Wallet Payment';
      default:
        return 'Unknown';
    }
  }


  String _getStatusText(int sectionStatus) {
    switch (sectionStatus) {
      case 1:
        return 'Online';
      case 2:
        return 'Offline';
      case 3:
        return 'Wallet';
      default:
        return 'Unknown';
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
        return payment.amount?.toString() ?? '0';
      case 3:
        return payment.amount?.toString() ?? '0';
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

  String _getAmountLabel(int sectionStatus) {
    switch (sectionStatus) {
      case 1:
        return 'After Fee';
      case 2:
        return 'Total';
      case 3:
        return 'Wallet';
      default:
        return 'Amount';
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
    final profileVm = Provider.of<DriverProfileViewModel>(context,listen: false);
    final getBankVm = Provider.of<ServiceGetBankDetailViewModel>(context,listen: false);
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
                    'Withdraw Funds',
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
                                  'Available Balance',
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
                        labelText: 'Enter Amount',
                        prefixIcon:
                        Icon(Icons.currency_rupee, color: AppColor.royalBlue),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    if (!hasBank)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "No bank account added. Please add a bank account first.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      )
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
                                    'Account: ${getBankVm.serviceBankDetailModel?.bankDetails?.accountNumber??""}',
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
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                          if (amountController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter amount')),
                            );
                            return;
                          }

                          setState(() => isLoading = true);
                          await Future.delayed(
                              Duration(seconds: 2)); // Simulate API call
                          setState(() => isLoading = false);

                          amountController.clear();
                          Navigator.pop(context);
                          _showSuccessDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.royalBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                            : TextConst(title: 'Withdraw', color: Colors.white),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text('Success!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Withdrawal request submitted successfully!',
                textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _addBankAccount() {
    // Simple dialog for demo
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Bank Account'),
        content: Text('Bank account addition page would open here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _viewHistory() {
    // Simple dialog for demo
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Withdrawal History'),
        content: Text('Withdrawal history page would open here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // void _goToBankHistory() {
  //   // Simple dialog for demo
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Bank History'),
  //       content: Text('Bank transaction history page would open here'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showDueWalletDialog() {
    final profileVm = Provider.of<DriverProfileViewModel>(context,listen: false);
    final TextEditingController dueAmountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;

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
                      Icons.wallet,
                      color: AppColor.royalBlue,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Due Wallet Payment',
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
                          Icon(Icons.pending, color: AppColor.royalBlue, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Due Wallet Balance',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  '₹${profileVm.driverProfileModel?.data?.dueWallet??"0"}',
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
                      controller: dueAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Due Amount',
                        hintText:
                        'Maximum: ₹${profileVm.driverProfileModel?.data?.dueWallet ?? "0"}',
                        prefixIcon:
                        const Icon(Icons.currency_rupee, color: AppColor.royalBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter amount';
                        }

                        final enteredAmount = double.tryParse(value);
                        if (enteredAmount == null) {
                          return 'Enter valid amount';
                        }

                        final maxDue = double.tryParse(
                          profileVm.driverProfileModel?.data?.dueWallet?.toString() ?? "0",
                        ) ??
                            0;

                        if (enteredAmount > maxDue) {
                          return 'Amount cannot exceed due balance';
                        }

                        if (enteredAmount <= 0) {
                          return 'Amount must be greater than zero';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Enter the amount you want to pay from your due wallet.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                          if (dueAmountController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter amount')),
                            );
                            return;
                          }

                          final amount = double.tryParse(dueAmountController.text);
                          if (amount == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enter valid amount')),
                            );
                            return;
                          }

                          // if (amount > dueBalance) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(content: Text('Amount exceeds due balance')),
                          //   );
                          //   return;
                          // }

                          setState(() => isLoading = true);
                          await Future.delayed(Duration(seconds: 2));
                          setState(() => isLoading = false);

                          dueAmountController.clear();
                          Navigator.pop(context);

                          // Show success dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.green, size: 60),
                                  SizedBox(height: 16),
                                  Text('Payment Successful!',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('₹$amount paid from due wallet.',
                                      textAlign: TextAlign.center),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.royalBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                            : Text('Pay Now', style: TextStyle(color: Colors.white)),
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