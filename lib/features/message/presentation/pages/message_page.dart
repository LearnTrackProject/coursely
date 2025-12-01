import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
// import 'package:coursely/core/widgets/course_widget.dart';
import 'package:coursely/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/messages_cubit.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<MessagesCubit>().loadMessages();
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
              const Gap(20),
              Expanded(
                child: BlocBuilder<MessagesCubit, MessagesState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.error != null) {
                      return Center(child: Text('Error: ${state.error}'));
                    }

                    if (state.announcements.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 60,
                              color: AppColors.gryColor.withValues(alpha: 0.5),
                            ),
                            const Gap(10),
                            Text(
                              "No notifications yet",
                              style: TextStyles.textStyle14.copyWith(
                                color: AppColors.gryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.announcements.length,
                      itemBuilder: (context, index) {
                        final notification = state.announcements[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CustomContainer(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkgrey.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 9),
                                spreadRadius: 2,
                              ),
                            ],
                            padding: const EdgeInsets.all(12),
                            width: double.infinity,
                            color: AppColors.backGroundColor,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomContainer(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.notifications_active_outlined,
                                    color: AppColors.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification.title,
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(4),
                                      Text(
                                        notification.body,
                                        style: TextStyles.textStyle12.copyWith(
                                          color: AppColors.gryColor,
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        _formatDate(notification.createdAt),
                                        style: TextStyles.textStyle12.copyWith(
                                          fontSize: 10,
                                          color: AppColors.gryColor.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}
