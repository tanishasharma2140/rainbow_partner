import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/cabdriver/check_payment_status_view_model.dart';

import '../../view_model/service_man/service_check_payment_status_view_model.dart';

class ServiceQrScreen extends StatefulWidget {
  final String qrImage;
  final dynamic amount;
  final dynamic orderId;
  final dynamic serviceOrderId;

  const ServiceQrScreen({
    super.key,
    required this.qrImage,
    this.amount, this.orderId, this.serviceOrderId,
  });

  @override
  State<ServiceQrScreen> createState() => _ServiceQrScreenState();
}

class _ServiceQrScreenState extends State<ServiceQrScreen> {
  Timer? paymentTimer;
  @override
  void dispose() {
    paymentTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final paymentStatus = Provider.of<ServiceCheckPaymentStatusViewModel>(context, listen: false);
      paymentStatus.serviceCheckPaymentStatusApi(widget.orderId, widget.serviceOrderId, context);

      paymentTimer = Timer.periodic(
        const Duration(seconds: 3),
            (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }

          debugPrint("🔥 PAYMENT STATUS API HIT");

          paymentStatus.serviceCheckPaymentStatusApi(
            widget.orderId,
            widget.serviceOrderId,
            context,
          );
        },
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title:  TextConst(
          title:
          loc.scan_pay,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          size: 18,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextConst(
                title:
                loc.show_this_qr_to_customer,
                size: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),

              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue.shade100,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              base64Decode(widget.qrImage),
                              height: 220,
                              width: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Corner accents
                        ..._buildCornerAccents(),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Divider(height: 1),

                    const SizedBox(height: 20),

                    // ── Amount Section ──────────────────
                    TextConst(
                      title:
                      loc.amount_to_collect,
                      size: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),

                    const SizedBox(height: 6),

                    TextConst(
                      title:
                      "₹${widget.amount ?? '0'}",
                      size: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),

                    const SizedBox(height: 12),

                    // ── Status Chip ─────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 14, color: Colors.orange.shade700),
                          const SizedBox(width: 6),
                          TextConst(
                            title:
                            loc.waiting_for_payment,
                            size: 12,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Info Note ──────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: Colors.blue.shade600, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextConst(
                        title:
                        loc.ask_customer_scan_qr,
                        size: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCornerAccents() {
    const size = 20.0;
    const thickness = 3.0;
    const color = Colors.blue;
    const radius = 6.0;

    Widget corner({
      bool top = true,
      bool left = true,
    }) {
      return Positioned(
        top: top ? 0 : null,
        bottom: top ? null : 0,
        left: left ? 0 : null,
        right: left ? null : 0,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border(
              top: top
                  ? const BorderSide(color: color, width: thickness)
                  : BorderSide.none,
              bottom: !top
                  ? const BorderSide(color: color, width: thickness)
                  : BorderSide.none,
              left: left
                  ? const BorderSide(color: color, width: thickness)
                  : BorderSide.none,
              right: !left
                  ? const BorderSide(color: color, width: thickness)
                  : BorderSide.none,
            ),
            borderRadius: BorderRadius.only(
              topLeft: top && left ? const Radius.circular(radius) : Radius.zero,
              topRight: top && !left ? const Radius.circular(radius) : Radius.zero,
              bottomLeft: !top && left ? const Radius.circular(radius) : Radius.zero,
              bottomRight: !top && !left ? const Radius.circular(radius) : Radius.zero,
            ),
          ),
        ),
      );
    }

    return [
      corner(top: true, left: true),
      corner(top: true, left: false),
      corner(top: false, left: true),
      corner(top: false, left: false),
    ];
  }
}