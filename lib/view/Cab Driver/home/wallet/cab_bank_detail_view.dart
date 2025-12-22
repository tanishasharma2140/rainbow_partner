import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/model/service_bank_detail_model.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab Driver/home/wallet/cab_edit_bank_page.dart';
import 'package:rainbow_partner/view_model/service_man/service_get_bank_detail_view_model.dart';

class CabBankDetailView extends StatefulWidget {
  const CabBankDetailView({super.key});

  @override
  State<CabBankDetailView> createState() => _CabBankDetailViewState();
}

class _CabBankDetailViewState extends State<CabBankDetailView> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceGetBankDetailViewModel>(
        context,
        listen: false,
      ).serviceBankDetailApi(2, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          title:  TextConst(
            title:
            'Bank Details',
            size: 17,
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.white),
            onPressed: () => Navigator.pop(context),
          ),

          // ---------- EDIT BUTTON (SAFE) ----------
          actions: [
            Consumer<ServiceGetBankDetailViewModel>(
              builder: (context, vm, _) {
                if (vm.serviceBankDetailModel?.bankDetails == null) {
                  return const SizedBox();
                }

                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CabEditBankPage(
                          bankDetails:
                          vm.serviceBankDetailModel!.bankDetails!,
                        ),
                      ),
                    );
                  },
                  child: const TextConst(
                    title: "Edit",
                    color: AppColor.white,
                    size: 14,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),

        // ================= BODY =================
        body: Consumer<ServiceGetBankDetailViewModel>(
          builder: (context, vm, _) {

            // 🔄 LOADING STATE
            if (vm.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // 🚫 NO DATA STATE
            if (vm.serviceBankDetailModel == null ||
                vm.serviceBankDetailModel!.bankDetails == null) {
              return const Center(
                child: Text(
                  "No Bank Details Found",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            // ✅ DATA FOUND
            return bankDataFound(vm.serviceBankDetailModel!.bankDetails!);
          },
        ),
      ),
    );
  }

  // ================= BANK DATA UI =================

  Widget bankDataFound(BankDetails bank) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          // ---------- HEADER CARD ----------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.royalBlue,
                  AppColor.royalBlue.withOpacity(0.75),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColor.royalBlue.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user,
                    color: AppColor.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextConst(
                        title: 'Bank Account Verified',
                        size: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                      ),
                      SizedBox(height: 2),
                      TextConst(
                        title: 'Your account is ready for withdrawals',
                        size: 13,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------- BANK DETAILS CARD ----------
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [

                _buildListTile(
                  icon: Icons.person,
                  title: 'Account Holder Name',
                  value: bank.accountHolderName ?? "--",
                ),

                _buildListTile(
                  icon: Icons.account_balance,
                  title: 'Bank Name',
                  value: bank.bankName ?? "--",
                ),

                _buildListTile(
                  icon: Icons.credit_card,
                  title: 'Account Number',
                  value: _maskAccountNumber(bank.accountNumber ?? ""),
                ),

                _buildListTile(
                  icon: Icons.code,
                  title: 'IFSC Code',
                  value: bank.ifscCode ?? "--",
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= LIST TILE =================

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String value,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.royalBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColor.royalBlue, size: 20),
        ),
        title: TextConst(
          title: title,
          size: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        subtitle: TextConst(
          title: value,
          size: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ================= MASK ACCOUNT =================

  String _maskAccountNumber(String accountNumber) {
    if (accountNumber.isEmpty || accountNumber.length <= 4) {
      return accountNumber.isEmpty ? "--" : accountNumber;
    }
    return 'XXXX XXXX ${accountNumber.substring(accountNumber.length - 4)}';
  }
}
