import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/create_help_desk.dart';

class HelpDesk extends StatefulWidget {
  const HelpDesk({super.key});

  @override
  State<HelpDesk> createState() => _HelpDeskState();
}

class _HelpDeskState extends State<HelpDesk> {
  List<Map<String, dynamic>> helpList = [
    {
      "id": "#12",
      "date": "25/04/2025, 09:46 AM",
      "title": "Payment Not Received",
      "desc": "Customer completed the service but payment is not showing in my wallet.",
      "status": "Open",
      "closedOn": "",
    },
    {
      "id": "#13",
      "date": "25/04/2025, 11:10 AM",
      "title": "Unable to Update Profile",
      "desc": "I am unable to upload my profile photo. It shows an error again and again.",
      "status": "Open",
      "closedOn": "",
    },
    {
      "id": "#14",
      "date": "02/04/2025, 08:45 AM",
      "title": "Booking Canceled Automatically",
      "desc": "Booking was canceled automatically without informing me. Please check the issue.",
      "status": "Open",
      "closedOn": "",
    },
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
               TextConst(
                 title:
                "Help Desk",
                 color: Colors.white,
                 size: 20,
                 fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=> CreateHelpDesk()));
                  },
                  child: const Icon(Icons.add, color: Colors.white, size: 26)),
              const SizedBox(width: 12),
            ],
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: List.generate(helpList.length, (index) {
              final item = helpList[index];
              return helpCard(item);
            }),
          ),
        ),
      ),
    );
  }

  Widget helpCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Stack(
        children: [
          // MAIN CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: AppColor.grey),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),

                // ID
                TextConst(
                  title: data["id"],
                  fontWeight: FontWeight.w700,
                  size: 16,
                  color: Colors.black87,
                ),

                const SizedBox(height: 6),

                TextConst(
                  title: data["date"],
                  color: Colors.black54,
                  size: 12,
                ),

                const SizedBox(height: 10),

                TextConst(
                  title: data["title"],
                  color: Color(0xff0a2d40),
                  size: 15,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 4),

                TextConst(
                  title: data["desc"],
                  color: Colors.black54,
                  size: 13,
                ),

                const SizedBox(height: 12),

                Container(height: 1, color: Colors.grey.shade300),

                const SizedBox(height: 12),

                TextConst(
                  title: "Closed on: —",
                  color: Colors.green,
                  size: 12,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),

          // 🔹 TOP RIGHT STATUS BADGE
          Positioned(
            top: 1,
            right: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextConst(
                title: data["status"],
                color: Colors.white,
                size: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
