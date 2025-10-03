import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyfood_note_test/controller/notes_controller.dart';
import 'package:heyfood_note_test/model/note_model.dart';
import 'package:heyfood_note_test/widgets/custom_button.dart';
import 'package:iconsax/iconsax.dart';

class AddNote extends StatefulWidget {
  final NotesModel? notesEdit;
  const AddNote({super.key, this.notesEdit});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final NotesController notesController = Get.put(NotesController());

  @override
  void initState() {
    super.initState();
    if (widget.notesEdit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notesController.titleController.text = widget.notesEdit!.title;
        notesController.textController.text = widget.notesEdit!.content;
        notesController.selectedCategory.value = widget.notesEdit!.category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notesEdit == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 20.h),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Obx(() => TextField(
                    readOnly: true,
                    onTap: () => showCategorySheet(context),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                      suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                      hintText: notesController.selectedCategory.value.isEmpty
                          ? 'Category'
                          : notesController.selectedCategory.value,
                    ),
                  )),
              SizedBox(height: 30.h),
              TextField(
                controller: notesController.titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                ),
              ),
              SizedBox(height: 30.h),
              TextField(
                controller: notesController.textController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Note content',
                ),
              ),
              SizedBox(height: 30.h),
              CustomButton(
                  text: widget.notesEdit == null ? 'Save note' : 'Update note',
                  onPressed: () {
                    if (widget.notesEdit == null) {
                      notesController.addNote();
                      notesController.discardNote();
                    } else {
                      notesController.updateNote(widget.notesEdit!);
                      notesController.discardNote();
                      notesController.selectedCategory.value = "All";
                    }
                  }),
              SizedBox(height: 30.h),
              CustomButton(
                  text: 'Disacrd',
                  onPressed: () {
                    notesController.discardNote();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void showCategorySheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30),
                    Text(
                      "Category",
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.cancel),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Iconsax.add_circle),
                  title: const Text("Add a new category"),
                  onTap: () {
                    showAddCategoryDialog(context);
                  },
                ),
                const Divider(height: 20),
                ...notesController.categories.map((cat) => ListTile(
                      title: Text(cat),
                      trailing: notesController.selectedCategory.value == cat
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () => notesController.selectCategory(cat),
                    )),
              ],
            )),
      ),
      barrierColor: Colors.black.withOpacity(0.3),
      isScrollControlled: true,
    );
  }

  void showAddCategoryDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    Get.defaultDialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      title: "New Category",
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(hintText: "Enter category name"),
      ),
      textConfirm: "Add",
      textCancel: "Cancel",
      onConfirm: () {
        notesController.addCategory(textController.text.trim());
        Get.back();
      },
    );
  }
}
