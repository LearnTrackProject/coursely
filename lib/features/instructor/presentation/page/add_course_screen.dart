import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/features/course/data/models/lesson.dart';
import 'package:coursely/features/instructor/presentation/cubit/add_course_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _whatToLearnController = TextEditingController(); // Comma separated

  // Lesson Controllers
  final _lessonTitleController = TextEditingController();
  final _lessonUrlController = TextEditingController();
  final _lessonDurationController = TextEditingController();
  bool _isFreeLesson = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _whatToLearnController.dispose();
    _lessonTitleController.dispose();
    _lessonUrlController.dispose();
    _lessonDurationController.dispose();
    super.dispose();
  }

  void _addLesson(BuildContext context) {
    if (_lessonTitleController.text.isEmpty ||
        _lessonUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill lesson title and URL')),
      );
      return;
    }

    final lesson = Lesson(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _lessonTitleController.text,
      videoUrl: _lessonUrlController.text,
      duration: _lessonDurationController.text,
      isFree: _isFreeLesson,
    );

    context.read<AddCourseCubit>().addLesson(lesson);

    // Clear inputs
    _lessonTitleController.clear();
    _lessonUrlController.clear();
    _lessonDurationController.clear();
    setState(() {
      _isFreeLesson = false;
    });
    Navigator.pop(context);
  }

  void _showAddLessonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Lesson'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _lessonTitleController,
                  decoration: const InputDecoration(labelText: 'Lesson Title'),
                ),
                const Gap(10),
                TextField(
                  controller: _lessonUrlController,
                  decoration: const InputDecoration(labelText: 'Video URL'),
                ),
                const Gap(10),
                TextField(
                  controller: _lessonDurationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (e.g. 10:00)',
                  ),
                ),
                const Gap(10),
                SwitchListTile(
                  title: const Text('Free Preview?'),
                  value: _isFreeLesson,
                  onChanged: (val) => setState(() => _isFreeLesson = val),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _addLesson(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCourseCubit(),
      child: BlocConsumer<AddCourseCubit, AddCourseState>(
        listener: (context, state) {
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Course added successfully!')),
            );
            Navigator.pop(context);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add New Course'),
              backgroundColor: AppColors.primaryColor,
            ),
            body: state.loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Picker
                          GestureDetector(
                            onTap: () =>
                                context.read<AddCourseCubit>().pickImage(),
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                                image: state.courseImage != null
                                    ? DecorationImage(
                                        image: FileImage(state.courseImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: state.courseImage == null
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Tap to add course cover (Landscape)',
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                          const Gap(20),

                          // Course Details
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Course Title',
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          const Gap(10),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                            maxLines: 3,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _priceController,
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (v) =>
                                      v!.isEmpty ? 'Required' : null,
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: TextFormField(
                                  controller: _categoryController,
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                  ),
                                  validator: (v) =>
                                      v!.isEmpty ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          TextFormField(
                            controller: _whatToLearnController,
                            decoration: const InputDecoration(
                              labelText: 'What to learn (comma separated)',
                              hintText: 'Flutter, Dart, State Management',
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),

                          const Gap(20),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Lessons',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _showAddLessonDialog(context),
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),

                          if (state.lessons.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: Text('No lessons added yet'),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.lessons.length,
                              itemBuilder: (context, index) {
                                final lesson = state.lessons[index];
                                return ListTile(
                                  leading: Icon(
                                    lesson.isFree
                                        ? Icons.lock_open
                                        : Icons.lock,
                                    color: lesson.isFree
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  title: Text(lesson.title),
                                  subtitle: Text(lesson.duration),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => context
                                        .read<AddCourseCubit>()
                                        .removeLesson(index),
                                  ),
                                );
                              },
                            ),

                          const Gap(30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AddCourseCubit>().submitCourse(
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    price:
                                        double.tryParse(
                                          _priceController.text,
                                        ) ??
                                        0,
                                    category: _categoryController.text,
                                    whatToLearn: _whatToLearnController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .where((e) => e.isNotEmpty)
                                        .toList(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Create Course'),
                            ),
                          ),
                          const Gap(20),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
