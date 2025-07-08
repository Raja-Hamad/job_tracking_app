import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:job_tracking_app/models/interview_questions.dart';
import 'package:job_tracking_app/services/firestore_services.dart';
import 'package:job_tracking_app/utils/extensions/another_flushbar.dart';

class InterviewQuestionsController extends GetxController {
  final FirestoreServices _firestoreServices = FirestoreServices();
  var isLoading = false.obs;
  var textEditingControllerQuestion = TextEditingController().obs;
  var textEditingControllerAnswer = TextEditingController().obs;
  RxString difficulty = ''.obs;
  RxString skill = ''.obs;

  Future<void> addInterviewQuestion(
    InterviewQuestion model,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;
      await _firestoreServices.addInterviewQuestion(model, context);
      FlushBarMessages.successMessageFlushBar(
        "Interview Question added successfully",
        // ignore: use_build_context_synchronously
        context,
      );
    } catch (e) {
      FlushBarMessages.errorMessageFlushBar(
        "Error while uploading the question is ${e.toString()}",
        // ignore: use_build_context_synchronously
        context,
      );
      if (kDebugMode) {
        print("Error while uploading the question is ${e.toString()}");
      }
    } finally {
      isLoading.value = false;
    }
  }
  RxString selectedSkillFilter = ''.obs;

Stream<List<InterviewQuestion>> get filteredQuestionsStream {
  if (selectedSkillFilter.value.isEmpty) {
    // Fetch all questions
    return FirebaseFirestore.instance
        .collection('interview_questions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InterviewQuestion.fromMap(doc.data()))
            .toList());
  } else {
    // Fetch questions by selected skill
    return FirebaseFirestore.instance
        .collection('interview_questions')
        .where('skill', isEqualTo: selectedSkillFilter.value)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InterviewQuestion.fromMap(doc.data()))
            .toList());
  }
}

}
