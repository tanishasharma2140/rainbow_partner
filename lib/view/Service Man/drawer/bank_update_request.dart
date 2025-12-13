import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/service_man/service_bank_update_view_model.dart';

class BankUpdateRequest extends StatefulWidget {
  const BankUpdateRequest({super.key});

  @override
  State<BankUpdateRequest> createState() => _BankUpdateRequestState();
}

class _BankUpdateRequestState extends State<BankUpdateRequest> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceBankUpdateViewModel>(
        context,
        listen: false,
      ).serviceBankUpdateApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ServiceBankUpdateViewModel>(context);

    /// 🔹 LOADING STATE
    if (vm.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// 🔹 NO DATA STATE
    if (vm.serviceBankUpdateModel == null ||
        vm.serviceBankUpdateModel!.updateRequest == null) {
      return Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: _appBar(context),
        body: const Center(
          child: TextConst(title: "No update request found"),
        ),
      );
    }

    final request = vm.serviceBankUpdateModel!.updateRequest!;
    final int status = request.status;

    return Scaffold(
      backgroundColor: AppColor.whiteDark,

      appBar: _appBar(context),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 STATUS ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextConst(
                  title: "Request Status",
                  size: 14,
                  fontWeight: FontWeight.w600,
                ),
                _statusChip(status),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔹 DETAILS CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _row("Bank Name", request.bankName),
                  _divider(),
                  _row("Account Holder", request.accountHolderName),
                  _divider(),
                  _row(
                    "Account Number",
                    "XXXX XXXX ${request.accountNumber.substring(request.accountNumber.length - 4)}",
                  ),
                  _divider(),
                  _row("IFSC Code", request.ifscCode),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 DATE CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _dateRow("Requested On", request.createdAt),
                  const Divider(),
                  _dateRow(
                    "Updated On",
                    request.updatedAt ?? "Not updated yet",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 APP BAR
  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.royalBlue,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const TextConst(
        title: "Bank Update Request",
        color: Colors.white,
        size: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// 🔹 SIMPLE ROW
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: TextConst(
              title: title,
              size: 13,
              color: Colors.grey,
            ),
          ),
          TextConst(
            title: value,
            size: 14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.grey.shade300, height: 18);

  /// 🔹 DATE ROW
  Widget _dateRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextConst(title: title, size: 13, color: Colors.grey),
        TextConst(title: value, size: 13, fontWeight: FontWeight.w600),
      ],
    );
  }

  /// 🔹 STATUS CHIP (0=pending,1=approved,2=rejected)
  Widget _statusChip(int status) {
    late Color color;
    late String text;

    switch (status) {
      case 1:
        color = Colors.green;
        text = "Approved";
        break;
      case 2:
        color = Colors.red;
        text = "Rejected";
        break;
      default:
        color = Colors.orange;
        text = "Pending";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextConst(
        title: text,
        size: 12,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
