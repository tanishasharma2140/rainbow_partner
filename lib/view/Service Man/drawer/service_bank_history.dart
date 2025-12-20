import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/model/service_bank_detail_model.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_edit_bank_page.dart';
import 'package:rainbow_partner/view_model/service_man/service_get_bank_detail_view_model.dart';

class ServiceBankHistory extends StatefulWidget {
  const ServiceBankHistory({super.key});

  @override
  State<ServiceBankHistory> createState() => _ServiceBankHistoryState();
}

class _ServiceBankHistoryState extends State<ServiceBankHistory> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceGetBankDetailViewModel>(
        context,
        listen: false,
      ).serviceBankDetailApi(context);
    });
  }

  String maskAccount(String number) {
    return "XXXX XXXX ${number.substring(number.length - 4)}";
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ServiceGetBankDetailViewModel>(context);

    if (vm.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.serviceBankDetailModel == null ||
        vm.serviceBankDetailModel!.bankDetails == null) {
      return const Scaffold(
        body: Center(child: TextConst(title: "No bank details found")),
      );
    }

    final BankDetails bank = vm.serviceBankDetailModel!.bankDetails!;

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        backgroundColor: AppColor.royalBlue,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: AppColor.white,)),
        title: const TextConst(
          title: "Bank Details",
          color: Colors.white,
          size: 18,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceEditBankPage(bankDetails: bank),
                ),
              );
            },
            child: const TextConst(
              title: "Edit",
              color: Colors.white,
              size: 14,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔷 HEADER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.royalBlue,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextConst(
                          title: "Bank Name",
                          color: Colors.white70,
                          size: 12,
                        ),
                        const SizedBox(height: 4),
                        TextConst(
                          title: bank.bankName,
                          color: Colors.white,
                          size: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔷 DETAILS
            _detailTile("Account Holder", bank.accountHolderName, Icons.person),
            _detailTile(
              "Account Number",
              maskAccount(bank.accountNumber),
              Icons.credit_card,
            ),
            _detailTile("IFSC Code", bank.ifscCode, Icons.confirmation_number),
          ],
        ),
      ),
    );
  }

  Widget _detailTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.royalBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor.royalBlue),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextConst(title: title, size: 12, color: Colors.grey),
              const SizedBox(height: 4),
              TextConst(
                title: value,
                size: 15,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
