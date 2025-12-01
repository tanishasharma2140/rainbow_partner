import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Provider/drawer/add_bank.dart';
import 'package:rainbow_partner/view/Service%20Provider/home/service/add_services.dart';

class BankDetail extends StatefulWidget {
  const BankDetail({super.key});

  @override
  State<BankDetail> createState() => _BankDetailState();
}

class _BankDetailState extends State<BankDetail> {
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
                  "Bank List",
                  color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
          actions:  [
            Padding(
              padding: EdgeInsets.only(right: 18),
              child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=> AddBank()));
                  },
                  child: Icon(Icons.add, color: Colors.white, size: 30)),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     TextConst(
                       title:
                      "ITB Bank",
                       size: 18,
                       fontWeight: FontWeight.w600,
                    ),

                    const SizedBox(height: 8),

                     TextConst(
                       title:
                      "******7890",
                       size: 16,
                       color: Colors.black54,
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        // EDIT
                        GestureDetector(
                          onTap: () {},
                          child:  TextConst(
                            title:
                            "Edit",
                            size: 16,
                            color: AppColor.royalBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 14),
                        const Text("|", style: TextStyle(color: Colors.grey)),

                        // DELETE
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: () {},
                          child:  TextConst(
                            title:
                            "Delete",
                            size: 16,
                            color: AppColor.royalBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
