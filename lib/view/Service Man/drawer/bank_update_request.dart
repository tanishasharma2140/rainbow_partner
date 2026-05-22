import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
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
      ).serviceBankUpdateApi(1,context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ServiceBankUpdateViewModel>(context);
    final loc = AppLocalizations.of(context)!;

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
        appBar: _appBar(context, loc),
        body: Center(
          child: TextConst(title: loc.no_update_request_found),
        ),
      );
    }

    final request = vm.serviceBankUpdateModel!.updateRequest!;
    final int status = request.status;

    return Scaffold(
      backgroundColor: AppColor.whiteDark,

      appBar: _appBar(context, loc),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 STATUS ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextConst(
                  title: loc.request_status,
                  size: 14,
                  fontWeight: FontWeight.w600,
                ),
                _statusChip(status, loc),
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
                  _row(loc.bank_name, request.bankName),
                  _divider(),
                  _row(loc.account_holder, request.accountHolderName),
                  _divider(),
                  _row(
                    loc.account_number,
                    request.accountNumber.length > 4 ? "XXXX XXXX ${request.accountNumber.substring(request.accountNumber.length - 4)}" : request.accountNumber,
                  ),
                  _divider(),
                  _row(loc.ifsc_code, request.ifscCode),
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
                  _dateRow(loc.requested_on, request.createdAt),
                  const Divider(),
                  _dateRow(
                    loc.updated_on,
                    request.updatedAt ?? loc.not_updated_yet,
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
  AppBar _appBar(BuildContext context, AppLocalizations loc) {
    return AppBar(
      backgroundColor: AppColor.royalBlue,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: TextConst(
        title: loc.bank_update_request,
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
  Widget _statusChip(int status, AppLocalizations loc) {
    late Color color;
    late String text;

    switch (status) {
      case 1:
        color = Colors.green;
        text = loc.approved;
        break;
      case 2:
        color = Colors.red;
        text = loc.rejected;
        break;
      default:
        color = Colors.orange;
        text = loc.pending;
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
