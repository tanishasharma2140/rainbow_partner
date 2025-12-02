import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Provider/home/service/add_services.dart';

import 'all_service_detail.dart';

class AllServicesPage extends StatefulWidget {
  const AllServicesPage({super.key});

  @override
  State<AllServicesPage> createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage> {
  int selectedTab = 0;

  final List<String> tabs = ["All", "Pending", "Approved", "Rejected"];

  final List<Map<String, dynamic>> services = [
    {
      "img": "assets/ac_maintenance.png",
      "tag": "AC MAINTENANCE",
      "price": "\₹15.00",
      "title": "Filter Replacement",
      "status": "pending"
    },
    {
      "img": "assets/home_sanitizing.png",
      "tag": "HOME SANITIZATION",
      "price": "\₹43.00",
      "title": "Full Home Sanitization",
      "status": "approved"
    },
    {
      "img": "assets/office_cleaning.png",
      "tag": "OFFICE CLEANING",
      "price": "\₹32.00",
      "title": "Office Cleaning",
      "status": "rejected"
    },
    {
      "img": "assets/custom_cake_creation.png",
      "tag": "BAKING AND PASTRY",
      "price": "\₹35.00/hr",
      "title": "Custom Cake Creation",
      "status": "approved"
    },
    {
      "img": "assets/seam_repair.png",
      "tag": "CLOTHING ALTERATIONS",
      "price": "\₹45.00/hr",
      "title": "Seam Repair & Reinforcement",
      "status": "pending"
    },
    {
      "img": "assets/facial.png",
      "tag": "SKIN CARE & FACIAL",
      "price": "\₹28.00",
      "title": "Exfoliation and Peels",
      "status": "approved"
    },
  ];

  // ------------------------- FILTER LIST -------------------------
  List<Map<String, dynamic>> get filteredServices {
    if (selectedTab == 0) return services;
    if (selectedTab == 1) return services.where((s) => s["status"] == "pending").toList();
    if (selectedTab == 2) return services.where((s) => s["status"] == "approved").toList();
    return services.where((s) => s["status"] == "rejected").toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                "All Service",
                   color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
          actions:  [
            Padding(
              padding: EdgeInsets.only(right: 18),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> AddServices()));
                },
                  child: Icon(Icons.add, color: Colors.white, size: 30)),
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),

                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here...",
                      hintStyle: TextStyle(fontFamily: AppFonts.kanitReg),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      bool isSelected = selectedTab == index;

                      return GestureDetector(
                        onTap: () => setState(() => selectedTab = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xffEAE8FF) : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppColor.royalBlue : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? AppColor.royalBlue : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------------- NO DATA + GRID VIEW -------------------------
                if (filteredServices.isEmpty) ...[
                  const SizedBox(height: 80),

                  SizedBox(
                    width: double.infinity,   // 👈 full width mil jayegi
                    child: Center(
                      child: Text(
                        "No data available",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ]
                else ...[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredServices.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      return serviceCard(filteredServices[index]);
                    },
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------- SERVICE CARD -------------------------
  Widget serviceCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AllServiceDetail(
              img: data["img"],
              title: data["title"],
              price: data["price"],
              tag: data["tag"],
              rating: "0.0",
              duration: "30 min",
              description:
              "Breathe clean air. We promptly replace filters, improving air quality and ensuring efficient circulation throughout your space.",
              location: "Lucknow, India",
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: Image.asset(
                    data["img"],
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // CATEGORY TAG
                Positioned(
                  top: 8,
                  left: 8,
                  right: 60,
                  child: Container(
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Marquee(
                      text: data["tag"],
                      velocity: 30,
                      blankSpace: 40,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff6D7BFB),
                      ),
                    ),
                  ),
                ),

                // PRICE TAG
                Positioned(
                  top: 110,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xff6D7BFB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data["price"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // STAR RATING
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: List.generate(
                  5,
                      (i) => const Icon(Icons.star_border, size: 16, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // TITLE MARQUEE
            SizedBox(
              height: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Marquee(
                  text: data["title"],
                  velocity: 30,
                  blankSpace: 40,
                  pauseAfterRound: const Duration(milliseconds: 800),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
