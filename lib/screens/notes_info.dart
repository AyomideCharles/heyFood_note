import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyfood_note_test/controller/notes_controller.dart';
import 'package:heyfood_note_test/model/note_model.dart';
import 'package:heyfood_note_test/screens/add_notes.dart';
import 'package:heyfood_note_test/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class NotesInfo extends StatelessWidget {
  final NotesModel notes;
  const NotesInfo({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NotesController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notes.category,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              notes.title,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              notes.content,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              DateFormat().format(
                notes.createdAt,
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(
              height: 40.h,
            ),
            CustomButton(
                text: 'Edit Note',
                onPressed: () {
                  Get.to(() => AddNote(
                        notesEdit: notes,
                      ));
                }),
            SizedBox(
              height: 20.h,
            ),
            CustomButton(
                text: 'Delete Note',
                onPressed: () {
                  Get.defaultDialog(
                    title: "Delete Note",
                    middleText: "Are you sure you want to delete this note?",
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      final index = noteController.filteredNotes.indexOf(notes);
                      noteController.deleteNote(index);
                      Get.back();
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
