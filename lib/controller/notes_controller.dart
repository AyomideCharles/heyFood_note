import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyfood_note_test/model/note_model.dart';

class NotesController extends GetxController {
  final RxList<NotesModel> notes = <NotesModel>[].obs;

  var categories = ["Work", "Personal", "Ideas", "Shopping"].obs;

  var selectedCategory = "All".obs;
  TextEditingController textController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  var searchQuery = "".obs;
  var selectedSortOption = 'Date Created (Newest)'.obs;

  void updateSortOption(String option) {
    selectedSortOption.value = option;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    Get.back();
  }

  void addCategory(String newCategory) {
    if (newCategory.isNotEmpty && !categories.contains(newCategory)) {
      categories.add(newCategory);
    }
  }

  void discardNote() {
    textController.clear();
    titleController.clear();
    selectedCategory.value = "";
  }

  List<NotesModel> get filteredNotes {
    var list = notes;

    if (selectedCategory.value != "All") {
      list = list
          .where((note) => note.category == selectedCategory.value)
          .toList()
          .obs;
    }

    if (searchQuery.value.isNotEmpty) {
      list = list
          .where((note) =>
              note.content
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              note.category
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList()
          .obs;
    }

    switch (selectedSortOption.value) {
      case 'Date Created (Newest)':
        notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Date Created (Oldest)':
        notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Date Modified (Newest)':
        notes.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
        break;
      case 'Date Modified (Oldest)':
        notes.sort((a, b) => a.modifiedAt.compareTo(b.modifiedAt));
        break;
      case 'Alphabetically (A-Z)':
        notes.sort((a, b) =>
            a.content.toLowerCase().compareTo(b.content.toLowerCase()));
        break;
      case 'Alphabetically (Z-A)':
        notes.sort((a, b) =>
            b.content.toLowerCase().compareTo(a.content.toLowerCase()));
        break;
    }

    return list;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void addNote() {
    if (textController.text.trim().isNotEmpty && selectedCategory.isNotEmpty) {
      notes.add(
        NotesModel(
          category: selectedCategory.value,
          content: textController.text.trim(),
          id: '',
          title: titleController.text.trim(),
        ),
      );
      textController.clear();
      selectedCategory.value = "";
      Get.back();
      Get.snackbar('Success', 'Note saved successfully');
    } else {
      Get.snackbar("Error", "Please select a category and enter some text");
    }
  }

  void deleteNote(int index) {
    notes.removeAt(index);
    Get.back();
  }

  void updateNote(NotesModel oldNote) {
    if (titleController.text.isEmpty || textController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    final index = notes.indexOf(oldNote);
    if (index != -1) {
      notes[index] = NotesModel(
        title: titleController.text,
        content: textController.text,
        category: selectedCategory.value,
        createdAt: oldNote.createdAt,
        id: oldNote.id,
      );
      Get.back();
      Get.back();

      Get.snackbar('Success', 'Note updated successfully');
    }
  }
}
