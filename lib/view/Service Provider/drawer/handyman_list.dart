import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Provider/drawer/add_handyman.dart';

class HandymanList extends StatefulWidget {
  const HandymanList({super.key});

  @override
  State<HandymanList> createState() => _HandymanListState();
}

class _HandymanListState extends State<HandymanList> {
  final List<Map<String, dynamic>> workers = [
    {
      "name": "Chrysta Ellis",
      "img": "assets/dummy.jpg",
    },
    {
      "name": "Jacky Sam",
      "img": "assets/dummy.jpg",
    },
    {
      "name": "Erica Mendiz",
      "img": "assets/dummy.jpg",
    },
    {
      "name": "Parsa Evana",
      "img": "assets/dummy.jpg",
    },
    {
      "name": "Ebenezer Tipox",
      "img": "assets/dummy.jpg",
    },
    {
      "name": "Brian Shaw",
      "img": "assets/dummy.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
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
                  "Handyman List",
                  color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
          actions:  [
            Padding(
              padding: EdgeInsets.only(right: 18),
              child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=> AddHandyman()));
                  },
                  child: Icon(Icons.add, color: Colors.white, size: 30)),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(14),
          child: GridView.builder(
            itemCount: workers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 18,
              childAspectRatio: 0.66,
            ),
            itemBuilder: (context, index) {
              final user = workers[index];
              return handymanCard(user);
            },
          ),
        ),
      ),
    );
  }

  Widget handymanCard(Map<String, dynamic> user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          // ---------- IMAGE AREA ----------
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: Image.asset(
                  user["img"],
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Power icon
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.power_settings_new,
                      color: Colors.green, size: 22),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ---------- NAME WITH GREEN DOT ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Colors.green, size: 10),
                const SizedBox(width: 6),
                Expanded(
                  child: TextConst(
                    title:
                    user["name"],
                    size: 15,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          // ---------- ACTION BUTTONS ----------
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                roundIcon(Icons.call),
                roundIcon(Icons.email_outlined),
                roundIcon(Icons.message_outlined), // message icon only
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Circular Icon Button ----------
  Widget roundIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xffEEEAFE),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColor.royalBlue),
    );
  }
}
