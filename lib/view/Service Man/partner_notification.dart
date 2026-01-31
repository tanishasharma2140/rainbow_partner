import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/shimmer_loader.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/cabdriver/partner_notification_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class PartnerNotification extends StatefulWidget {
  const PartnerNotification({super.key});

  @override
  State<PartnerNotification> createState() => _PartnerNotificationState();
}

class _PartnerNotificationState extends State<PartnerNotification> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();
      Provider.of<PartnerNotificationViewModel>(
        context,
        listen: false,
      ).partnerNotificationApi(4,userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PartnerNotificationViewModel>(context);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          centerTitle: true,
          title: TextConst(
            title: 'Notifications',
            size: 18,
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        body: vm.loading
            ? _buildShimmerLoader()
            : vm.partnerNotificationModel == null ||
            (vm.partnerNotificationModel?.data?.isEmpty ?? true)
            ? _buildEmptyState()
            : _buildNotificationList(vm),
      ),
    );
  }

  // ---------------------------
  // 1️⃣ SHIMMER LOADER
  // ---------------------------
  Widget _buildShimmerLoader() {
    final vm = Provider.of<PartnerNotificationViewModel>(context);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        return Row(
          children: [
            const ShimmerLoader(width: 40, height: 40, borderRadius: 50),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerLoader(width: 180, height: 14),
                  SizedBox(height: 8),
                  ShimmerLoader(width: 120, height: 12),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(
            width: 180,
            height: 180,
            child: Image(
              image: AssetImage('assets/no_notification.png'),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 24),
          TextConst(
            title: "You are all up to date",
            size: 20,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.poppinsReg,
            textAlign: TextAlign.center,
          ),
          TextConst(
            title: "No new notifications — come back soon",
            size: 15,
            color: Colors.black54,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // 3️⃣ NOTIFICATION LIST
  // ---------------------------
  Widget _buildNotificationList(PartnerNotificationViewModel vm) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: vm.partnerNotificationModel!.data!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final notify = vm.partnerNotificationModel!.data![index];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  "assets/notificaion.gif",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextConst(
                      title: notify.title ?? "",
                      size: 15,
                      fontWeight: FontWeight.w600,
                    ),

                    if (notify.text != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: TextConst(
                          title: notify.text!,
                          size: 13,
                          color: Colors.black87,
                        ),
                      ),

                    const SizedBox(height: 4),

                    TextConst(
                      title: notify.timeAgo ?? "",
                      size: 11,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
