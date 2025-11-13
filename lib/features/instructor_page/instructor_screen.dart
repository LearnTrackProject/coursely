import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InstructorPage extends StatefulWidget {
  const InstructorPage({Key? key}) : super(key: key);

  @override
  State<InstructorPage> createState() => _InstructorPageState();
}

class _InstructorPageState extends State<InstructorPage> {
  final TextEditingController _videoLinkController = TextEditingController();
  String? _selectedCategory;
  final List<Map<String, String>> _videos = [];

  final List<String> _categories = [
    'UI Design',
    'State Management',
    'Firebase',
    'Animations',
    'Others',
    'English',
  ];

  void _addVideo() {
    if (_videoLinkController.text.isEmpty || _selectedCategory == null) return;
    setState(() {
      _videos.add({
        'link': _videoLinkController.text,
        'category': _selectedCategory!,
      });
      _videoLinkController.clear();
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: const Text("Instructor Profile"),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(AppImages.avatarImage),
                  ),
                  Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ahmed Samy",
                          style: TextStyles.textStyle18.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Flutter Instructor | Mobile Developer",
                          style: TextStyles.textStyle14.copyWith(
                            color: AppColors.gryColor,
                          ),
                        ),
                        Gap(6),
                        Text(
                          "Passionate about teaching and building mobile apps with Flutter.",
                          style: TextStyles.textStyle14.copyWith(
                            color: AppColors.gryColor,
                          ),
                        ),
                        Gap(6),
                        Row(
                          children: [
                            Expanded(
                              child: MainButton(
                                text: "Edit Profile",
                                style: TextStyles.textStyle14,
                                onPressed: () {
                                  Navigation.pushNamedTo(
                                    context,
                                    Routes.accountScreen,
                                  );
                                },
                                height: 40,
                              ),
                            ),
                            Gap(30),
                            Expanded(
                              child: Text(
                                // maxLines: 2,
                                "12 Videos | 3 Courses nnoinon |5K students",
                                style: TextStyles.textStyle14.copyWith(
                                  color: AppColors.gryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Add Video Card
            Text(
              "Add New Video",
            
            ),
            Gap(10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightGrey,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _videoLinkController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.link_outlined),
                      hintText: "Enter your video link (e.g. YouTube link)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Gap(12),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category_outlined),
                      labelText: "Select Category",
                    ),
                    items: _categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() {
                      _selectedCategory = val;
                    }),
                  ),
                  Gap(14),

                  MainButton(
                    text: 'Add Video',
                    style: TextStyles.textStyle14,
                    height: 50,
                    onPressed: _addVideo,
                  ),
                ],
              ),
            ),

            Gap(30),

            Text("Your Videos"),
            Gap(10),

            _videos.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SvgPicture.asset(AppImages.videoFilesSvg, width: 60),
                          Gap(10),
                          Text(
                            "No videos added yet.\nStart sharing your knowledge!",
                            textAlign: TextAlign.center,
                            style: TextStyles.textStyle14.copyWith(
                              color: AppColors.gryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _videos.length,
                    itemBuilder: (context, index) {
                      final video = _videos[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.lightBlue,
                        ),
                        child: ListTile(
                          leading: SvgPicture.asset(
                            AppImages.videoPlaysSvg,
                            width: 40,
                            colorFilter: ColorFilter.mode(
                              AppColors.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          title: Text(video['link'] ?? ''),
                          subtitle: Text(
                            "Category: ${video['category']}",
                            style: TextStyles.textStyle14.copyWith(
                              color: AppColors.gryColor,
                            ),
                          ),
                          trailing: IconButton(
                            icon: SvgPicture.asset(
                              AppImages.deleteSvg,
                              colorFilter: ColorFilter.mode(
                                AppColors.orange,
                                BlendMode.srcIn,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _videos.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
