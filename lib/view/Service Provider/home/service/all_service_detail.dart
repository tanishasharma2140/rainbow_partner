import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';

class AllServiceDetail extends StatefulWidget {
  final String img;
  final String title;
  final String price;
  final String tag;
  final String rating;
  final String duration;
  final String description;
  final String location;

  const AllServiceDetail({
    super.key,
    required this.img,
    required this.title,
    required this.price,
    required this.tag,
    required this.rating,
    required this.duration,
    required this.description,
    required this.location,
  });

  @override
  State<AllServiceDetail> createState() => _AllServiceDetailState();
}

class _AllServiceDetailState extends State<AllServiceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: Image.asset(
                    widget.img,
                    fit: BoxFit.cover,
                  ),
                ),

                // Back Button
                Positioned(
                  top: 40,
                  left: 20,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),


                // Small Preview Image
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: Container(
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 4),
                      image: DecorationImage(
                        image: AssetImage(widget.img),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),


            // ------------------ DETAILS CARD ------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  TextConst(
                    title: widget.title,
                    size: 20,
                    fontWeight: FontWeight.w600,
                  ),

                  // const SizedBox(height: 4),

                  TextConst(
                    title: widget.price,
                    size: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColor.royalBlue,
                  ),

                  const SizedBox(height: 4),

                  // Duration & Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                           TextConst(
                             title:
                            "Duration: ",
                             size: 14, color: Colors.grey,
                          ),
                          TextConst(
                            title:
                            widget.duration,
                              size: 13, fontWeight: FontWeight.w600
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          const Icon(Icons.star, size: 22, color: Colors.amber),
                          const SizedBox(width: 4),
                          TextConst(
                            title:
                            widget.rating,
                            size: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Description
                   TextConst(
                     title:
                    "Description",
                       size: 16, fontWeight: FontWeight.w700
                  ),
                  const SizedBox(height: 4),
                  TextConst(
                    title:
                    widget.description,
                    size: 13,
                    color: Colors.grey.shade700,
                  ),

                  const SizedBox(height: 25),

                  // Location
                   TextConst(
                     title:
                    "Available Location",
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                    ),
                    child: TextConst(
                      title:
                      widget.location,
                        size: 14, fontWeight: FontWeight.w600
                    ),
                  ),

                  const SizedBox(height: 25),

                  // FAQ Box
// ------------------- FAQs ---------------------
                  TextConst(
                    title: "FAQs",
                    size: 16,
                    fontWeight: FontWeight.w500,
                  ),

                  const SizedBox(height: 12),

                  _FAQItem(
                    question: "How often should I replace my AC filter?",
                    answer:
                    "For optimal performance, replace your AC filter every 1 to 3 months. "
                        "However, factors like usage and filter type may impact the frequency. "
                        "Regular checks ensure a healthier and more efficient system.",
                  ),

                  const SizedBox(height: 10),

                  _FAQItem(
                    question: "Can I clean my AC filter instead of replacing it?",
                    answer:
                    "Yes, some washable filters can be cleaned, but replacing them ensures "
                        "better air quality and efficiency. Always check your filter type.",
                  ),

                  const SizedBox(height: 20),
                  TextConst(title: "Reviews (0)",fontWeight: FontWeight.w500,size: 16,),
                  const SizedBox(height: 20),
                  TextConst(title: "No Review Yet",color: Colors.grey,),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF6F7FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          childrenPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 10),

          onExpansionChanged: (value) {
            setState(() => expanded = value);
          },

          trailing: Icon(
            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.black87,
          ),

          title: TextConst(
            title:
            widget.question,
            size: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),

          children: [
            TextConst(
              title:
              widget.answer,
              size: 12,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
