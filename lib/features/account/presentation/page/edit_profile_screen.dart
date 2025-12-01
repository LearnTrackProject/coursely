import 'dart:io';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:coursely/core/widgets/custom_text_field.dart';
import 'package:coursely/features/account/presentation/cubit/account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    final student = context.read<AccountCubit>().state.student;
    _nameController = TextEditingController(text: student?.name);
    _professionController = TextEditingController(text: student?.profession);
    _bioController = TextEditingController(text: student?.bio);
    _phoneController = TextEditingController(text: student?.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyles.textStyle18.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.secondaryColor,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (!state.loading && state.error == null) {
            // Optional: Show success message
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (state.student?.imageUrl != null &&
                                          state.student!.imageUrl!.isNotEmpty
                                      ? NetworkImage(state.student!.imageUrl!)
                                      : const AssetImage(
                                          'assets/images/welcome.png',
                                        ))
                                  as ImageProvider,
                        backgroundColor: AppColors.gryColor,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primaryColor,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(30),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: "Full Name",
                  preffixIcon: const Icon(Icons.person_outline),
                ),
                const Gap(16),
                CustomTextFormField(
                  controller: _professionController,
                  hintText: "Profession (e.g. Flutter Developer)",
                  preffixIcon: const Icon(Icons.work_outline),
                ),
                const Gap(16),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: "Phone Number",
                  preffixIcon: const Icon(Icons.phone_outlined),
                ),
                const Gap(16),
                CustomTextFormField(
                  controller: _bioController,
                  hintText: "Bio",
                  preffixIcon: const Icon(Icons.info_outline),
                  maxLines: 3,
                ),
                const Gap(40),
                state.loading
                    ? const CircularProgressIndicator()
                    : MainButton(
                        text: "Save Changes",
                        onPressed: () {
                          context.read<AccountCubit>().updateProfile(
                            name: _nameController.text,
                            profession: _professionController.text,
                            bio: _bioController.text,
                            phone: _phoneController.text,
                            imageFile: _imageFile,
                          );
                          context.pop();
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
