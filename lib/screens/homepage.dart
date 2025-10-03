import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyfood_note_test/controller/theme_controlller.dart';
import 'package:heyfood_note_test/screens/add_notes.dart';
import 'package:heyfood_note_test/screens/notes_info.dart';
import 'package:intl/intl.dart';
import '../controller/notes_controller.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('d MMMM').format(DateTime.now());
    final noteController = Get.put(NotesController());
    final ThemeController themeController = Get.find();

    final sortOptions = [
      'Date Created (Newest)',
      'Date Created (Oldest)',
      'Date Modified (Newest)',
      'Date Modified (Oldest)',
      'Alphabetically (A-Z)',
      'Alphabetically (Z-A)',
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(today),
                  Row(
                    children: [
                      PopupMenuButton<String>(
                        icon: Icon(Icons.sort, size: 24.sp),
                        tooltip: 'Sort by',
                        onSelected: (value) {
                          noteController.updateSortOption(value);
                        },
                        itemBuilder: (context) => sortOptions
                            .map(
                              (e) => PopupMenuItem(
                                value: e,
                                child: Obx(
                                  () => Row(
                                    children: [
                                      if (noteController
                                              .selectedSortOption.value ==
                                          e)
                                        Icon(Icons.check,
                                            size: 16.sp,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)
                                      else
                                        SizedBox(width: 16.sp),
                                      SizedBox(width: 8.w),
                                      Text(e),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Obx(() => Switch(
                            value: themeController.isDarkMode.value,
                            onChanged: (value) {
                              themeController.switchTheme();
                            },
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TextField(
                onChanged: (value) => noteController.updateSearch(value),
                decoration: InputDecoration(
                  hintText: "Search notes...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      noteController.categories.length + 1,
                      (index) {
                        final category = index == 0
                            ? "All"
                            : noteController.categories[index - 1];
                        final isSelected =
                            noteController.selectedCategory.value == category;
                        return GestureDetector(
                          onTap: () {
                            noteController.selectedCategory(category);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Expanded(
                child: Obx(() {
                  final notes = noteController.filteredNotes;
                  if (notes.isEmpty) {
                    return Center(
                      child: Text(
                        noteController.searchQuery.value.isEmpty
                            ? "You don't have any notes yet"
                            : "No results found",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    );
                  } else {
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      shrinkWrap: true,
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => NotesInfo(
                                  notes: note,
                                ));
                          },
                          onLongPress: () {
                            Get.defaultDialog(
                              title: "Delete Note",
                              middleText:
                                  "Are you sure you want to delete this note?",
                              textConfirm: "Delete",
                              textCancel: "Cancel",
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.red,
                              onConfirm: () {
                                noteController.deleteNote(index);
                                Get.back();
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10.w, bottom: 10.h),
                            padding: EdgeInsets.all(10.w),
                            width: 160.w,
                            height: 160.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      note.category,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Expanded(
                                  child: Text(
                                    note.content,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                                // SizedBox(height: 8.h),
                                Text(DateFormat('d MMM').format(note.createdAt))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () async {
            noteController.selectedCategory.value = "";
            await Get.to(() => const AddNote());
            noteController.selectedCategory.value = "All";
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          )),
    );
  }
}
