import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class MessagePage extends StatelessWidget {
  final List<String> notification = [
    "Successful purchase!",
    "Congratulations on completing the  ...",
    "Your course has been updated, you  ...",
    "Congratulations, you have ...",
  ];

  List<Map<String, String>> messages = [
    {
      "title": "mohamed hossam",
      "desc":
          "Congratulations on completing the first lesson,  keep up the good work!",
    },
    {
      "title": "mazin",
      "desc":
          "Your course has been updated, you can check the new course in your study course.",
    },
    {"title": "menna", "desc": "Congratulations, you have completed your ..."},
    {"title": "qassim", "desc": "Congratulations, you have completed your ..."},
  ];
  MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notifications",
                  style: TextStyles.textStyle24.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TabBar(
                  indicatorWeight: 0.1,
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 70),
                  indicatorColor: AppColors.primaryColor,
                  labelColor: AppColors.secondaryColor,
                  unselectedLabelColor: Colors.black,
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
                  tabs: [
                    Tab(child: Center(child: Text("message"))),

                    Tab(child: Center(child: Text("notification"))),
                    // Tab(child: Center(child: Text("data"))),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: messages.length,

                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: MessageWidget(
                              title: messages[index]["title"] as String,
                              desc: messages[index]["desc"] as String,
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: notification.length,

                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomContainer(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.darkgrey.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 20,
                                  offset: Offset(0, 9),
                                  spreadRadius: 2,
                                ),
                              ],
                              padding: EdgeInsets.all(8),
                              width: double.infinity,
                              color: AppColors.backGroundColor,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      notification[index],
                                      maxLines: 1,
                                      style: TextStyles.textStyle12.copyWith(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    subtitle: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.watch_later,
                                          color: AppColors.gryColor,
                                          size: 15,
                                        ),
                                        Gap(5),
                                        Text(
                                          "Just Now",
                                          style: TextStyles.textStyle12
                                              .copyWith(
                                                fontWeight: FontWeight.w300,
                                                color: AppColors.gryColor
                                                    .withValues(alpha: 0.8),
                                              ),
                                        ),
                                      ],
                                    ),
                                    leading: CustomContainer(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: Icon(
                                        Icons.notifications_active_outlined,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    trailing: Text("04:32 pm"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String title;
  final String desc;
  const MessageWidget({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      boxShadow: [
        BoxShadow(
          color: AppColors.darkgrey.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: Offset(0, 9),
          spreadRadius: 2,
        ),
      ],
      padding: EdgeInsets.all(8),
      width: double.infinity,
      color: AppColors.backGroundColor,
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyles.textStyle14.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("online"),
            leading: CustomContainer(
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              width: 50,
              height: 50,
              child: Icon(Icons.message),
            ),
            trailing: Text("04:32 pm"),
          ),

          Text(
            desc,
            style: TextStyles.textStyle12.copyWith(color: AppColors.gryColor),
          ),
        ],
      ),
    );
  }
}
