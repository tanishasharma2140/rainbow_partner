import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_drawer.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Provider/home/service/all_services_page.dart';
import 'package:rainbow_partner/view/Service%20Provider/home/service/total_booking.dart';
import 'package:rainbow_partner/view/Service%20Provider/home/service/total_revenue_earning.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({super.key});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> services = [
    {
      "img": "assets/ac_maintenance.png",
      "tag": "AC MAINTENANCE",
      "price": "\₹15.00",
      "title": "Filter Replacement"
    },
    {
      "img": "assets/home_sanitizing.png",
      "tag": "RESIDENTIAL SAN",
      "price": "\₹43.00",
      "title": "Full Home Sanitization"
    },
    {
      "img": "assets/office_cleaning.png",
      "tag": "HOUSE & OFFICE",
      "price": "\₹32.00",
      "title": "Office Cleaning"
    },
    {
      "img": "assets/custom_cake_creation.png",
      "tag": "BAKING AND PASTRY",
      "price": "\₹35.00/hr",
      "title": "Custom Cake Creation"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(width: 18,),
              TextConst(
                  title:
                  "Provider Home",
                  color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
          actions:  [
            Padding(
              padding: EdgeInsets.only(right: 18),
              child:
              GestureDetector(
                  onTap: (){
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: Icon(Icons.menu, color: Colors.white, size: 30)),
            ),
          ],
        ),

        // ---------------- BODY ----------------
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // GREETINGS
                 TextConst(
                   title:
                  "Hello, Felix Harris",
                     size: 18, fontWeight: FontWeight.w600
                ),
                const SizedBox(height: 3),
                TextConst(
                  title:
                  "Welcome back!",
                    size: 13,
                    color: Colors.grey.shade600,
                    fontFamily: AppFonts.poppinsReg
                ),

                const SizedBox(height: 25),

                // TOTAL CASH BOX
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColor.royalBlue,
                        child: const Icon(Icons.account_balance_wallet,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: TextConst(
                          title:
                          "Total Cash in Hand",
                          size: 16,
                        ),
                      ),
                      TextConst(
                        title:
                        "\₹0.00",
                          size: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.royalBlue
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: statBox(
                        value: "3",
                        title: "Total Bookings",
                        icon: Icons.confirmation_num_outlined,
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context)=>TotalBooking()));
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: statBox(
                        value: "6",
                        title: "Total Service",
                        icon: Icons.list_alt_outlined,
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context)=> AllServicesPage()));
                        }
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ---------------- STATS ROW 2 ----------------
                Row(
                  children: [
                    Expanded(
                      child: statBox(
                        value: "₹0.00",
                        title: "Remaining Payout",
                        icon: Icons.access_time,
                        onTap: (){}
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: statBox(
                        value: "₹0.00",
                        title: "Total Revenue",
                        icon: Icons.monetization_on_outlined,
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context)=> TotalRevenueEarning()));
                        }
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // ---------------- MY SERVICES ----------------
                TextConst(
                  title:
                  "My Services",
                    size: 18, fontWeight: FontWeight.w700
                ),

                const SizedBox(height: 15),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.73),
                  itemBuilder: (context, index) {
                    return serviceCard(services[index]);
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget serviceCard(Map<String, dynamic> data) {
    return Container(
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
              // IMAGE
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: Image.asset(
                  data["img"],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // 🔵 CATEGORY TAG WITH MARQUEE
              Positioned(
                top: 8,
                left: 8,
                right: 8,
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
                    blankSpace: 50,
                    pauseAfterRound: const Duration(milliseconds: 800),
                    style: TextStyle(
                      color: AppColor.royalBlue,
                      fontSize: 11,
                      fontFamily: AppFonts.kanitReg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // PRICE TAG
              Positioned(
                bottom: 8,     // 👈 FIX — ab image ke andar sahi jagah dikhega
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.royalBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextConst(
                    title:
                    data["price"],
                    color: Colors.white,
                    size: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
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
            height: 22,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Marquee(
                text: data["title"],
                velocity: 30,
                blankSpace: 40,
                pauseAfterRound: const Duration(seconds: 1),
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: AppFonts.kanitReg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget statBox({
    required String value,
    required String title,
    required IconData icon,
    required VoidCallback onTap,   // 👈 NEW PARAMETER
  }) {
    return GestureDetector(
      onTap: onTap,   // 👈 CALL HERE
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.royalBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextConst(
                  title: value,
                  size: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(icon, color: AppColor.royalBlue, size: 18),
                ),
              ],
            ),

            const Spacer(),

            TextConst(
              title: title,
              color: Colors.white,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

}
