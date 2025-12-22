import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/animated_gradient_border.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_text_field.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';

class WalletSettlement extends StatefulWidget {
  const WalletSettlement({super.key});

  @override
  State<WalletSettlement> createState() => _WalletSettlementState();
}

class _WalletSettlementState extends State<WalletSettlement> {
  final TextEditingController amountController = TextEditingController();

  final double walletBalance = 15250.00;
  final double dueBalance = 3250.00;
  final double totalBalance = 18500.00;

  // Static transaction data
  final List<Map<String, dynamic>> transactions = [
    {
      'id': '1',
      'type': 'Online Payment',
      'paymentBy': 1,
      'totalAmount': '2000.00',
      'platformFee': '100.00',
      'amount': '1900.00',
      'orderId': 'ORD-2024-001',
      'createdAt': '2024-01-15T10:30:00Z',
      'status': 'Completed'
    },
    {
      'id': '2',
      'type': 'Due Payment',
      'paymentBy': 2,
      'totalAmount': '1500.00',
      'platformFee': '0.00',
      'amount': '1500.00',
      'orderId': 'ORD-2024-002',
      'createdAt': '2024-01-14T14:45:00Z',
      'status': 'Pending'
    },
    {
      'id': '3',
      'type': 'Offline Payment',
      'paymentBy': 3,
      'totalAmount': '3000.00',
      'platformFee': '150.00',
      'amount': '2850.00',
      'orderId': 'ORD-2024-003',
      'createdAt': '2024-01-13T09:15:00Z',
      'status': 'Completed'
    },
    {
      'id': '4',
      'type': 'Online Payment',
      'paymentBy': 1,
      'totalAmount': '1200.00',
      'platformFee': '60.00',
      'amount': '1140.00',
      'orderId': 'ORD-2024-004',
      'createdAt': '2024-01-12T16:20:00Z',
      'status': 'Completed'
    },
    {
      'id': '5',
      'type': 'Due Payment',
      'paymentBy': 2,
      'totalAmount': '800.00',
      'platformFee': '0.00',
      'amount': '800.00',
      'orderId': 'ORD-2024-005',
      'createdAt': '2024-01-11T11:10:00Z',
      'status': 'Pending'
    },
  ];

  // Static bank details
  final Map<String, dynamic> bankDetails = {
    'hasBank': true,
    'bankName': 'HDFC Bank',
    'accountNumber': 'XXXXXX4567',
    'accountHolder': 'John Doe',
    'ifscCode': 'HDFC0001234'
  };

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
                '₹${totalBalance.toStringAsFixed(2)}',
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
                      '₹${walletBalance.toStringAsFixed(2)}',
                      Icons.account_balance_wallet,
                      Colors.green,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildWalletItem(
                      'Due Wallet',
                      '₹${dueBalance.toStringAsFixed(2)}',
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (transactions.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "No Transactions Found",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 400,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return _buildTransactionItem(transaction);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    int paymentBy = transaction['paymentBy'] ?? 1;
    String paymentStatus = _getPaymentStatus(paymentBy);
    String statusText = _getStatusText(paymentBy);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(paymentBy).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getStatusColor(paymentBy).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(paymentBy),
              color: _getStatusColor(paymentBy),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (paymentBy == 1) ...[
                  _buildTransactionText('Total Amount', transaction['totalAmount'], Colors.green),
                  SizedBox(height: 2),
                  _buildTransactionText('Platform Fee', transaction['platformFee'], Colors.orange),
                  SizedBox(height: 2),
                  _buildTransactionText('Final Amount', transaction['amount'], Colors.blue),
                ],
                if (paymentBy == 2) ...[
                  _buildTransactionText('Total Amount', transaction['totalAmount'], Colors.green),
                ],
                if (paymentBy == 3) ...[
                  _buildTransactionText('Total Amount', transaction['totalAmount'], Colors.green),
                  SizedBox(height: 2),
                  _buildTransactionText('Platform Fee', transaction['platformFee'], Colors.orange),
                ],

                SizedBox(height: 4),
                Text(
                  transaction['orderId'] ?? 'N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColor.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _formatDate(transaction['createdAt']),
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                SizedBox(height: 6),
                _buildStatusBadge(statusText, paymentBy),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${_getDisplayAmount(transaction, paymentBy)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getAmountColor(paymentBy),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _getAmountLabel(paymentBy),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              SizedBox(height: 2),
              Text(
                paymentStatus,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
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

  String _getPaymentStatus(int paymentBy) {
    switch (paymentBy) {
      case 1:
        return 'Online Payment';
      case 2:
        return 'Due Payment';
      case 3:
        return 'Offline Payment';
      default:
        return 'Unknown';
    }
  }

  String _getStatusText(int paymentBy) {
    switch (paymentBy) {
      case 1:
        return 'Online';
      case 2:
        return 'Due';
      case 3:
        return 'Offline';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int paymentBy) {
    switch (paymentBy) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(int paymentBy) {
    switch (paymentBy) {
      case 1:
        return Icons.online_prediction;
      case 2:
        return Icons.pending;
      case 3:
        return Icons.offline_pin;
      default:
        return Icons.help;
    }
  }

  String _getDisplayAmount(Map<String, dynamic> transaction, int paymentBy) {
    switch (paymentBy) {
      case 1:
        return transaction['amount'] ?? '0.00';
      case 2:
        return transaction['totalAmount'] ?? '0.00';
      case 3:
        return transaction['amount'] ?? '0.00';
      default:
        return '0.00';
    }
  }

  Color _getAmountColor(int paymentBy) {
    switch (paymentBy) {
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

  String _getAmountLabel(int paymentBy) {
    switch (paymentBy) {
      case 1:
        return 'After Fee';
      case 2:
        return 'Total';
      case 3:
        return 'Total';
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
                                  '₹${walletBalance.toStringAsFixed(2)}',
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
                    if (!bankDetails['hasBank'])
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
                                    bankDetails['bankName'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  Text(
                                    'Account: ${bankDetails['accountNumber']}',
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
                          if (!bankDetails['hasBank']) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Please add bank account first')),
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
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.wallet,
                      color: Colors.orange,
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
                        color: Colors.orange.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.pending, color: Colors.orange, size: 20),
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
                                  '₹${dueBalance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
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
                      decoration: InputDecoration(
                        labelText: 'Enter Due Amount',
                        hintText: 'Maximum: ₹${dueBalance.toStringAsFixed(2)}',
                        prefixIcon: Icon(Icons.currency_rupee, color: Colors.orange),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Enter valid amount';
                        }
                        if (amount > dueBalance) {
                          return 'Amount cannot exceed due balance';
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

                          if (amount > dueBalance) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Amount exceeds due balance')),
                            );
                            return;
                          }

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
                          backgroundColor: Colors.orange,
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