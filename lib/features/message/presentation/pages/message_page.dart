import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
// import 'package:coursely/core/widgets/course_widget.dart';
import 'package:coursely/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/messages_cubit.dart';

class MessagePage extends StatefulWidget {
  final List<String> notification = [
    "Successful purchase!",
    "Congratulations on completing the  ...",
    "Your course has been updated, you  ...",
    "Congratulations, you have ...",
  ];

  final List<Map<String, String>> messages = [
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
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late final TextEditingController titleController;
  late final TextEditingController bodyController;
  late final TextEditingController courseIdController;
  late final TextEditingController videoController;
  String? _selectedCourseId;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    bodyController = TextEditingController();
    courseIdController = TextEditingController();
    videoController = TextEditingController();
    // ensure messages are loaded when the page is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<MessagesCubit>().loadMessages();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    courseIdController.dispose();
    videoController.dispose();
    super.dispose();
  }

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
                      BlocBuilder<MessagesCubit, MessagesState>(
                        builder: (context, state) {
                          if (state.loading)
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          if (state.error != null)
                            return Center(child: Text('Error: ${state.error}'));

                          final cubit = context.read<MessagesCubit>();

                          return Column(
                            children: [
                              if (state.isInstructor) ...[
                                // simple composer for instructor
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: state.instructorCourses.isNotEmpty
                                      ? DropdownButtonFormField<String>(
                                          value: _selectedCourseId,
                                          decoration: InputDecoration(
                                            labelText: 'Select Course',
                                            border: OutlineInputBorder(),
                                          ),
                                          items: state.instructorCourses
                                              .map(
                                                (c) => DropdownMenuItem(
                                                  value: c.id,
                                                  child: Text(c.title),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (v) {
                                            setState(() {
                                              _selectedCourseId = v;
                                            });
                                          },
                                        )
                                      : TextField(
                                          controller: courseIdController,
                                          decoration: InputDecoration(
                                            labelText: 'Course ID',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TextField(
                                    controller: videoController,
                                    decoration: InputDecoration(
                                      labelText: 'Video URL (optional)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TextField(
                                    controller: bodyController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: 'Message body',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final courseId =
                                          _selectedCourseId ??
                                          courseIdController.text.trim();
                                      final title = titleController.text.trim();
                                      final body = bodyController.text.trim();
                                      final video = videoController.text.trim();
                                      if (courseId.isEmpty ||
                                          title.isEmpty ||
                                          body.isEmpty)
                                        return;
                                      await cubit.sendAnnouncement(
                                        courseId: courseId,
                                        title: title,
                                        body: body,
                                        videoUrl: video.isEmpty ? null : video,
                                      );
                                      titleController.clear();
                                      bodyController.clear();
                                      courseIdController.clear();
                                      videoController.clear();
                                      setState(() {
                                        _selectedCourseId = null;
                                      });
                                    },
                                    child: Text('Send'),
                                  ),
                                ),
                                SizedBox(height: 12),
                              ],

                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.announcements.length,
                                  itemBuilder: (context, index) {
                                    final a = state.announcements[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: MessageWidget(
                                        title: a.title,
                                        desc:
                                            '${a.body}${a.videoUrl != null ? '\nVideo: ${a.videoUrl}' : ''}',
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: widget.notification.length,

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
                                      widget.notification[index],
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
